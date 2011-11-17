//
//  LoadHPMData.m
//  Catalog2
//
//  Created by Ashley McCoy on 11/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "LoadHPMData.h"

@implementation LoadHPMData

@synthesize context;
@synthesize pListFiles;


-(void)dealloc
{
    [context release];
    [pListFiles release];
    [super dealloc];
}

-(NSManagedObject *)addEntityWithValues:(NSString*)entity:(NSDictionary *)keyValues
{
    NSLog(@" - Insertinto : %@",entity);
    NSError *error = nil;
    NSManagedObject *newEntity = [NSEntityDescription 
                                 insertNewObjectForEntityForName:entity 
                                 inManagedObjectContext:self.context];
    NSString *key;
    for(key in keyValues){
        NSLog(@"Key: %@, Value %@", key, [keyValues objectForKey: key]);
        [newEntity setValue:[keyValues objectForKey: key] forKey:key];
    }
    
    
    [self.context insertObject:newEntity];
    [self.context save:&error];
    if(error){
        NSLog(@" Error adding %@ with %@ \n Error: %@",entity,keyValues,[error localizedDescription]);
    } 
    return newEntity;
}
-(void)extractBrandsFrom:(NSDictionary *)dictionary
{
    
}
-(void)extractCategoriesFrom:(NSDictionary *)dictionary
{
    
}
-(void)extractProductsFrom:(NSDictionary *)dictionary
{
    
}
-(void)extractMechanismsFrom:(NSDictionary *)dictionary
{
    
}
-(void)extractFacePlatesFrom:(NSDictionary *)dictionary;
{
    
}

-(NSDictionary *)readPlist:(NSString *)pListName
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:pListName ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
}

