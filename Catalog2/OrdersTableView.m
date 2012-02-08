//
//  OrdersTableView.m
//  Catalog2
//
//  Created by Ashley McCoy on 19/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "OrdersTableView.h"
//#import "OrderDetailPage.h"
#import "OrderDetailTableView.h"

@implementation OrdersTableView

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

-(void)dealloc
{
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    self.context = nil;
    [super dealloc];
}

#pragma mark - Core Data
- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Order" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
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


-(void)addNewOrder
{

    NSError *error;
    
    // turn off the existing objects
    for(NSManagedObject *order in _fetchedResultsController.fetchedObjects){
        [order setValue:[NSNumber numberWithBool:NO]
                 forKey:@"active"];
    } 
    [self.context save:&error];
    
    NSEntityDescription *entity = [[self.fetchedResultsController fetchRequest] entity];
    NSManagedObject *newEntity = [NSEntityDescription 
                                  insertNewObjectForEntityForName:[entity name] inManagedObjectContext:[self.fetchedResultsController managedObjectContext]];
    
    NSInteger nextRow = [_fetchedResultsController.fetchedObjects count]+1;
    [newEntity setValue:[NSString stringWithFormat:@"New Order %i",nextRow] 
                 forKey:@"name"];
    [newEntity setValue:
     [NSString stringWithFormat:@"%@",  [[NSProcessInfo processInfo] globallyUniqueString]]
                 forKey:@"uniqueId"];
    [newEntity setValue:[NSNumber numberWithBool:YES] forKey:@"active"];
    
    
    [self.context insertObject:newEntity];
     
    [self.context save:&error];
}

#pragma mark - view

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    /////////////
    // style
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIBarButtonItem *tempButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewOrder)];
    //self.navigationItem.rightBarButtonItem = tempButton;
    
    //@TODO: iOS5 only function
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.editButtonItem,tempButton, nil];
    
    [tempButton release];
    
    //////////////////////////////
    /// fetchedResultsController
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		//exit(-1);  // Fail
        UIAlertView *dbError = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Internal Data storage Error.\n Please end this application with the home button\nIf you are seeing this error again please reinstall the application." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [dbError show];
        [dbError release];
	}
    
    self.title = @"Orders";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.fetchedResultsController = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

