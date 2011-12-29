//
//  OrderDetailTableView.m
//  Catalog2
//
//  Created by Ashley McCoy on 28/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "OrderDetailTableView.h"
#import "OrderLineViewCell.h"

//#import "EditOrderLineView.h"


@implementation OrderDetailTableView


@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

@synthesize orderId;
@synthesize orderTotal,quantityCount;
@synthesize backString;

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
    NSMutableString *mechPartDesc = [[NSMutableString alloc] initWithString:@""];// [NSMutableString stringWithString:@""];
    NSMutableString *faceplatePartDesc = [[NSMutableString alloc] initWithString:@""];// [NSMutableString stringWithString:@""];
    NSMutableString *faceplateName = [[NSMutableString alloc] initWithString:@""]; //[NSMutableString stringWithString:@""];
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
                //NSLog(@"Mechanism add - %@",mechPartDesc);
            }else{
                [mechPartDesc appendFormat:@"%@\n",
                 [part valueForKey:@"name"]];
                totalCost += [[[part valueForKey:@"mechanism"] valueForKey:@"price"] floatValue];
               // NSLog(@"3. totalCount : %f",totalCost);
                //NSLog(@"Mechanism add - %@",mechPartDesc);
            }
            //NSLog(@"Price : %@",[[part valueForKey:@"mechanism"] valueForKey:@"price"]);
        
        }else{
            [faceplatePartDesc appendFormat:@"\n%@\n",[part valueForKey:@"name"]];
            
            [faceplateName appendFormat:@"\n\nCover Plate: %@",[[part valueForKey:@"faceplate"] valueForKey:@"name"]];
            
            //NSLog(@"CoverPlate :%@",faceplateName);
            
            [count appendString:@"1\n"];
             
            totalCost += [[[part valueForKey:@"faceplate"] valueForKey:@"price"] floatValue];
        }

    }
    // are there faceplates ?
    //NSLog(@"\nMECHANISMS : \n %@",[orderLine valueForKey:@"faceplate"]);
    
    NSArray *values = [NSArray arrayWithObjects:
            [NSString stringWithFormat:@"%@%@",mechPartDesc,faceplatePartDesc],
            count,
            [NSNumber numberWithFloat:totalCost],
            [NSString stringWithString:faceplateName],
            nil];
    [mechPartDesc release];
    [faceplatePartDesc release];
    [faceplateName release];
    
    return values;
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
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.navigationController.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
         //option 1:
         // force to landscape
        // First rotate the screen:
       // [UIApplication sharedApplication].statusBarOrientation = UIInterfaceOrientationLandscapeRight;
        // Then rotate the view and re-align it:
        
        CGAffineTransform landscapeTransform = CGAffineTransformMakeRotation( DEGREES_TO_RADIANS(90) );
        landscapeTransform = CGAffineTransformTranslate( landscapeTransform, 90.0, 90.0 );
        //[self.view setTransform:landscapeTransform];
        [self.navigationController.view setTransform:landscapeTransform];
        CGRect contentRect = CGRectMake(0, 0, 480, 320); 
		self.navigationController.view.bounds = contentRect; 
		[self.navigationController.view setCenter:CGPointMake(240.0f, 160.0f)];
         
        /*
         // option 2:
        //====================================================
		//ROTATES VIEW TO LANDSCAPE MODE AND SETS THE STAGE SIZE
		CGAffineTransform rotate = CGAffineTransformMakeRotation(1.57079633);
		[self.view setTransform:rotate];
		
		CGRect contentRect = CGRectMake(0, 0, 480, 320); 
		window.bounds = contentRect; 
		[window setCenter:CGPointMake(160.0f, 240.0f)];
		//====================================================
         */
         
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        // switch back
        
        
        CGAffineTransform portraitTransform = CGAffineTransformMakeRotation( DEGREES_TO_RADIANS(0) );
        portraitTransform = CGAffineTransformTranslate( portraitTransform, 0.0, 0.0 );
        //[self.view setTransform:landscapeTransform];
        [self.navigationController.view setTransform:portraitTransform];
        CGRect contentRect = CGRectMake(0, 0, 320, 480); 
		self.navigationController.view.bounds = contentRect; 
		[self.navigationController.view setCenter:CGPointMake(160.0f, 240.0f)];
        
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];
         
    }
}

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
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Order"
                                              inManagedObjectContext:self.context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(%K == %@)",@"uniqueId",self.orderId];
    [request setPredicate:predicate];
    
    NSArray *result = [self.context executeFetchRequest:request error:&error];
    [request release];
    
    self.title = [[result lastObject] valueForKey:@"name"];// @"An Order";
    
    
    ///////////////////////////////////////
    // Email Order Button
    UIBarButtonItem *newOrderButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Email Order" style:UIBarButtonItemStyleBordered target:self action:@selector(emailOrder:)];
    //self.navigationItem.rightBarButtonItem = newOrderButton;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.editButtonItem,newOrderButton, nil];
    [newOrderButton release];
    
    self.emailOrderBody = [NSMutableString string];
    
    [self addLeftNavigationButton];
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        // switch to the side
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
   
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}



- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
    }
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - sending an order  by email

-(void)emailOrder:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        // Build an email body to send
        // CREATING MAIL VIEW
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:@"HPM Product Order"];
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"ud_AddContact"]){
            [self.emailOrderBody appendFormat:@"<hr/><strong>%@ %@</strong><br/>%@<br/>p.%@<br />e.<a href=\"mailto:%@\">%@</a><br />",
                [[NSUserDefaults standardUserDefaults] stringForKey:@"ud_FName"],
                [[NSUserDefaults standardUserDefaults] stringForKey:@"ud_LName"],
                [[NSUserDefaults standardUserDefaults] stringForKey:@"ud_Company"],
                [[NSUserDefaults standardUserDefaults] stringForKey:@"ud_Phone"],
                [[NSUserDefaults standardUserDefaults] stringForKey:@"ud_Email"],
                [[NSUserDefaults standardUserDefaults] stringForKey:@"ud_Email"]
             ];
        }
        [controller setMessageBody:self.emailOrderBody
                            isHTML:YES];
        
//        [controller setMessageBody:[NSString stringWithString:self.emailOrderBody]
//                            isHTML:YES];
//        
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
    if(indexPath.row == 0 || indexPath.row == [_fetchedResultsController.fetchedObjects count]+1){
        return 60;
    }
    
    return 150;
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
    //Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[_fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects]+2;
    //return [_fetchedResultsController.fetchedObjects count] +2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    OrderLineViewCell *cell = (OrderLineViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[OrderLineViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.lineColor = [UIColor blackColor];
    }
    
    ////////////////////////////////
    // formating for prices
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    //////////////////////////////
    // count
    cell.indexRow = [NSNumber numberWithInt: indexPath.row -1];
    
    if (indexPath.row == 0){
        
        ////////////////////////////////
        // Order Table heading
        
        cell.topCell = YES;
        [cell setCellAsHeader];
        
        cell.cell1.textAlignment = UITextAlignmentCenter;
        cell.cell1.text = @"DESCRIPTION";
        
        cell.cell2.text = @"CODE";
        cell.cell2.textAlignment = UITextAlignmentCenter;
        
        cell.commentField.text =@"COMMENTS";
        cell.commentField.userInteractionEnabled = NO;
        cell.commentField.textAlignment = UITextAlignmentCenter;
        cell.commentField.contentInset = UIEdgeInsetsMake(10,100,0,0);

        cell.quantField.text =@"QTY";
        cell.quantField.enabled = NO;
        cell.quantField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        cell.cell5.text = @"PRICE";
        cell.cell5.textAlignment = UITextAlignmentCenter;
        
        [self.emailOrderBody 
         appendFormat:@"<table border=\"1\"><tr><th>%@</th><th>%@</th><th>%@</th><th>%@</th><th>%@</th></tr>",
        @"Description",@"Code",@"Comments",@"Qty",@"Price"];
        
    }else if(indexPath.row == [_fetchedResultsController.fetchedObjects count]+1){
        
        /////////////////////////////////////////
        // the bottom cell should have the total
        
        cell.bottomCell = YES;
        
        cell.cell1.text = @"";
        cell.cell2.text = @"";

        cell.quantField.text = @"";// [NSString stringWithFormat:@"%d",quantityCount];
        cell.quantField.enabled = NO;
        
        cell.commentField.text =@"TOTAL:";
        cell.commentField.userInteractionEnabled = NO;
        cell.commentField.textAlignment = UITextAlignmentCenter;
        cell.commentField.contentInset = UIEdgeInsetsMake(10,100,0,0);
        
        cell.cell5.text = [formatter stringFromNumber:[NSNumber numberWithFloat:orderTotal]];
        
        [self.emailOrderBody 
         appendFormat:@"<tr><th>%@</th><th>%@</th><th colspan=\"2\">%@</th><th>%@</th></tr></table>",
         @"",@"",@"TOTAL:",cell.cell5.text];
        
    }else{
        //////////////////////////////////
        // ordered Item
        
        cell.topCell = NO;
        cell.bottomCell = NO;
        // Configure the cell.
        
        //@TODO: needs to be boundry checked before calling ??
        NSManagedObject *currentRecord = [_fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row-1];
        
        // get the parts strings to populat the cell
        NSArray *parts = [self getPartsFromOrderLine:currentRecord];
        // desc
        /*
        NSString *descText = [NSString stringWithFormat:@" *%@%@*",
                              [currentRecord valueForKey:@"product"],
                              [parts objectAtIndex:3]];
       
        CGSize maximumLabelSize = CGSizeMake(296,9999);
        CGSize expectedLabelSize = [descText sizeWithFont:cell.cell1.font 
                                          constrainedToSize:maximumLabelSize 
                                              lineBreakMode:cell.cell1.lineBreakMode]; 
        NSLog(@" - Label size = %@",expectedLabelSize);
        //adjust the label the the new height.
        CGRect newFrame = cell.cell1.frame;
        NSLog(@"startFrame %@",newFrame);
        newFrame.size.height = expectedLabelSize.height;
        cell.cell1.frame = newFrame;
        NSLog(@"cellFrame %@",newFrame);
        cell.cell1.text = descText;
         */
        //[cell.cell1 sizeToFit];
        cell.cell1.text = [NSString stringWithFormat:@"%@%@",
                           [currentRecord valueForKey:@"product"],
                           [parts objectAtIndex:3]];
        cell.cell1.textAlignment = UITextAlignmentLeft;
        
        // code
        cell.cell2.text = [parts objectAtIndex:0];//[currentRecord valueForKey:@"name"];
        cell.cell2.textAlignment = UITextAlignmentLeft;
        
        // comments
        //cell.commentField.placeholder = @"- - - - - - -";
        cell.commentField.tag = indexPath.row -1;
        cell.commentField.delegate = self;
        cell.commentField.text = [currentRecord valueForKey:@"comment"];
        
        
        // Qty
        //cell.cell3.text = [NSString stringWithFormat:@"%@",[currentRecord valueForKey:@"quantity"]]; //@"2";
        cell.quantField.tag = indexPath.row -1;
        cell.quantField.text = [NSString stringWithFormat:@"%@",[currentRecord valueForKey:@"quantity"]];
        cell.quantField.delegate = self;
        //////////////////
        // price
        
        NSNumber *theLineTotal = [NSNumber numberWithFloat:
                                        [[parts objectAtIndex:2] floatValue] * [[currentRecord valueForKey:@"quantity"] floatValue]];
        NSString *totalFormat = [formatter stringFromNumber:
                                 theLineTotal];
        
        cell.cell5.text = totalFormat; //@"$72.80";
        cell.cell5.textAlignment = UITextAlignmentRight;
        
        //////////////////////////////////
        // increment the internal counters
        orderTotal += [theLineTotal floatValue];
        quantityCount += [[currentRecord valueForKey:@"quantity"] intValue];
        
        ///////////////////////////////////
        // sored email string
        [self.emailOrderBody 
         appendFormat:@"<tr><td>%@</td><td>%@</td><td>%@</td><td>%@</td><td>%@</td></tr>",
         cell.cell1.text,
         [cell.cell2.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"],
         [cell.commentField.text  stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"],
         cell.quantField.text,
         cell.cell5.text];        
    }
    
    [formatter release];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
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
        // the deleting row will always be one more than the OderLine inside it
        [self.context deleteObject:[_fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row -1]];
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - text delegates
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSManagedObject *curr = [_fetchedResultsController.fetchedObjects objectAtIndex:textField.tag];
    
    // make sure it is 1 or more
    int enteredNumber = [textField.text intValue];
    if(enteredNumber == 0){
        enteredNumber = 1;
    }
    
    [curr setValue:[NSNumber numberWithInt:enteredNumber]
            forKey:@"quantity"];
    NSError *error;
    [self.context save:&error];
    
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    //NSLog(@" Catch the textView finished editing %i",textView.tag);
    NSManagedObject *curr = [_fetchedResultsController.fetchedObjects objectAtIndex:textView.tag];
    [curr setValue:textView.text
            forKey:@"comment"];
    NSError *error;
    [self.context save:&error];
}

#pragma mark - NavBar Choices

-(void)addLeftNavigationButton
{
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuSheet:)];
    self.navigationItem.leftBarButtonItem = infoButton;
    [infoButton release];
}

