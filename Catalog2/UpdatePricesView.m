//
//  UpdatePricesView.m
//  Catalog2
//
//  Created by Ashley McCoy on 10/12/12.
//  Copyright (c) 2012 Mindeater Web Services. All rights reserved.
//

#import "UpdatePricesView.h"
#import "LoadHPMData.h"

static NSString * const kSeperator = @"|";

@interface UpdatePricesView ()

@end

@implementation UpdatePricesView
@synthesize verbose,output, status;
@synthesize pLists;
@synthesize context = _context;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]autorelease];
    self.view.backgroundColor = [UIColor blackColor];
    // Message
    UILabel *message = [[UILabel alloc]initWithFrame:CGRectMake(0,100,self.view.bounds.size.width,100)];
    message.adjustsFontSizeToFitWidth = YES;
    message.text = @"Application Update in Progress ...";
    message.textAlignment = UITextAlignmentCenter;
    message.textColor = [UIColor whiteColor];
    message.backgroundColor = [UIColor blackColor];
    message.font = [UIFont boldSystemFontOfSize:(36.0)];
    [self.view addSubview:message];
    [message release];
    
    self.status = [[UILabel alloc]initWithFrame:CGRectMake(0,200,self.view.bounds.size.width,100)];
    status.adjustsFontSizeToFitWidth = YES;
    status.text = @"";
    status.textAlignment = UITextAlignmentCenter;
    status.textColor = [UIColor whiteColor];
    status.backgroundColor = [UIColor blackColor];
    status.font = [UIFont boldSystemFontOfSize:(24.0)];
    [self.view addSubview:status];
    
    
    if(!self.verbose){
        self.verbose = YES;
        self.output = [[UITextField alloc] initWithFrame:CGRectMake(10, 200,
                                                                    self.view.bounds.size.width -20,
                                                                    self.view.bounds.size.height - 200)];
    }else{
        
    }
    
    /// Activity Indicator
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicator.center = CGPointMake(self.view.bounds.size.width /2, self.view.bounds.size.height /2);
    [self.view addSubview:activityIndicator];
    [activityIndicator startAnimating];
    [activityIndicator release];
	// Do any additional setup after loading the view.
    
    LoadHPMData *dataloader = [[LoadHPMData alloc]init];
    self.pLists = dataloader.pListFiles;
    [dataloader release];
    fileCount = self.pLists.count;
    fileIndex = 0;
    [self startUpdate];
    

}

-(void) updateStatuswithMessage:(NSString *)message
{
    self.status.text = message;
}

-(void) startUpdate
{
    [self updateStatuswithMessage:@"...starting updates ..."];
    [self readNextFile];
}

-(void) readNextFile
{
    // catch completion
    if(fileIndex +1 == fileCount){
        [self finishUpdate];
        return;
    }
    [self updateStatuswithMessage:
        [NSString stringWithFormat:@"... loading %d / %d Updates ...",
         (int)fileIndex +1,
         (int)fileCount ]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),^{
        // process the file
        NSLog(@"processing %@",[[self.pLists objectAtIndex:fileIndex]objectAtIndex:0]);
        [NSThread sleepForTimeInterval:1.0];
        [self processFile];
        dispatch_async(dispatch_get_main_queue(), ^{
            fileIndex ++;
            [self readNextFile];
            
        });
    });
    
}

-(void) finishUpdate
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)processFile
{
    // grab the file
    NSString *plistPath = [[NSBundle mainBundle]
                           pathForResource: [[self.pLists objectAtIndex:fileIndex]objectAtIndex:0]
                           ofType:@"plist"];
    
    NSDictionary *fileContents = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    
    
    NSDictionary *catInBrand = [fileContents objectForKey:[[self.pLists objectAtIndex:fileIndex]objectAtIndex:0]];
    
    // Loop categories
    NSEnumerator *enumerator = [catInBrand keyEnumerator];
    id catName;
    //categoryMenuOrder = 1;
    while ((catName = [enumerator nextObject])) {
        //NSArray *catNameParts = [catName componentsSeparatedByString:kSeperator];
        
        // Loop products
        NSEnumerator *catEnum = [[catInBrand objectForKey:catName] keyEnumerator];
        id product;
        // productMenuOrder = 1;
        
        while((product = [catEnum nextObject])){
            NSArray *prodNameParts = [product componentsSeparatedByString:kSeperator];
          
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
                            NSLog(@" - Mech %@ price %f",value,[nextValue floatValue]);
                            //NSLog(@" %d",[@"1" intValue]);
                            // NSLog(@"%@",heading);
                            [self updateEntity:@"Mechanism"
                                 withNameField:value
                                andProductName:[prodNameParts objectAtIndex:0]
                                      andPrice:[nextValue floatValue]];
                                                    
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
                        
                        
                        i+=3;
                    }
                    
                }else{
                    // FacePlates
                    // next : Trade Price
                    if([nextHeading isEqualToString:@"Trade Price"]){
                        if (![value isEqualToString:@""]) {
                            // push in the FacePlate
                            NSLog(@"6. - - - - - Plate %@ price %@",value,nextValue);
                            
                            
                            i++;
                        }
                        
                    }
                }
                
            }//end parts loop
            
            
            
            
        }// end products loop
    }
    
   
}

-(void) updateEntity:(NSString *)entityName
       withNameField:(NSString *)entityNameField
      andProductName:(NSString *)productName
            andPrice:(float)value
{
    // entityType will be Faceplate or Mechanism
    // how to make sure the part is uniquly identified ??
    
    NSLog(@"\n\n%s",__FUNCTION__);
    NSLog(@"PASSED: \nEntityName:%@\nentityNAmeField:%@\nproductName:%@\nprice:%f",
          entityName,entityNameField,productName,value);
    NSError *error=nil;
    
    
    ////////////////////////////////////
    /// Is there a Dataset Available ??
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:_context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@ AND %K == %@)",
                                                            @"id",entityNameField,
                                                            @"product.name",productName];
    
    [request setPredicate:predicate];
    
    NSArray *result = [_context executeFetchRequest:request error:&error];
    [request release];
    //NSLog(@"%@",result);
    if(result.count >0){
        NSManagedObject *retrived = [result objectAtIndex:0];
        NSLog(@"GOT : %@ price: %f",[retrived valueForKey:@"id"],[[retrived valueForKey:@"price"] doubleValue]);
        if([[retrived valueForKey:@"price"] floatValue] != value){
            [retrived setValue:[NSNumber numberWithFloat:value]
              forKey:@"price"];
            [_context save:&error];
            self.output.text = [self.output.text stringByAppendingFormat:@"%@ updated from %@ to %f\n",
                                entityName,[retrived valueForKey:@"price"],value];
        }
    }
    /*
    // 1. create a fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName
                                              inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    
    
    // 2. set up the predicate
    // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@) && (%K == %@)",@"name",entityNameField,@"product.name",productName];
    // NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",@"name",entityNameField];

    //[fetchRequest setPredicate:predicate];
    
    // 2.1 sorting ?
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    
    // 3. make the Fetch Request
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:_context sectionNameKeyPath:nil
                                                   cacheName:nil];
    
    theFetchedResultsController.delegate = self;
    
    NSLog(@"RESULTS :\n\n %@",theFetchedResultsController.fetchedObjects);
     */
    // 4. Update the entity
    /*
    NSManagedObject *entity = [results.fetchedObjects objectAtIndex:indexRow];
    
    [entity setValue:value
              forKey:@"price"];
    // 5. Save the context
       */
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
