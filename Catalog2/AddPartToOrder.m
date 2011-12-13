//
//  AddPartToOrder.m
//  Catalog2
//
//  Created by Ashley McCoy on 6/12/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "AddPartToOrder.h"

@implementation AddPartToOrder

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

@synthesize currentOrderLine;

#pragma mark - Core Data

/*
 * get the currently active order to use
 */

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Order" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate 
                              predicateWithFormat:@"(active = YES)"];//,
    //@"active"];//],[[NSNumber numberWithBool: YES] description]];
    [fetchRequest setPredicate:predicate];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"name" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:1];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:_context sectionNameKeyPath:nil 
                                                   cacheName:nil];
    
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    [sort release];
    [fetchRequest release];
    [theFetchedResultsController release];
    
    return _fetchedResultsController;    
    
}

-(id)init{
    self = [super init];
    
    return self;
}

-(void)setUpFetchedResultsController
{
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    //NSLog(@" +++ = == \n%@\n\n\n",self.fetchedResultsController.fetchedObjects);
    if([self.fetchedResultsController.fetchedObjects lastObject] == nil){
        ////////////////////////////
        // DEFAULT
        // Create a new Entity
        
        // Create a new instance of the entity managed by the fetched results controller.
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
        
        NSManagedObject *newEntity = [NSEntityDescription 
                                      insertNewObjectForEntityForName:[entity name] inManagedObjectContext:[self.fetchedResultsController managedObjectContext]];
        
        //  NSDate *date  = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
        [newEntity setValue:@"New Order" forKey:@"name"];
        [newEntity setValue:
         [NSString stringWithFormat:@"%d", [[NSProcessInfo processInfo] globallyUniqueString]]
                     forKey:@"uniqueId"];
        [newEntity setValue:[NSNumber numberWithBool:YES] forKey:@"active"];
        
        [self.context insertObject:newEntity];
        [self.context save:&error];
        
        // reload the result set
        //[[self fetchedResultsController] performFetch:&error];
    }

}


-(void)setActiveOrderLine:(NSString *)productName
{
    //NSLog(@"Setting Active Orderline with %@",productName);
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"OrderLine"
                                              inManagedObjectContext:self.context];
    [request setEntity:entity];
    
    NSPredicate *predicate= [NSPredicate predicateWithFormat:
                             @"(%K == %@)",
                             @"product", productName];
    
    [request setPredicate:predicate];
    
    
    NSError *error = nil;
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    [request release];
    //[predicate release];
    
    self.currentOrderLine = [result lastObject];
    
    if(![result lastObject]){
        // Need to make a new one and return it
        NSManagedObject *newEntity = [NSEntityDescription 
                                      insertNewObjectForEntityForName:@"OrderLine"
                                      inManagedObjectContext:self.context];
        
        [newEntity setValue:@"OrderLine"
                     forKey:@"name"];
        [newEntity setValue:productName
                     forKey:@"product"];
        [newEntity setValue: [NSString stringWithFormat:@"%d", NSTimeIntervalSince1970]
                     forKey:@"time"];
        
        [newEntity setValue:[self.fetchedResultsController.fetchedObjects lastObject] forKey:@"order"];
        
        [self.context insertObject:newEntity];
        [self.context save:&error];
        
        self.currentOrderLine = newEntity;
        
    }
    
    
    

}