-(void)showMenuSheet:(id)sender
{
    
    UIActionSheet *popupQuery;

    popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:@"Return To Main Menu" otherButtonTitles:self.backString, nil];

	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	//[popupQuery showInView:self.view];
    [popupQuery showFromBarButtonItem:sender animated:YES];
	[popupQuery release];  
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
        if (buttonIndex == 0) {
            //NSLog(@"Return to Main Menu");
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES]; 
        } else if (buttonIndex == 1) {
            //NSLog(@"Return to Catalog");
            [self.navigationController popViewControllerAnimated:YES];
        } else if (buttonIndex == 2) {
            //
        } else if (buttonIndex == 3) {
            //NSLog(@"Cancel Button Clicked");
        }
}
        
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
            //clear the totaol
            
            // the index path will be one less than the cell we want to remove
            if(indexPath.row +1 >[_fetchedResultsController.fetchedObjects count]){
                // create a new index path
                NSIndexPath *ip = [NSIndexPath indexPathForRow:indexPath.row +1 inSection:indexPath.section];
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:ip] withRowAnimation:UITableViewRowAnimationFade];
            }else{
                [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
            orderTotal = 0.0;
            [self.emailOrderBody setString:@""];
            [tableView reloadData];
            break;
            
        case NSFetchedResultsChangeUpdate:
            //NSLog(@" Update Change");
            quantityCount = 0;
            orderTotal = 0.0;
            [self.emailOrderBody setString:@""];
            [tableView reloadData];
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
