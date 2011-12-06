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


#pragma mark - Core Data

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
         [NSString stringWithFormat:@"%d", NSTimeIntervalSince1970]
                     forKey:@"uniqueId"];
        [newEntity setValue:[NSNumber numberWithBool:YES] forKey:@"active"];
        
        [self.context insertObject:newEntity];
        [self.context save:&error];
    }

}
-(void)addMechanismsToDefaultOrder:(NSArray *)mechanisms withProductName:(NSString *)productName
{
    [self setUpFetchedResultsController];
    NSError *error;
    //
    // mechanisms first
    for(NSManagedObject *mech in mechanisms){
        NSLog(@"Mechanism");
        NSManagedObject *newEntity = [NSEntityDescription 
                                      insertNewObjectForEntityForName:@"OrderLine"
                                      inManagedObjectContext:self.context];
        
        //  NSDate *date  = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
        [newEntity setValue:@"Order Line" forKey:@"name"];
        [newEntity setValue:
         [NSString stringWithFormat:@"%d", NSTimeIntervalSince1970]
                     forKey:@"time"];
        [newEntity setValue:productName forKey:@"product"];
        
        [newEntity setValue:mech forKey:@"mechanism"];
        
        [newEntity setValue:[self.fetchedResultsController.fetchedObjects lastObject] forKey:@"order"];
        [newEntity setValue:@"Order Line" forKey:@"name"];
        
        [self.context insertObject:newEntity];
    } 
    [self.context save:&error];
}

-(void)addFaceplateToDefaultOrder:(NSArray *)faceplate withProductName:(NSString *)productName
{

    [self setUpFetchedResultsController];
    NSError *error;
    // now the faceplate
    NSManagedObject *newEntity = [NSEntityDescription 
                                  insertNewObjectForEntityForName:@"OrderLine"
                                  inManagedObjectContext:self.context];
    
    //  NSDate *date  = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
    [newEntity setValue:@"Order Line" forKey:@"name"];
    [newEntity setValue:
     [NSString stringWithFormat:@"%d", NSTimeIntervalSince1970]
                 forKey:@"time"];
    [newEntity setValue:productName forKey:@"product"];
    
    [newEntity setValue:[faceplate lastObject] forKey:@"faceplate"];
    [newEntity setValue:[self.fetchedResultsController.fetchedObjects lastObject] forKey:@"order"];
    [newEntity setValue:@"Order Line" forKey:@"name"];
    
    [self.context insertObject:newEntity];
    
    [self.context save:&error];
}

@end