-(void)addMechanismsToDefaultOrder:(NSArray *)mechanisms withProductName:(NSString *)productName
{
    [self setUpFetchedResultsController];
    
    [self setActiveOrderLine:productName];
    
   // NSLog(@"Add mechanism with ordername : %@",productName);
    
    NSError *error;
    float cost = 0;
    
    ////////////////////
    // mechanisms first
    for(NSManagedObject *mech in mechanisms){
        
        //NSLog(@"Adding Mechanism to Order");
        // Add Up the cost of the parts
        cost += [[mech valueForKey:@"price"] floatValue] * [[mech valueForKey:@"count"] intValue];
        
        // If the parts are already in the order line we don't need to add a new OrderItem Entity
        // just increment their count when we update the OrderLine
        //NSLog(@" iTem TEST returns : %@",[[self.currentOrderLine valueForKey:@"items"] valueForKey:@"name"]);
        
        if([[self.currentOrderLine valueForKey:@"items"] count] < [mechanisms count]){
           // NSLog(@"Need to add new OrderItems rather taht update the count");
        
            NSManagedObject *newEntity = [NSEntityDescription 
                                          insertNewObjectForEntityForName:@"OrderItem"
                                          inManagedObjectContext:self.context];
            
            //  NSDate *date  = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
            [newEntity setValue:[mech valueForKey:@"id"]
                         forKey:@"name"];
            [newEntity setValue:[NSString stringWithFormat:@"%d", NSTimeIntervalSince1970]
                         forKey:@"time"];
            [newEntity setValue:productName 
                         forKey:@"product"];
            [newEntity setValue:@"Mechanism" 
                         forKey:@"type"];
            [newEntity setValue:mech 
                         forKey:@"mechanism"];
            
            // default active orderline link
            [newEntity setValue:self.currentOrderLine 
                         forKey:@"order"];
            
            [self.context insertObject:newEntity];
        }
    } 
    
    
    // now update the current self.currentOrderLine
    cost += [[self.currentOrderLine valueForKey:@"cost"] floatValue];
    [self.currentOrderLine setValue:[NSNumber numberWithFloat:cost]
                             forKey:@"cost"];
    /* only update the quantity whaen the faceplate goes in
    float quantity = [[self.currentOrderLine valueForKey:@"quantity"] floatValue];
    [self.currentOrderLine setValue: [NSNumber numberWithFloat:quantity +1]
                             forKey:@"quantity"];
     */
    
    [self.context save:&error];
}

-(void)addFaceplateToDefaultOrder:(NSArray *)faceplate withProductName:(NSString *)productName
{

    [self setUpFetchedResultsController];
    [self setActiveOrderLine:productName];
    
    NSError *error;
    BOOL insert = YES;
    float cost = [[[faceplate lastObject] valueForKey:@"price"] floatValue];

    // check if the faceplate is already there
    if([[self.currentOrderLine valueForKey:@"items"] count] > 1){
        for(NSManagedObject *item in [self.currentOrderLine valueForKey:@"items"]){            
            
            if([[item valueForKey:@"mechanism"]count] > 0){
               // mechanism ignore                 
            }else{
               // NSLog(@"\nEXISTING FACePlate \n");
                // faceplate exists
                insert = NO;
            }
                
        }
    }
    
    if(insert){
        //NSLog(@"3. Inserting a new faceplate");
        
        NSManagedObject *newEntity = [NSEntityDescription 
                                      insertNewObjectForEntityForName:@"OrderItem"
                                      inManagedObjectContext:self.context];
        
        //  NSDate *date  = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
        [newEntity setValue:[[faceplate lastObject] valueForKey:@"id"]
                     forKey:@"name"];
        [newEntity setValue:[NSString stringWithFormat:@"%d", NSTimeIntervalSince1970]
                     forKey:@"time"];
        [newEntity setValue:productName 
                     forKey:@"product"];
        [newEntity setValue:@"Faceplate" 
                     forKey:@"type"];
        
        [newEntity setValue:[faceplate lastObject] 
                     forKey:@"faceplate"];
        
        // default active orderline link
        [newEntity setValue:self.currentOrderLine 
                     forKey:@"order"];    
        [self.context insertObject:newEntity];

    }
    
   
    
    // now update the current self.currentOrderLine
    
    cost += [[self.currentOrderLine valueForKey:@"cost"] floatValue];
    [self.currentOrderLine setValue:[NSNumber numberWithFloat:cost]
                             forKey:@"cost"];
    float quantity = [[self.currentOrderLine valueForKey:@"quantity"] floatValue];
    [self.currentOrderLine setValue: [NSNumber numberWithFloat:quantity +1]
                             forKey:@"quantity"];
    
    
    [self.context save:&error];
}

@end
