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
    NSError *error = nil;
    // does the entity already exist ??
    /*TOO COMPLEX !!
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *existingEntity = [NSEntityDescription entityForName:entity
                                              inManagedObjectContext:self.context];
    // Mechanism uses id ad the Unique identifier - yeah :(
    NSPredicate *predicate;
    if([entity isEqualToString:@"Mechanism"]){
        predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",
                     @"id",
                     [keyValues objectForKey:@"id"]];
    }else{
        predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",
                              @"name",
                              [keyValues objectForKey:@"name"]];
    }
    [request setPredicate:predicate];
    
    [request setEntity:existingEntity];
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    [request release];
    if([result lastObject]){
        NSLog(@"\n\n     Existing Entity : %@\n\n\n",[keyValues objectForKey:@"name"]);
        return [result lastObject];
    }
     */
    // if not create it
    
    NSManagedObject *newEntity = [NSEntityDescription 
                                 insertNewObjectForEntityForName:entity 
                                 inManagedObjectContext:self.context];
    NSString *key;
    for(key in keyValues){
       // NSLog(@"Key: %@, Value %@", key, [keyValues objectForKey: key]);
        [newEntity setValue:[keyValues objectForKey: key] forKey:key];
    }
    
    [self.context insertObject:newEntity];
    [self.context save:&error];
    
    if(error){
        
        NSLog(@" Error adding %@ with %@ \n \nError: %@\n\n",entity,keyValues,[error localizedDescription]);
    } 
    return newEntity;
}


-(NSDictionary *)readPlist:(NSString *)pListName
{
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:pListName ofType:@"plist"];
    return [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
}

