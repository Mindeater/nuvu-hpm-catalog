//
//  SearchResultTableView.m
//  Catalog2
//
//  Created by Ashley McCoy on 19/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "SearchResultTableView.h"
//#import "ProductView.h"
#import "ProductChooserView.h"
#import "SearchPage.h"


@implementation SearchResultTableView

@synthesize context;
@synthesize fetchedResultsController;
@synthesize filteredListContents;
@synthesize LINK;

-(void)dealloc
{
    self.fetchedResultsController = nil;
    self.context = nil;
    [super dealloc];
}

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
    NSLog(@"Search results Table View view Did Load");
    self.filteredListContents = [NSArray arrayWithObjects: nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.filteredListContents count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    //NSLog(@"SearchresultTAble configure Cell %@",self.filteredListContents);
    NSInteger item = self.LINK.searchDisplayController.searchBar.selectedScopeButtonIndex;
    switch (item) {
        case 0:
            cell.textLabel.text = [[self.filteredListContents objectAtIndex:indexPath.row] valueForKey:@"name"];
            break;
        case 1:
            cell.textLabel.text = [[self.filteredListContents objectAtIndex:indexPath.row] valueForKey:@"id"];
            break;
        case 2:
            cell.textLabel.text = [[self.filteredListContents objectAtIndex:indexPath.row] valueForKey:@"id"];
            break;
            
        default:
            break;
    }
    
    return cell;
}


#pragma mark - Search results delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"Search results table view - searchDisplayController callback \n\n %@ \n\n--\n\n%i ",searchString,self.LINK.searchDisplayController.searchBar.selectedScopeButtonIndex);
    
    [self filterContentForSearchText:searchString scope:
	 [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:
	  [self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}
- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
   
    return YES;
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    //[self.filteredListContents removeAllObjects]; // First clear the filtered array.

    NSInteger item = self.LINK.searchDisplayController.searchBar.selectedScopeButtonIndex;
     NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText];
    
    if(item == 0){ 
        // products
        self.filteredListContents = [[[self fetchedResultsController] fetchedObjects] filteredArrayUsingPredicate:predicate];

    }else if(item == 1){ 
        // mechanisms
        NSLog(@"Mechanism Search");
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityMechansim = [NSEntityDescription entityForName:@"Mechanism"
                                                           inManagedObjectContext:self.context];
        [request setEntity:entityMechansim];
        NSPredicate * mechPredicate = [NSPredicate predicateWithFormat:@"id CONTAINS[cd] %@", searchText];
        [request setPredicate:mechPredicate];
        
         self.filteredListContents =  [self.context executeFetchRequest:request error:&error];
        
        [request release];
        
    }else if(item == 2){ // coverplates 
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityFaceplate = [NSEntityDescription entityForName:@"Faceplate"
                                                           inManagedObjectContext:self.context];
        [request setEntity:entityFaceplate];
        NSPredicate * fbPredicate = [NSPredicate predicateWithFormat:@"id CONTAINS[cd] %@", searchText];
        [request setPredicate:fbPredicate];
        
        ////////////////////////
        // make sure there are no duplicates returned
        NSArray *result =  [self.context executeFetchRequest:request error:&error];
        NSMutableSet* existingNames = [NSMutableSet set];
        NSMutableArray* filteredArray = [NSMutableArray array];
        for (id object in result) {
            if (![existingNames containsObject:[object name]]) {
                [existingNames addObject:[object name]];
                [filteredArray addObject:object];
            }
        }
        
        self.filteredListContents =  [NSArray arrayWithArray:filteredArray];
        
        [request release];

    }

}
#pragma mark -
#pragma mark Fetched results controller

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {
        return fetchedResultsController;
    }
    
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:context];
	[fetchRequest setEntity:entity];
    
	NSSortDescriptor *nameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
	NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameDescriptor, nil];
	[fetchRequest setSortDescriptors:sortDescriptors];
    
	NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 														managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
	self.fetchedResultsController = aFetchedResultsController;
	fetchedResultsController.delegate = self;
    
	[aFetchedResultsController release];
	[fetchRequest release];
	[nameDescriptor release];
	[sortDescriptors release];
    
	return fetchedResultsController;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	//if (self.searchIsActive) {
		[self searchDisplayController:[self searchDisplayController] shouldReloadTableForSearchString:[[[self searchDisplayController] searchBar] text]];
		[self.searchDisplayController.searchResultsTableView reloadData];
	/*}else {
		[self.tableView reloadData];
	}*/
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //ProductView *detailViewController = [[ProductView alloc] init];
    
    
    NSInteger item = self.LINK.searchDisplayController.searchBar.selectedScopeButtonIndex;
    switch (item) {
        case 0: // product
        {
            ProductChooserView *detailViewController = [[ProductChooserView alloc] init];
            NSManagedObject *currentRecord = [self.filteredListContents objectAtIndex:indexPath.row];
            detailViewController.currentBrand = [[currentRecord valueForKey:@"brand"]
                                                 valueForKey:@"name"];
            detailViewController.currentCategory = [[currentRecord valueForKey:@"category"]
                                                    valueForKey:@"name"];
            detailViewController.context = self.context;
            // detailViewController.managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
            // ...
            // Pass the selected object to the new view controller.
            
            [self.LINK.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        
        }
            break;
        case 1: // mechanism
            
            
            break;
        case 2: // faceplates
            
            
            break;
            
        default:
            break;
    }
    
   
     
    /*
    detailViewController.context = self.context;
    // detailViewController.managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
    // ...
    // Pass the selected object to the new view controller.

    [self.LINK.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}

@end
