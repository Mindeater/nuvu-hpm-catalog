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
#import "MechanismView.h"


@implementation SearchResultTableView

@synthesize context;
@synthesize fetchedResultsController;
@synthesize filteredListContents;
@synthesize LINK;
@synthesize currentSearchTerms;

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
    self.filteredListContents = [NSArray arrayWithObjects: nil];
    self.currentSearchTerms = [NSMutableArray arrayWithCapacity:1];
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
		//exit(-1);  // Fail
        UIAlertView *dbError = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Internal Data storage Error.\n Please end this application with the home button\nIf you are seeing this error again please reinstall the application." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [dbError show];
        [dbError release];
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger item = self.LINK.searchDisplayController.searchBar.selectedScopeButtonIndex;
    switch (item) {
        case 0: // product
            return 60.0;
            break;
        case 1: // mechanism
            return 200.0;
            break;
        case 2:
            return 200.0;
            break;
            
        default:
            break;
    }
    return 100.0;
}

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
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSString *resultString;
    NSString *detailString;
    NSInteger item = self.LINK.searchDisplayController.searchBar.selectedScopeButtonIndex;
    switch (item) {
        case 0: // product
            resultString = [[self.filteredListContents objectAtIndex:indexPath.row] valueForKey:@"name"];
            cell.imageView.image = nil;
            cell.detailTextLabel.text = [[[self.filteredListContents objectAtIndex:indexPath.row] valueForKey:@"category"] valueForKey:@"name"];
            detailString = nil;
            break;
        
        case 1: // mechanism
        {
            NSManagedObject *part = [self.filteredListContents objectAtIndex:indexPath.row];
            resultString = [part valueForKey:@"id"];
            cell.imageView.image = [self getThumbnailForPart:part
                                                      ofType:@"Mechanism"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            detailString = [NSString stringWithFormat:@"%@, %@",
                                         [[[part valueForKey:@"product"] valueForKey:@"brand"] valueForKey:@"heading"],
                                         [[[part valueForKey:@"product"] valueForKey:@"category"] valueForKey:@"name"]];
        }
            break;
        case 2: // coverplate
        {
            NSManagedObject *part = [self.filteredListContents objectAtIndex:indexPath.row];
            resultString = [NSString stringWithFormat:@"%@ (%@)",
                                   [part valueForKey:@"id"],
                                   [part valueForKey:@"name"]];
            cell.imageView.image = [self getThumbnailForPart:part
                                                      ofType:@"Faceplate"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            detailString = [[[part valueForKey:@"product"] valueForKey:@"brand"] valueForKey:@"heading"];
            // The Category Name is not part of the search so it's not required to be displayed
//            detailString = [NSString stringWithFormat:@"%@, %@",
//                                         [[[part valueForKey:@"product"] valueForKey:@"brand"] valueForKey:@"heading"],
//                                         [[[part valueForKey:@"product"] valueForKey:@"category"] valueForKey:@"name"]];
        }
            break;
            
        default:
            resultString = @"";
            detailString = @"";
            break;
    }
    
    // highlight the search parts of the Label
    if(resultString != nil){
        [self getSearchTermsHighlightedStringForString:resultString in:cell.textLabel];
    }
    
    if(detailString != nil){
        [self getSearchTermsHighlightedStringForString:detailString in:cell.detailTextLabel];
    }
    
//
//    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:resultString];
//    [attrString beginEditing];
//    for(NSString *term in self.currentSearchTerms)
//    {
//        NSRange termRange = [resultString rangeOfString:term options:NSCaseInsensitiveSearch];
//        [attrString addAttribute: NSBackgroundColorAttributeName
//                           value:[UIColor yellowColor]
//                           range:termRange];
//    }
//    [attrString endEditing];
//    [cell.textLabel setAttributedText:attrString];
    
//        cell.textLabel.text = resultString;
    
    
    return cell;
}

-(void)getSearchTermsHighlightedStringForString:(NSString *)resultString in:(UILabel *)label
{
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:resultString];
    [attrString beginEditing];
    for(NSString *term in self.currentSearchTerms)
    {
        NSRange termRange = [resultString rangeOfString:term options:NSCaseInsensitiveSearch];
        [attrString addAttribute: NSBackgroundColorAttributeName
                           value:[UIColor yellowColor]
                           range:termRange];
    }
    [attrString endEditing];
    [label setAttributedText:attrString];
}


