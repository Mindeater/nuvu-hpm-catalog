//
//  BrandCatalogTableView.m
//  Catalog2
//
//  Created by Ashley McCoy on 22/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "BrandCatalogTableView.h"
//#import "ProductView.h"

#import "ProductChooserView.h"


@implementation BrandCatalogTableView

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

@synthesize wallImage;

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
                                   entityForName:@"Brand" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"menuOrder" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSFetchedResultsController *theFetchedResultsController = 
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
                                        managedObjectContext:_context sectionNameKeyPath:nil 
                                                   cacheName:@"Brands"];
    
    
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    [sort release];
    [fetchRequest release];
    [theFetchedResultsController release];
    
    return _fetchedResultsController;    
    
}

#pragma mark - View Lifecycle

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		//exit(-1);  // Fail
        UIAlertView *dbError = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Internal Data storage Error.\n Please end this application with the home button\nIf you are seeing this error again please reinstall the application." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [dbError show];
        [dbError release];
	}
    
    self.title = @"Catalogue - Switches and Sockets";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if(section == [_fetchedResultsController.fetchedObjects count]-1){
        return 80;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    // only for the last section
    UIView * view = [[UIView alloc] init];
    [view autorelease];
    if(section == [_fetchedResultsController.fetchedObjects count]-1){
        
        
        
        // Create label with section title
        UILabel *label = [[[UILabel alloc] init] autorelease];
        label.frame = CGRectMake(10, 0, tableView.bounds.size.width, 60);
        label.backgroundColor = [UIColor clearColor];
        label.lineBreakMode = UILineBreakModeWordWrap;
        label.numberOfLines = 0;
        
        label.textColor = [UIColor whiteColor];
        label.shadowColor = [UIColor grayColor];
        label.shadowOffset = CGSizeMake(0.0, 1.0);
        label.font = [UIFont boldSystemFontOfSize:12];
        label.text = @"*This is a selection of product only. For the full range visit the individual brand websites.";
        
        // Create header view and add label as a subview
        
        view.frame = CGRectMake(0, 0, tableView.bounds.size.width +20, 80);
        [view addSubview:label];  
    }else{
        view.frame = CGRectMake(0, 0, 0, 0);
    }
    
    return view;
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
    return [_fetchedResultsController.fetchedObjects count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // fixed font style. use custom view (UILabel) if you want something different
     NSManagedObject *currentRecord = [_fetchedResultsController.fetchedObjects  objectAtIndex:section];
     //return [currentRecord valueForKey:@"name"];
     return [currentRecord valueForKey:@"heading"];
     
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSManagedObject *currentRecord = [_fetchedResultsController.fetchedObjects objectAtIndex:section];
    NSSet *rows = [currentRecord valueForKey:@"Category"];
    return [rows count];
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
    
    NSManagedObject *sectionBrand = [_fetchedResultsController.fetchedObjects 
                                      objectAtIndex:indexPath.section];
    
    /////////////////////////////////////////////
    // sort descriptor to maintain category order
    NSSortDescriptor *nameDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"menuOrder"
                                                 ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObject:nameDescriptor];
    
    NSArray *sortedResult = [[[sectionBrand valueForKey:@"category"] allObjects]sortedArrayUsingDescriptors:sortDescriptors];
    
    //NSLog(@"\n\n\n\n SORTED RESULT ** \n\n%@\n\n",sortedResult);
    // NSManagedObject *category = [[[sectionBrand valueForKey:@"category"] allObjects]objectAtIndex:indexPath.row];
    //cell.textLabel.text = [category valueForKey:@"name"];
    cell.textLabel.text = [[sortedResult objectAtIndex:indexPath.row] valueForKey:@"name"];

    // custom coloring
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    //cell.textLabel.highlightedTextColor = [UIColor blackColor];
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
   // ProductView *detailViewController = [[ProductView alloc] init];
    ProductChooserView *detailViewController = [[ProductChooserView alloc] init];

    NSManagedObject *currentRecord = [_fetchedResultsController.fetchedObjects 
                                      objectAtIndex:indexPath.section];
    detailViewController.currentBrand = [currentRecord valueForKey:@"name"];
    
//    detailViewController.currentCategory = [[[[currentRecord mutableSetValueForKey:@"category"]
//                                             allObjects] 
//                                             objectAtIndex:indexPath.row] 
//                                            valueForKey:@"name"];
//  
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
   // NSLog ( @"You selected row: %@", cell.text);
    detailViewController.currentCategory = cell.textLabel.text;
    detailViewController.context = self.context;
    detailViewController.wallImage = self.wallImage;
    //NSLog(@"selected table cell - background Image :: %@",self.wallImage);
    
    //NSLog(@"\n^^^BRANDCAtalogView push^^^^\n Nav Controller :%@ \nNav Bar : %@^^^^^^^^^^\n\n",
      //  self.navigationController.viewControllers, self.navigationController.navigationBar);
    //self.navigationController.navigationBar.hidden = true;
    // detailViewController.managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
    // ...
    // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:NO];
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
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
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
