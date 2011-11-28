//
//  AddItemToOrderView.m
//  Catalog2
//
//  Created by Ashley McCoy on 27/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//


#import "AddItemToOrderView.h"

@implementation AddItemToOrderView

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

@synthesize mechanism;
@synthesize faceplate;
@synthesize productToAdd;

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



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    //////////////////////////
    // cancel button left
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelSelection:)];          
    self.navigationItem.leftBarButtonItem = cancelButton;
    [cancelButton release];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"Confirm" style:UIBarButtonItemStylePlain target:self action:@selector(acceptSelection:)];          
    self.navigationItem.rightBarButtonItem = cancelButton;
    [addButton release];
    
    /////////////////////////
    // add button
    
    ////////////////////////
    // textview to put some info
    
    UITextView *info = [[UITextView alloc]initWithFrame:CGRectMake(40, 20, 600, 600)];
    
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    NSLog(@" +++ = == \n%@\n\n\n",self.fetchedResultsController.fetchedObjects);
    if([self.fetchedResultsController.fetchedObjects lastObject] == nil){
        NSLog(@"EMPTY RESULTS");
        
        // Create a new Entity
        
        // Create a new instance of the entity managed by the fetched results controller.
        NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
       
        NSManagedObject *newEntity = [NSEntityDescription 
                                      insertNewObjectForEntityForName:[entity name] inManagedObjectContext:[self.fetchedResultsController managedObjectContext]];
        
        /*
        NSManagedObject *newEntity = [NSEntityDescription 
                                      insertNewObjectForEntityForName:@"Order"
                                      inManagedObjectContext:self.context];
         */
        
      //  NSDate *date  = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
        [newEntity setValue:@"New Order" forKey:@"name"];
        [newEntity setValue:
                     [NSString stringWithFormat:@"%d", NSTimeIntervalSince1970]
                     forKey:@"uniqueId"];
        [newEntity setValue:[NSNumber numberWithBool:YES] forKey:@"active"];
        
        [self.context insertObject:newEntity];
        [self.context save:&error];
        
        
    }
    // show the parts that have been added
    NSLog(@"\nBUT NOW -- \n%@\n\n\n",self.fetchedResultsController.fetchedObjects);
    NSMutableString *output = [NSMutableString string];
    [output appendFormat:@"%@ \n\t\t***\n",self.productToAdd];
    [output appendFormat:@"%@\n",@"Adding these items\n--------------"];
    // mechanisms
    NSLog(@"Mechanism     ::: : : :  %@",self.mechanism);
    for(NSManagedObject *mech in self.mechanism){
        [output appendFormat:@"++ id:%@ count:%@ name: %@\n",
         [mech valueForKey:@"id"],
         [mech valueForKey:@"count"],
         [mech valueForKey:@"name"]]; 
    }
    // faceplate
    [output appendFormat:@"%@\n",@"Faceplate\n---------\n"];
    [output appendFormat:@"++ id: %@ name: %@\n",
     [self.faceplate valueForKey:@"id"],
     [self.faceplate valueForKey:@"name"]];
    
    info.text = output;
    [self.view addSubview:info];
    [info release];
    
 
}

-(void)cancelSelection:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)addSelection:(id)sender
{
    NSError *error;
    // for each of the mechanisms and the faceplate
    // insert and order line
    
    // Create a new Entity
    
    // mechanisms first
    for(NSManagedObject *mech in self.mechanism){
        NSManagedObject *newEntity = [NSEntityDescription 
                                      insertNewObjectForEntityForName:@"OrderLine"
                                      inManagedObjectContext:self.context];
        
        //  NSDate *date  = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
        [newEntity setValue:@"Order Line" forKey:@"name"];
        [newEntity setValue:
         [NSString stringWithFormat:@"%d", NSTimeIntervalSince1970]
                     forKey:@"time"];
        [newEntity setValue:self.productToAdd forKey:@"product"];
        
        [newEntity setValue:mech forKey:@"mechanism"];
        [newEntity setValue:[self.fetchedResultsController.fetchedObjects lastObject] forKey:@"order"];
        [newEntity setValue:@"Order Line" forKey:@"name"];
        
        [self.context insertObject:newEntity];
    }
    
    // now the faceplate
    NSManagedObject *newEntity = [NSEntityDescription 
                                  insertNewObjectForEntityForName:@"OrderLine"
                                  inManagedObjectContext:self.context];
    
    //  NSDate *date  = [NSDate dateWithTimeIntervalSince1970:NSTimeIntervalSince1970];
    [newEntity setValue:@"Order Line" forKey:@"name"];
    [newEntity setValue:
     [NSString stringWithFormat:@"%d", NSTimeIntervalSince1970]
                 forKey:@"time"];
    [newEntity setValue:self.productToAdd forKey:@"product"];
    
    [newEntity setValue:self.faceplate forKey:@"faceplate"];
    [newEntity setValue:[self.fetchedResultsController.fetchedObjects lastObject] forKey:@"order"];
    [newEntity setValue:@"Order Line" forKey:@"name"];
    
    [self.context insertObject:newEntity];
    
    [self.context save:&error];
    
    [self dismissModalViewControllerAnimated:YES];
     
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
        
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            
            break;
            
        case NSFetchedResultsChangeDelete:

            break;
            
        case NSFetchedResultsChangeUpdate:
            break;
            
        case NSFetchedResultsChangeMove:

            break;
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
