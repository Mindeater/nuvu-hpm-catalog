//
//  OrderDetailTableView.m
//  Catalog2
//
//  Created by Ashley McCoy on 28/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "OrderDetailTableView.h"
#import "OrderLineViewCell.h"


@implementation OrderDetailTableView


@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

@synthesize orderId;

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
                                   entityForName:@"OrderLine" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    /*
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",@"order.uniqueId",self.orderId];
    [fetchRequest setPredicate:predicate];
     */
    NSLog(@" passed uniqueID : %@\n\n",self.orderId);
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc] 
                              initWithKey:@"name" ascending:NO];
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
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    
    //NSLog(@" %@",_fetchedResultsController.fetchedObjects);
    self.title = @"An Order";
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return 6;
    id <NSFetchedResultsSectionInfo> sectionInfo = 
    [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects]+2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    OrderLineViewCell *cell = (OrderLineViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[OrderLineViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.lineColor = [UIColor blackColor];
    }
    
    // Since we are drawing the lines ourself, we need to know which cell is the top cell in the table so that
    // we can draw the line on the top
    if (indexPath.row == 0){
        cell.topCell = YES;
        // Make a table Heading in the first instance
        cell.cell1.text = @"CODE";
        cell.cell2.text = @"DESCRIPTION";
        cell.cell3.text = @"COMMENTS";
        cell.cell4.text = @"QTY";
        cell.cell5.text = @"PRICE";
    }else if(indexPath.row == [_fetchedResultsController.fetchedObjects count]+1){
        // the bottom cell should have the total
        cell.cell1.text = @"";
        cell.cell2.text = @"";
        cell.cell3.text = @"";
        cell.cell4.text = @"TOTAL:";
        cell.cell5.text = @"$7,456.89";
    }else{
        cell.topCell = NO;
    
    
        // Configure the cell.
        NSManagedObject *currentRecord = [_fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row -1];
        
        // code
        cell.cell1.text = [currentRecord valueForKey:@"name"];
        // desc
        cell.cell2.text = [currentRecord valueForKey:@"product"];
        // comments
        cell.cell3.text = @"USer Added Comment could be quite liong so there has to be some expansion here or truncation";
        // Qty
        cell.cell4.text = @"2";
        // price
        cell.cell5.text = @"$72.80";
        
    }
    
    return cell;
    /*static NSString *CellIdentifier = @"Cell";
    
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    OrderLineViewCell *cell = (OrderLineViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    NSManagedObject *currentRecord = [_fetchedResultsController objectAtIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[[OrderLineViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        
		UILabel *label = [[[UILabel	alloc] initWithFrame:CGRectMake(0.0, 0, 150.0,
                                                                    tableView.rowHeight)] autorelease];
		[cell addColumn:150];
		label.tag = 1;//LABEL_TAG;
		label.font = [UIFont systemFontOfSize:12.0];
		label.text = [NSString stringWithFormat:@"%d", 
                      [currentRecord valueForKey:@"name"]];
		label.textAlignment = UITextAlignmentRight;
		label.textColor = [UIColor blueColor];
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
		UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:label]; 
        
		label =  [[[UILabel	alloc] initWithFrame:CGRectMake(250.0, 0, 150.0,
															tableView.rowHeight)] autorelease];
		[cell addColumn:250];
		label.tag = 2;//VALUE_TAG;
		label.font = [UIFont systemFontOfSize:12.0];
		// add some silly value
		label.text = [NSString stringWithFormat:@"%d", 
                      [currentRecord valueForKey:@"time"]];
		label.textAlignment = UITextAlignmentRight;
		label.textColor = [UIColor blueColor];
		label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin |
		UIViewAutoresizingFlexibleHeight;
		[cell.contentView addSubview:label];
    }
    
    // Configure the cell...
    
    NSLog(@"\n\n CeLL :: - \n%@\n\n",[currentRecord valueForKey:@"product"]);
    
    return cell;*/
}


- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
    NSManagedObject *currentRecord = [_fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [currentRecord valueForKey:@"name"];

}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

@end
