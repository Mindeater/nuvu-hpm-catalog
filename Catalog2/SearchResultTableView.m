//
//  SearchResultTableView.m
//  Catalog2
//
//  Created by Ashley McCoy on 19/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "SearchResultTableView.h"


@implementation SearchResultTableView

@synthesize context;
@synthesize fetchedResultsController;
@synthesize filteredListContents;

-(void)dealloc
{
    self.fetchedResultsController = nil;
    self.context = nil;
    [super dealloc];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    NSLog(@"INIT for SearchREsultTableVoiew");
    
    
    
    
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
    
    
    NSLog(@"\n\n\n\nSEARCH RESULTS TABLEVIEW\n\n\n\n");
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
    NSLog(@"SearchresultTAble configure Cell %@",self.filteredListContents);
    cell.textLabel.text = [[self.filteredListContents objectAtIndex:indexPath.row] valueForKey:@"name"];
    return cell;
}


#pragma mark - Search results delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSLog(@"Search results table view - searchDisplayController callback \n\n %@",searchString);
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
    //NSLog(@"Filter Content %@",self.fetchedResultsController.fetchedObjects);
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[cd] %@", searchText];
    self.filteredListContents = [[[self fetchedResultsController] fetchedObjects] filteredArrayUsingPredicate:predicate];
	/*
    [self.filteredstaffList removeAllObjects]; // First clear the filtered array.

    NSPredicate *predicate = nil;
    if([scope isEqualToString:@"Staff Code"])
    {
        predicate = [NSPredicate predicateWithFormat:@"(SELF.staffCode contains[cd] %@)", searchText]; 	
    }
    if([scope isEqualToString:@"Staff FullName"])
    {
        predicate = [NSPredicate predicateWithFormat:@"(SELF.staffFullName contains[cd] %@)", searchText]; 
    }

    NSArray *array = [staffList filteredArrayUsingPredicate:predicate];
    self.filteredstaffList = [NSMutableArray arrayWithArray: array];
    */
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