-(void)processFiles
{
    int brandMenuOrder = 1;
    //int categoryMenuOrder = 1;
    //int productMenuOrder = 1;
    
    for (NSArray *brand in self.pListFiles) {
         
        
        NSDictionary *pListData = [self readPlist:[brand objectAtIndex:0]];
        
        
        // insert Brand 
        NSManagedObject *brandObj = [self addEntityWithValues:@"Brand":
                                         [NSDictionary dictionaryWithObjectsAndKeys:
                                          [brand objectAtIndex:1],@"name",
                                          [brand objectAtIndex:2],@"heading",
                                          [NSNumber numberWithInt:brandMenuOrder++],@"menuOrder",
                                          nil]];
         
        NSLog(@"1. Brand INSERT : %@",[brand objectAtIndex:1]);
        
        NSDictionary *catInBrand = [pListData objectForKey:[brand objectAtIndex:0]];
        
        // Loop categories
        NSEnumerator *enumerator = [catInBrand keyEnumerator];
        id catName;
        //categoryMenuOrder = 1;
        while ((catName = [enumerator nextObject])) {
            
            ////////////////////////////////////
            //insert Each Category
            NSArray *catNameParts = [catName componentsSeparatedByString:@"|"];
            NSManagedObject *catObj = [self addEntityWithValues:@"Category":
                                             [NSDictionary dictionaryWithObjectsAndKeys:
                                              //catName,@"name",
                                              [catNameParts objectAtIndex:0],@"name",
                                              brandObj,@"brand",
                                              //[NSNumber numberWithInt:categoryMenuOrder++],@"menuOrder",
                                              [NSNumber numberWithInt:[[catNameParts objectAtIndex:1] intValue]],@"menuOrder",
                                              nil]];
             NSLog(@"2. - Category INSERT : %@",catName);
            
            // Loop products
            NSEnumerator *catEnum = [[catInBrand objectForKey:catName] keyEnumerator];
            id product;
           // productMenuOrder = 1;
            
            while((product = [catEnum nextObject])){
                /////////////////////////////////////////////////////
                // get the orientation Horizontal or Vertical or Both
                NSString *orientation;
                NSRange range = [catName rangeOfString:@"Vertical"];
                if (range.location != NSNotFound){
                    orientation = @"Vertical";
                    NSRange range2 = [catName rangeOfString:@"Horizontal"];
                    if(range2.location != NSNotFound){
                        // Linea uses Vertical as does Excel Life and Excel
                        if([[brand objectAtIndex:1] isEqualToString:@"Linea"] 
                           || [[brand objectAtIndex:1] isEqualToString:@"Excel Life"]
                           || [[brand objectAtIndex:1] isEqualToString:@"Excel"]){
                            orientation = @"Vertical";
                        }else if([[brand objectAtIndex:1] isEqualToString:@"Arteor 770"]){
                            // Arteor 770 uses horizontal
                            orientation = @"Horizontal";
                        }else{
                            orientation = @"Both";
                        }
                    }
                }else{
                    orientation = @"Horizontal";
                }

                NSArray *prodNameParts = [product componentsSeparatedByString:@"|"];
                NSManagedObject *productObj = [self addEntityWithValues:@"Product":
                                           [NSDictionary dictionaryWithObjectsAndKeys:
                                           // product,     @"name",
                                            [prodNameParts objectAtIndex:0],@"name",
                                            brandObj,    @"brand",
                                            catObj,      @"category",
                                            orientation, @"orientation",
                                            //[NSNumber numberWithInt:productMenuOrder++],@"menuOrder",
                                            [NSNumber numberWithInt:[[prodNameParts objectAtIndex:1] intValue]],@"menuOrder",
                                            nil]];
                 
                NSLog(@"3. - - Product INSERT : %@",product);
                
                NSArray *keys = [[catInBrand objectForKey:catName] objectForKey:product];
                
                // Loop product parts
                for(int i=0; i<[keys count];i++){
                   // NSLog(@"\n\n\n %d \n\n\n",i);
                    NSString *heading =     [[[keys objectAtIndex:i]   allKeys]    lastObject];
                    NSString *value =       [[[keys objectAtIndex:i]   allObjects] lastObject];
                    NSString *nextHeading = [[[keys objectAtIndex:i+1] allKeys]    lastObject];
                    NSString *nextValue =   [[[keys objectAtIndex:i+1] allObjects] lastObject];
                    
                    NSLog(@"4. - - - - PART NAME : %@ ->",heading);
                    
                    if ([heading isEqualToString:@"Mechanism 1"]
                        ||[heading isEqualToString:@"Frame"]
                        ||[heading isEqualToString:@"Mechanism 3"]
                        ||[heading isEqualToString:@"Mechanism 2"]){
                        // check the next one is : Trade Price
                        if([nextHeading isEqualToString:@"Trade Price"]){
                            if (![value isEqualToString:@""]) {
                               // push in the mechanism 
                                //NSLog(@" - Mech %@ price %f",value,[nextValue doubleValue]);
                                //NSLog(@" %d",[@"1" intValue]);
                               // NSLog(@"%@",heading);
                                
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
                            NSLog(@"5. -  - - - Mechanism %@ price %@ quan %@",value,price,nextValue);
                            
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
                                NSLog(@"6. - - - - - Plate %@ price %@",value,nextValue);
                                
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
    self.pListFiles = [NSArray arrayWithObjects:
                       [NSArray arrayWithObjects:@"excel-life.csv",   @"Excel Life", @"Legrand EXCEL LIFE", nil],
                       [NSArray arrayWithObjects:@"arteor-sq.csv",    @"Arteor SQ",  @"Legrand ARTEOR SQUARE", nil],
                       [NSArray arrayWithObjects:@"arteor-rd.csv",    @"Arteor RD",  @"Legrand ARTEOR ROUND", nil],
                       [NSArray arrayWithObjects:@"arteor-770.csv",   @"Arteor 770", @"Legrand ARTEOR AUSTRALIAN STYLE", nil],
                       [NSArray arrayWithObjects:@"linea.csv",        @"Linea",      @"HPM LINEA", nil],
                       [NSArray arrayWithObjects:@"excel.csv",        @"Excel",      @"HPM EXCEL", nil],
                        /*[NSArray arrayWithObjects:@"bt-light-and-tech.csv", @"BT Light and Tech",nil],
                        [NSArray arrayWithObjects:@"bt-living.csv",     @"BT Living",nil],
                        */
                        nil];

    return self;
}

@end