#pragma mark - Search results delegate

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope
{
    // reset the search
    self.LINK.searchDisplayController.searchBar.text = @"";
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
   // NSLog(@"Search results table view - searchDisplayController callback \n\n %@ \n\n--\n\n%i ",searchString,self.LINK.searchDisplayController.searchBar.selectedScopeButtonIndex);
    
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
    
    //@TODO: break the search on spaces and do an OR with the predicate to cover word searching
    // Use NSCompoundPredicate -orPredicateWithSubpredicates:

    
    //Strip white space from front and back
    NSString *thisSearch = [searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

    [self.currentSearchTerms removeAllObjects];
    [self.currentSearchTerms addObjectsFromArray:[thisSearch componentsSeparatedByString:@" "]];
    
    
    if(item == 0) // products
    {
        
//        NSPredicate *productPredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", thisSearch];
        
        NSMutableArray *subPredicates = [[NSMutableArray alloc] init];
        for(NSString *term in  self.currentSearchTerms)
        {
            [subPredicates addObject:[NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", term]];
        }
        NSPredicate *productPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
        
        self.filteredListContents = [[[self fetchedResultsController] fetchedObjects] filteredArrayUsingPredicate:productPredicate];

    }
    else if(item == 1) // mechanisms
    {
        
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityMechansim = [NSEntityDescription entityForName:@"Mechanism"
                                                           inManagedObjectContext:self.context];
        [request setEntity:entityMechansim];
        
        NSMutableArray *subPredicates = [[NSMutableArray alloc] init];
        for(NSString *term in  self.currentSearchTerms)
        {
            [subPredicates addObject:[NSPredicate predicateWithFormat:
                                      @"id CONTAINS[cd] %@ || product.brand.heading CONTAINS[cd] %@ || product.category.name CONTAINS[cd] %@ && count = 1",
                                      term,
                                      term,
                                      term]];
        }
        NSPredicate *mechPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
        
//        NSPredicate * mechPredicate = [NSPredicate predicateWithFormat:
//                                       @"id CONTAINS[cd] %@ || product.brand.heading CONTAINS[cd] %@ || product.category.name CONTAINS[cd] %@ && count = 1",
//                                       thisSearch,
//                                       thisSearch,
//                                       thisSearch];
        [request setPredicate:mechPredicate];
        
        ////////////////////////
        // make sure there are no duplicates returned
        NSArray *result =  [self.context executeFetchRequest:request error:&error];
        NSMutableSet* existingNames = [NSMutableSet set];
        NSMutableArray* filteredArray = [NSMutableArray array];
        
        for (id object in result) {
            if (![existingNames containsObject:[object valueForKey:@"id"]]) {
                [existingNames addObject:[object valueForKey:@"id"]];
                [filteredArray addObject:object];
            }
        }
        self.filteredListContents =  [NSArray arrayWithArray:filteredArray];
         
        [request release];
        
    }
    else if(item == 2) // coverplates
    {
        NSError *error = nil;
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        NSEntityDescription *entityFaceplate = [NSEntityDescription entityForName:@"Faceplate"
                                                           inManagedObjectContext:self.context];
        [request setEntity:entityFaceplate];
        
        NSMutableArray *subPredicates = [[NSMutableArray alloc] init];
        for(NSString *term in  self.currentSearchTerms)
        {
            [subPredicates addObject:[NSPredicate predicateWithFormat:
                                      @"id CONTAINS[cd] %@ || name CONTAINS[cd] %@ || product.brand.heading CONTAINS[cd] %@",
                                      term,
                                      term,
                                      term]];
        }
        NSPredicate *coverplatePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
        
//        NSPredicate * coverplatePredicate = [NSPredicate predicateWithFormat:
//                                     @"id CONTAINS[cd] %@ || name CONTAINS[cd] %@ || product.brand.heading CONTAINS[cd] %@",
//                                     thisSearch,
//                                     thisSearch,
//                                     thisSearch];
        [request setPredicate:coverplatePredicate];
        
        ////////////////////////
        // make sure there are no duplicates returned
        // TODO -
        NSArray *result =  [self.context executeFetchRequest:request error:&error];
        NSMutableSet* existingNames = [NSMutableSet set];
        NSMutableArray* filteredArray = [NSMutableArray array];
        for (id object in result) {
            if (![existingNames containsObject:[object valueForKey:@"id"]]) {
                [existingNames addObject:[object valueForKey:@"id"]];
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



-(UIImage *)getThumbnailForPart:(NSManagedObject *)part ofType:(NSString *)type
{
    UIImage *found = nil;
    NSString *brandName = [[[part valueForKey:@"product"] valueForKey:@"brand"] valueForKey:@"name"];
    NSString *orientation = [[part valueForKey:@"product"] valueForKey:@"orientation"];
    NSString *orientationPrefix;
    
    if([orientation isEqualToString:@"Horizontal"]){
        orientationPrefix = @"h-";
    }else if([orientation isEqualToString:@"Vertical"]){
        orientationPrefix = @"v-";
    }else{
        orientationPrefix = @"";
    }
    
    //@TODO: refactor the image pathfinding
    if([type isEqualToString:@"Mechanism"]){
        
        NSString *img;
       
        
       // float cost = 0;
        
        if([[part valueForKey:@"count"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            // load the image based on the id screen the Arteor 770 fields
            if([[part valueForKey:@"name"] isEqualToString:@"Mech 2 Part #"] && [brandName isEqualToString:@"Arteor 770"]){
                img = [[part valueForKey:@"id"] 
                       stringByReplacingOccurrencesOfString:@"AR" withString:@""];
            }else{
                img = [part valueForKey:@"id"];
            }
            
          //  cost += [[part valueForKey:@"price"] floatValue];
        }else{
            // mechanism with more than one part
            img = [NSString stringWithFormat:@"%@-x-%@",
                   [part valueForKey:@"count"],
                   [[part valueForKey:@"id"]
                    stringByReplacingOccurrencesOfString:@"AR" withString:@""]];
          //  cost += [[part valueForKey:@"price"] floatValue] * [[part valueForKey:@"count"]intValue];
        }
        
        //self.price = [NSString stringWithFormat:@"%f",cost];
        
        // Build the Directory string
        NSString *dir;
        NSString *prefix = orientationPrefix;
        if([[part valueForKey:@"name"] isEqualToString:@"Frame"]){
            dir = @"Frames";
            // remove prefix for frames
            prefix = @"";
        }else{
            dir = [NSString stringWithFormat:@"%@/Mechanism",
                   [brandName stringByReplacingOccurrencesOfString:@" " withString:@""]];
        }
        
        //NSLog(@" Directory %@ \nWith Orientation: %@",dir,prefix);
        NSString *imgCleaned = [NSString stringWithFormat:@"%@%@",
                                prefix,
                                [img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
        
       // NSLog(@"  - File NAme %@",imgCleaned);
        
        // Grab the image off disk and load it up
        NSString *imageName = [[NSBundle mainBundle] 
                               pathForResource:imgCleaned
                               ofType:@"png" 
                               inDirectory:dir];
        found = [UIImage imageWithContentsOfFile:imageName];
        
        
        
    }else if([type isEqualToString:@"Faceplate"]){
        
        /////////////////////////////////////
        // Build the file path and image name
        NSString *img = [part valueForKey:@"id"];
        
       // NSString *orientationPrefix = [NSString stringWithString:@"h-"];
        
        NSString *dir = [NSString stringWithFormat:@"%@/Faceplate",
                         [brandName stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        NSString *imgCleaned = [NSString stringWithFormat:@"%@%@",
                                orientationPrefix,
                                [img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
        
//        NSLog(@"\n\n\n CoverPlate  - File NAme :: %@\n\n\n",imgCleaned);
        NSString *imageName = [[NSBundle mainBundle] 
                               pathForResource:imgCleaned
                               ofType:@"png" 
                               inDirectory:dir];
//        NSLog(@"\n\n\n - - - Path\n %@\nFileNAme: %@\n",imageName,dir);
        
        
        /////////////////////////////////////////
        // Grab the image off disk and load it up
        
        found = [UIImage imageWithContentsOfFile:imageName];
        
    }
    return found;
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
            
            [self.LINK.navigationController pushViewController:detailViewController animated:NO];
            [detailViewController release];
        
        }
            break;
        case 1: // mechanism
        {
            
            /*MechanismView *detailViewController = [[MechanismView alloc] init];
            NSManagedObject *currentRecord = [self.filteredListContents objectAtIndex:indexPath.row];
            detailViewController.brandName = [[currentRecord valueForKey:@"brand"]
                                                 valueForKey:@"name"];
            detailViewController.categoryName = [[currentRecord valueForKey:@"category"]
                                                    valueForKey:@"name"];
            //detailViewController.context = self.context;
            //[detailViewController drawWithItems:[currentRecord valueForKey:@"
            // detailViewController.managedObject = [_fetchedResultsController objectAtIndexPath:indexPath];
            // ...
            // Pass the selected object to the new view controller.
            
            [self.LINK.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
            */
            //NSLog(@"SEelected searched item %@",[self.filteredListContents objectAtIndex:indexPath.row]);
            
            break;
        }
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
