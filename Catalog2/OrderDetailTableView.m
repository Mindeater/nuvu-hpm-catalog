//
//  OrderDetailTableView.m
//  Catalog2
//
//  Created by Ashley McCoy on 28/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "OrderDetailTableView.h"
#import "OrderLineViewCell.h"

#import "EditOrderLineView.h"

@implementation OrderDetailTableView


@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

@synthesize orderId;
@synthesize orderTotal,quantityCount;

@synthesize emailOrderBody;

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
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",@"order.uniqueId",self.orderId];
    [fetchRequest setPredicate:predicate];
     
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

-(void)updateComment:(NSString *)comment atIndexRow:(NSInteger)indexRow
{
    //NSLog(@"\n\nUpdate Comment");
    
    NSError *error;
    // Update the Fetched Results controller
    NSManagedObject *entity = [_fetchedResultsController.fetchedObjects objectAtIndex:indexRow];
    [entity setValue:comment
              forKey:@"comment"];
    [self.context save:&error];
    
}

-(NSArray *)getPartsFromOrderLine:(NSManagedObject *)orderLine
{
    //NSMutableString *partNum = [NSMutableString stringWithString:@""];
    NSMutableString *mechPartDesc = [NSMutableString stringWithString:@""];
    NSMutableString *faceplatePartDesc = [NSMutableString stringWithString:@""];
    NSMutableString *count = [NSMutableString stringWithString:@""];
    float totalCost = 0;
    
    // are there mechanism ?
    //NSLog(@"\nMECHANISMS : \n %@", [orderLine valueForKey:@"product"]);;
    
    for(NSManagedObject *part in [orderLine valueForKey:@"items"]){
        //NSLog(@" - %@",[part valueForKey:@"type"]);
        
        
        if([[part valueForKey:@"type"] isEqualToString:@"Mechanism"]){
           // NSLog(@"1. totalCount : %f",totalCost);
            [count appendFormat:@"%@\n",
             [[part valueForKey:@"mechanism"] valueForKey:@"count"]];
            
            // handle mutliple parts
            if([[[part valueForKey:@"mechanism"] valueForKey:@"count"] intValue] >1){
                [mechPartDesc appendFormat:@"%ix %@\n",
                        [[[part valueForKey:@"mechanism"] valueForKey:@"count"] intValue],
                        [part valueForKey:@"name"]];
                totalCost += [[[part valueForKey:@"mechanism"] valueForKey:@"price"] floatValue] * [[[part valueForKey:@"mechanism"] valueForKey:@"count"] floatValue];
                //NSLog(@"2. totalCount : %f",totalCost);
                
            }else{
                [mechPartDesc appendFormat:@"%@\n",
                 [part valueForKey:@"name"]];
                totalCost += [[[part valueForKey:@"mechanism"] valueForKey:@"price"] floatValue];
               // NSLog(@"3. totalCount : %f",totalCost);

            }
            //NSLog(@"Price : %@",[[part valueForKey:@"mechanism"] valueForKey:@"price"]);
        
        }else{
            [faceplatePartDesc appendFormat:@"\n%@\n",
                    [part valueForKey:@"name"]];
            [count appendString:@"1\n"];
             totalCost += [[[part valueForKey:@"faceplate"] valueForKey:@"price"] floatValue];
            //NSLog(@"4. totalCount : %f",totalCost);
        }

    }
    // are there faceplates ?
    //NSLog(@"\nMECHANISMS : \n %@",[orderLine valueForKey:@"faceplate"]);
    
    return [NSArray arrayWithObjects:
            [NSString stringWithFormat:@"%@%@",mechPartDesc,faceplatePartDesc],
            count,
            [NSNumber numberWithFloat:totalCost],
            nil];;
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
    orderTotal = 0;
    quantityCount = 0;
    
    //NSLog(@" %@",_fetchedResultsController.fetchedObjects);
    self.title = @"An Order";
    
    
    ///////////////////////////////////////
    // Email Order Button
    UIBarButtonItem *newOrderButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Email Order" style:UIBarButtonItemStyleBordered target:self action:@selector(emailOrder:)];
    self.navigationItem.rightBarButtonItem = newOrderButton;
    [newOrderButton release];
    
    self.emailOrderBody = [NSMutableString string];
    
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

#pragma mark - sending an order  by email

-(void)emailOrder:(id)sender
{
    NSLog(@"_____%@",self.emailOrderBody);
    if ([MFMailComposeViewController canSendMail]) {
        // Build an email body to send
        // CREATING MAIL VIEW
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"Here is an image"];
        [controller setMessageBody:[NSString stringWithString:self.emailOrderBody]
                            isHTML:YES];
        
        /*
        // MAKING A SCREENSHOT
        UIGraphicsBeginImageContext(self.view.frame.size);
        [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        // ATTACHING A SCREENSHOT
        NSData *myData = UIImagePNGRepresentation(screenshot);
        [controller addAttachmentData:myData mimeType:@"image/png" fileName:@"thegrab"]; 
        */
        
        // SHOWING MAIL VIEW
        [self presentModalViewController:controller animated:YES];
        [controller release];
    }else{
        
    }
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    [self dismissModalViewControllerAnimated:YES];
    
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
    /*
     CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Georgia-Bold" size:18.0] constrainedToSize:CGSizeMake(240.0, 480.0) lineBreakMode:UILineBreakModeWordWrap];
     return size.height + 20;
     */
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
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
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    cell.indexRow = [NSNumber numberWithInt: indexPath.row -1];
    // Since we are drawing the lines ourself, we need to know which cell is the top cell in the table so that
    // we can draw the line on the top
    if (indexPath.row == 0){
        cell.topCell = YES;
        // Make a table Heading in the first instance
        cell.cell1.textAlignment = UITextAlignmentCenter;
        cell.cell1.text = @"DESCRIPTION";
        cell.cell2.text = @"CODE";
        //cell.cell3.text = @"COMMENTS";
        cell.commentField.text =@"COMMENTS";
        cell.commentField.userInteractionEnabled = NO;
        cell.cell3.text = @"QTY";
        cell.cell5.text = @"PRICE";
        
        [self.emailOrderBody 
         appendFormat:@"<table border=\"1\"><tr><th>%@</th><th>%@</th><th>%@</th><th>%@</th><th>%@</th></tr>",
        @"Description",@"Code",@"Comments",@"Qty",@"Price"];
        
    }else if(indexPath.row == [_fetchedResultsController.fetchedObjects count]+1){
        // the bottom cell should have the total
        cell.bottomCell = YES;
        cell.cell1.text = @"";
        cell.cell2.text = @"";
        cell.cell3.text = [NSString stringWithFormat:@"%d",quantityCount];  
        cell.commentField.text =@"TOTAL:";
        cell.commentField.userInteractionEnabled = NO;
        
        cell.cell5.text = [formatter stringFromNumber:[NSNumber numberWithFloat:orderTotal]];
        
        [self.emailOrderBody 
         appendFormat:@"<tr><th>%@</th><th>%@</th><th colspan=\"2\">%@</th><th>%@</th></tr></table>",
         @"",@"",@"TOTAL:",cell.cell5.text];
        
    }else{
        cell.topCell = NO;
    
        
        // Configure the cell.
        NSManagedObject *currentRecord = [_fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row -1];
        
        // parts
        NSArray *parts = [self getPartsFromOrderLine:currentRecord];

        // desc
        cell.cell1.text = [currentRecord valueForKey:@"product"];
        // code
        cell.cell2.text = [parts objectAtIndex:0];//[currentRecord valueForKey:@"name"];
        
        // comments
        //cell.commentField.placeholder = @"- - - - - - -";
        cell.commentField.tag = indexPath.row -1;
        cell.commentField.delegate = self;
        cell.commentField.text = [currentRecord valueForKey:@"comment"];
        
        //cell.cell3.text = @"USer Added Comment could be quite long so there has to be some expansion here or truncation";
        //cell.commentField.delegate = self;
        
        // Qty
        cell.cell3.text = [NSString stringWithFormat:@"%@",[currentRecord valueForKey:@"quantity"]]; //@"2";
        
        //////////////////
        // price
        
        //@TODO: assuming all items are the multiple
        NSNumber *theLineTotal = [NSNumber numberWithFloat:
                                        [[parts objectAtIndex:2] floatValue] * [[currentRecord valueForKey:@"quantity"] floatValue]];
        NSString *totalFormat = [formatter stringFromNumber:
                                 theLineTotal];
        
        cell.cell5.text = totalFormat; //@"$72.80";
        
        //NSLog(@"1. total - %f",orderTotal);
        orderTotal += [theLineTotal floatValue];
        //NSLog(@"2. Added %f now total - %f",[[parts objectAtIndex:2] floatValue],orderTotal);
        quantityCount += [[currentRecord valueForKey:@"quantity"] intValue];
        
        
        [self.emailOrderBody 
         appendFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>",
         cell.cell1.text,
         [cell.cell2.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"],
         [cell.commentField.text  stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"],
         cell.cell3.text,
         cell.cell5.text];
        
    }
    [formatter release];
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
            abort();
        }
        
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - textfield delegate
/*
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    // update the comment to the fetchedResultsController
    NSLog(@"Modify comment index: %i",textField.tag);
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    //[inputTexts replaceObjectAtIndex:textField.tag withObject:textField.text];
    return YES;
}*/
- (void)textViewDidEndEditing:(UITextView *)textView
{
    //NSLog(@" Catch the textView finished editing %i",textView.tag);
    NSManagedObject *curr = [_fetchedResultsController.fetchedObjects objectAtIndex:textView.tag];
    [curr setValue:textView.text
            forKey:@"comment"];
    NSError *error;
    [self.context save:&error];
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
#pragma mark - NavBar Choices

-(void)sendCurrentOrder
{
    //http://stackoverflow.com/questions/6750126/create-pdf-file-from-uitableview
    /*
    if (!UIGraphicsBeginPDFContextToFile(newFilePath, page, metaData )) {
        NSLog(@"error creating PDF context");
        return;
    }
    UIGraphicsBeginPDFPage();
    // ???[self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIGraphicsEndPDFContext();
     */
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if(indexPath.row == 0 || indexPath.row == [_fetchedResultsController.fetchedObjects count] +1){
        return; 
    }
    /*
    EditOrderLineView *detailViewController = [[EditOrderLineView alloc] initWithNibName:nil bundle:nil];
    detailViewController.context = self.context;
    
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:detailViewController];
    navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self presentModalViewController:navigationController animated:YES];
    //[self.navigationController pushViewController:detailViewController animated:YES];
    [navigationController release];
    [detailViewController release];
    */
     
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