#define SectionHeaderHeight 40
//from:
// http://undefinedvalue.com/2009/08/25/changing-background-color-and-section-header-text-color-grouped-style-uitableview

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if ([self tableView:tableView titleForHeaderInSection:section] != nil) {
        return SectionHeaderHeight;
    }
    else {
        // If no section header title, no section header needed
        return 0;
    }
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle = [self tableView:tableView titleForHeaderInSection:section];
    if (sectionTitle == nil) {
        return nil;
    }
    
    // Create label with section title
    UILabel *label = [[[UILabel alloc] init] autorelease];
    label.frame = CGRectMake(20, 6, 300, 30);
    label.backgroundColor = [UIColor clearColor];
    /*
     label.textColor = [UIColor colorWithHue:(136.0/360.0)  // Slightly bluish green
     saturation:1.0
     brightness:0.60
     alpha:1.0];
     label.shadowColor = [UIColor whiteColor];
     */
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = sectionTitle;
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SectionHeaderHeight)];
    [view autorelease];
    [view addSubview:label];
    
    return view;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // fixed font style. use custom view (UILabel) if you want something different
    if (![_fetchedResultsController.fetchedObjects lastObject]) {
        return @"There are no orders to view";
    }
    return @"Orders:";
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = 
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    cell.backgroundColor = [UIColor blackColor];
    //cell.textLabel.textColor = [UIColor whiteColor];
    cell.textLabel.text = @"";
    
    NSManagedObject *currentRecord = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    /////////////////////////////////
    // date under title
    /*
     NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    NSDate *date = [NSDate dateWithTimeIntervalSinceReferenceDate:
                    [[currentRecord valueForKey:@"uniqueId"] intValue]];
    cell.detailTextLabel.text = [dateFormatter stringFromDate:date]; 
    [dateFormatter release];
    */
    ///////////////////////////////////
    // title editable
    //cell.textLabel.text = [currentRecord valueForKey:@"name"];
    for(UIView *existing in cell.contentView.subviews){
        [existing removeFromSuperview];
    }
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 200, 21)];
    textField.text = [currentRecord valueForKey:@"name"];
    textField.tag = indexPath.row;
    textField.delegate = self;
    textField.textColor = [UIColor whiteColor];
    //cell.accessoryView = textField;
    [cell.contentView addSubview:textField];
    [textField release];
    

    
    
    /////////////////////////////////
    // the active switch
    UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
    switchview.tag = indexPath.row;
    //switchview.delegate = self;
    [switchview addTarget:self action:@selector(switched:) forControlEvents:UIControlEventValueChanged];
    
    if([[currentRecord valueForKey:@"active"] boolValue]){
        switchview.on = YES;
    }
    cell.accessoryView = switchview;
    [switchview release];
    
}
/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */


 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (editingStyle == UITableViewCellEditingStyleDelete) {
         // check if it's active
         NSManagedObject *selected = [_fetchedResultsController objectAtIndexPath:indexPath];
         
         //@TODO: this means they can break it by removing all the orders
         if([[selected valueForKey:@"active"] boolValue]){
             //return;
         }
         // Delete the row from the data source
         [self.context deleteObject:[_fetchedResultsController objectAtIndexPath:indexPath]];
         
         // Save the context.
         NSError *error;
         if (![self.context save:&error]) {
             /*
              Replace this implementation with code to handle the error appropriately.
              
              abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
              */
             NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
             //abort();
             UIAlertView *dbError = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Internal Data storage Error.\n Please end this application with the home button\nIf you are seeing this error again please reinstall the application." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
             [dbError show];
             [dbError release];
         }
         //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
     }   
     else if (editingStyle == UITableViewCellEditingStyleInsert) {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
         
     }   
 }
 

#pragma mark - switch call back
- (void)switched:(id)sender 
{
    UISwitch *switchedSwitch = (UISwitch *)sender;
    [switchedSwitch resignFirstResponder];

    // can only switch on a new one
    if(![switchedSwitch isOn]){
        [switchedSwitch setOn:YES animated:YES];
        return;
    }
    
    // switch all of them off
    for(NSManagedObject *order in _fetchedResultsController.fetchedObjects){
        [order setValue:[NSNumber numberWithBool:NO]
                 forKey:@"active"];
    } 
    
    //switch on the selected item
    NSManagedObject *changed = [_fetchedResultsController.fetchedObjects objectAtIndex:switchedSwitch.tag];
    [changed setValue:[NSNumber numberWithBool:YES]
             forKey:@"active"];
    NSError *error;
    [self.context save:&error];
    
}
 
#pragma mark - name change callback

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSManagedObject *curr = [_fetchedResultsController.fetchedObjects objectAtIndex:textField.tag];
    [curr setValue:textField.text
            forKey:@"name"];
    NSError *error;
    [self.context save:&error];
    
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}
/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
   // OrderDetailPage *detailViewController = [[OrderDetailPage alloc] init];
    OrderDetailTableView *detailViewController = [[OrderDetailTableView alloc] init];
    //OrderDetailTableView *detailViewController = [[OrderDetailTableView alloc] initWithStyle:UITableViewStyleGrouped];
    detailViewController.context = self.context;
    NSManagedObject *currentRecord = [_fetchedResultsController objectAtIndexPath:indexPath];
    detailViewController.orderId = [currentRecord valueForKey:@"uniqueId"];
    detailViewController.orderName = [currentRecord valueForKey:@"name"];
    detailViewController.backString = @"Orders";
    
    //NSManagedObject *currentRecord = [_fetchedResultsController objectAtIndexPath:indexPath];
    //detailViewController.currentBrand = [currentRecord valueForKey:@"name"];
    // detailViewController.managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    
}


#pragma mark - NSFetchedResultsController Delegate methods

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate: //4
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove: // 3 
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            // Reloading the section inserts a new row and ensures that titles are updated appropriately.
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:newIndexPath.section] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.tableView endUpdates];
}

@end