-(void)processFiles
{
    for (NSArray *brand in self.pListFiles) {
         
        
        NSDictionary *pListData = [self readPlist:[brand objectAtIndex:0]];
        NSLog(@"Started");
        // insert Brand 
        
        NSManagedObject *brandObj = [self addEntityWithValues:@"Brand":
                                         [NSDictionary dictionaryWithObject:[brand objectAtIndex:1]forKey:@"name" ]];
         
        NSLog(@"Brand : %@",[brand objectAtIndex:1]);
        
        NSDictionary *catInBrand = [pListData objectForKey:[brand objectAtIndex:0]];
        
        // Loop categories
        NSEnumerator *enumerator = [catInBrand keyEnumerator];
        id catName;
        while ((catName = [enumerator nextObject])) {
            
            //insert Cat
            NSLog(@" - Category: %@",catName);
            NSManagedObject *catObj = [self addEntityWithValues:@"Category":
                                             [NSDictionary dictionaryWithObjectsAndKeys:
                                              catName,@"name",
                                              brandObj,@"brand",
                                              nil]];
             
            
            // Loop products
            NSEnumerator *catEnum = [[catInBrand objectForKey:catName] keyEnumerator];
            id product;
            while((product = [catEnum nextObject])){
            
                //insert product
                
                NSManagedObject *productObj = [self addEntityWithValues:@"Product":
                                           [NSDictionary dictionaryWithObjectsAndKeys:
                                            product,@"name",
                                            brandObj,@"brand",
                                            catObj,@"category",
                                            nil]];
                 
                NSLog(@" - - Product : %@",product);
                
                NSArray *keys = [[catInBrand objectForKey:catName] objectForKey:product];
                
                // Loop product parts
                for(int i=0; i<[keys count];i++){
                   //  NSLog(@"\n\n\n %d \n\n\n",i);
                    NSString *heading = [[[keys objectAtIndex:i] allKeys] lastObject];
                    NSString *value = [[[keys objectAtIndex:i] allObjects] lastObject];
                    NSString *nextHeading = [[[keys objectAtIndex:i+1] allKeys] lastObject];
                    NSString *nextValue = [[[keys objectAtIndex:i+1] allObjects] lastObject];
                    NSLog(@"%@ ->",heading);
                    if ([heading isEqualToString:@"Mechanism 1"]
                        ||[heading isEqualToString:@"Frame"]
                        ||[heading isEqualToString:@"Mechanism 3"]
                        ||[heading isEqualToString:@"Mechanism 2"]){
                        // next : Trade Price
                        if([nextHeading isEqualToString:@"Trade Price"]){
                            if (![value isEqualToString:@""]) {
                               // push in the mechanism 
                                NSLog(@" - Mech %@ price %f",value,[nextValue doubleValue]);
                                NSLog(@" %d",[@"1" intValue]);
                                NSLog(@"%@",heading);
                                
                               // NSManagedObject *mechObj = 
                                [self addEntityWithValues:@"Mechanism":
                                                               [NSDictionary dictionaryWithObjectsAndKeys:
                                                                heading,                 @"name",
                                                                [NSNumber numberWithDouble:[nextValue doubleValue]], @"price",
                                                                [NSNumber numberWithInt:1],         @"count",
                                                                value,                   @"id",
                                                                productObj,              @"product",
                                                                nil]
                                                            ];
                                
                            }
                            i++;
                        }

                    }else if([heading isEqualToString:@"Mech 1 Part #"]
                        ||[heading isEqualToString:@"Mech 2 Part #"]) {
                       // next : quantity : tradeprice : mech n price
                        if (![value isEqualToString:@""]) {
                            
                            //NSNumber *quantity = [nextValue intValue];
                            //NSNumber *price = [[[productParts objectForKey:[keys objectAtIndex:i+2]]allObjects]lastObject];
                            NSString *price = [[[keys objectAtIndex:i+2] allObjects] lastObject];
                            // push in the mechanism
                            NSLog(@" - Mech %@ price %@ quan %@",value,price,nextValue);
                            
                            //NSManagedObject *mechObj = 
                            [self addEntityWithValues:@"Mechanism":
                                                        [NSDictionary dictionaryWithObjectsAndKeys:
                                                         heading,@"name",
                                                         [NSNumber numberWithDouble:[price doubleValue]],@"price",
                                                         [NSNumber numberWithInt:[nextValue intValue]],@"count",
                                                         value,@"id",
                                                         productObj,@"product",
                                                         nil]];
                            i+=3;
                        }
                        
                    }else{
                        // FacePlates
                        // next : Trade Price
                        if([nextHeading isEqualToString:@"Trade Price"]){
                            if (![value isEqualToString:@""]) {
                                // push in the FacePlate
                                NSLog(@" - - Plate %@ price %@",value,nextValue);
                                
                               // NSManagedObject *plateObj = 
                                [self addEntityWithValues:@"Faceplate":
                                                            [NSDictionary dictionaryWithObjectsAndKeys:
                                                             heading,@"name",
                                                             [NSNumber numberWithDouble:[nextValue doubleValue]],@"price",
                                                             value,@"id",
                                                             productObj,@"product",
                                                             nil]];
                                i++;
                            }
                            
                        }
                    }
                    
                }//end parts loop
                
            }// end product enumerator
            
        }// end category enumerator
        
    }
}
-(id)init
{
    NSLog(@"INIT");
    self.pListFiles = [NSArray arrayWithObjects:
                       [NSArray arrayWithObjects:@"arteor-770.csv",    @"Arteor 770",nil],
                       [NSArray arrayWithObjects:@"arteor-rd.csv",     @"Arteor RD",nil],
                        [NSArray arrayWithObjects:@"arteor-sq.csv",     @"Arteor SQ",nil],
                       /* [NSArray arrayWithObjects:@"bt-light-and-tech.csv", @"BT Light and Tech",nil],
                        [NSArray arrayWithObjects:@"bt-living.csv",     @"BT Living",nil],
                        [NSArray arrayWithObjects:@"excel-life.csv",   @"Excel Life",nil],
                        [NSArray arrayWithObjects:@"excel.csv",        @"Excel",nil],
                        [NSArray arrayWithObjects:@"linea.csv",        @"Linea",nil],
                        */nil];

    return self;
}

@end
