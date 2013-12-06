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
#import "CollectInfoAlertView.h"

#import "OrderLineModal.h"

#import "CollectInfoAlertView.h"


@implementation OrderDetailTableView


@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

@synthesize orderId;
@synthesize orderName;
@synthesize orderTotal,quantityCount;
@synthesize backString;

// Deal with the NZ part name Mappings
#ifdef NZVERSION
@synthesize nz_map;
#endif

@synthesize emailOrderBody;
@synthesize emailOrderBodyNoPrice;

@synthesize editingText;
@synthesize editPrompt;

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
    
    
    for(NSManagedObject *part in [orderLine valueForKey:@"items"]){
        
        
        if([[part valueForKey:@"type"] isEqualToString:@"Mechanism"]){

            [count appendFormat:@"%@\n",
             [[part valueForKey:@"mechanism"] valueForKey:@"count"]];
            
// Deal with the NZ part name Mappings
#ifdef NZVERSION
            NSString *mapped_name = [self.nz_map objectForKey:[part valueForKey:@"name"]];
            if([mapped_name length] > 0)
            {
                [part setValue:mapped_name forKey:@"name"];
            }
            
#endif
            // remove suffix from part names
            NSString *cleanName1 = [NSString stringWithFormat:@"%@",
                        [[part valueForKey:@"name"] stringByReplacingOccurrencesOfString:@"_ded" withString:@""]];
            
            NSString *cleanName2 = [NSString stringWithFormat:@"%@",
                                   [cleanName1 stringByReplacingOccurrencesOfString:@"_TV" withString:@""]];
            
            NSString *cleanName = [NSString stringWithFormat:@"%@",
                                   [cleanName2 stringByReplacingOccurrencesOfString:@"_dim" withString:@""]];
            

            // handle mutliple parts
            if([[[part valueForKey:@"mechanism"] valueForKey:@"count"] intValue] >1){
                
                [mechPartDesc appendFormat:@"%ix %@\n",
                        [[[part valueForKey:@"mechanism"] valueForKey:@"count"] intValue],
                        cleanName];
                        //[part valueForKey:@"name"]];
                
                totalCost += [[[part valueForKey:@"mechanism"] valueForKey:@"price"] floatValue] * [[[part valueForKey:@"mechanism"] valueForKey:@"count"] floatValue];

            }else{
                
                [mechPartDesc appendFormat:@"%@\n",cleanName];
                
                totalCost += [[[part valueForKey:@"mechanism"] valueForKey:@"price"] floatValue];

            }
            

        
        }else{
            NSString *cleanName = [NSString stringWithFormat:@"%@",
                                    [[part valueForKey:@"name"] stringByReplacingOccurrencesOfString:@"_Dimmer" withString:@""]];
            
            [faceplatePartDesc appendFormat:@"\n%@\n",cleanName];
            
            [faceplateName appendFormat:@"\n\nCover Plate: %@",[[part valueForKey:@"faceplate"] valueForKey:@"name"]];
                        
            [count appendString:@"1\n"];
             
            totalCost += [[[part valueForKey:@"faceplate"] valueForKey:@"price"] floatValue];
        }

    }
    
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
    
    editingText = @"";
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
                                       initWithTitle:@"Email Order" style:UIBarButtonItemStyleBordered target:self action:@selector(sendCurrentOrder:)];
    //self.navigationItem.rightBarButtonItem = newOrderButton;
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:self.editButtonItem,newOrderButton, nil];
    [newOrderButton release];
    
    self.emailOrderBody = [NSMutableString string];
    [self.emailOrderBody setString:@""];
    self.emailOrderBodyNoPrice = [NSMutableString string];
    [self.emailOrderBodyNoPrice setString:@""];
    
    [self addLeftNavigationButton];
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        // switch to the side
        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
    }
    
// Deal with the NZ part name Mappings
#ifdef NZVERSION
    self.nz_map = [NSDictionary dictionaryWithContentsOfFile:
                   [[NSBundle mainBundle] pathForResource:@"nz_map" ofType:@"plist"] ];
    
#endif
    
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

-(void)sendCurrentOrder:(id)sender
{
    // with Price or Not ?
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Price Option"
                                                      message:@"Include Prices in Email?"
                                                     delegate:self
                                            cancelButtonTitle:@"Yes"
                                            otherButtonTitles:@"No",nil];
    
    [message show];
    [message release];
}



-(void)emailOrder:(id)sender
{
    if ([MFMailComposeViewController canSendMail]) {
        
        NSString *title = (NSString *)sender;
        
        // CREATING MAIL VIEW
        MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
        controller.mailComposeDelegate = self;
        [controller setSubject:[NSString stringWithFormat:@"HPM Legrand Order (%@)",self.title]];
        
        NSString *footer = @"";
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"ud_AddContact"]){
            footer = [NSString stringWithFormat:@"<hr/><strong>%@ %@</strong><br/>%@<br/>p.%@<br />e.<a href=\"mailto:%@\">%@</a><br />",
                [[NSUserDefaults standardUserDefaults] stringForKey:@"ud_FName"],
                [[NSUserDefaults standardUserDefaults] stringForKey:@"ud_LName"],
                [[NSUserDefaults standardUserDefaults] stringForKey:@"ud_Company"],
                [[NSUserDefaults standardUserDefaults] stringForKey:@"ud_Phone"],
                [[NSUserDefaults standardUserDefaults] stringForKey:@"ud_Email"],
                [[NSUserDefaults standardUserDefaults] stringForKey:@"ud_Email"]
             ];
        }
        if([title isEqualToString:@"Yes"]){
            [emailOrderBody appendString:footer];
            [controller setMessageBody:self.emailOrderBody
                                isHTML:YES];
        }else{
            [emailOrderBodyNoPrice appendString:footer];
            [controller setMessageBody:self.emailOrderBodyNoPrice
                                isHTML:YES];
        }
        
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
            //abort();
            UIAlertView *dbError = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Internal Data storage Error.\n Please end this application with the home button\nIf you are seeing this error again please reinstall the application." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [dbError show];
            [dbError release];
        }
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

#pragma mark - Create the cell

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
    
    BOOL adjustPrice = [[NSUserDefaults standardUserDefaults] boolForKey:@"ud_AddPricePercentage"];
    
    
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
        cell.commentField.contentInset = UIEdgeInsetsMake(10,50,0,0);

        cell.quantField.text =@"QTY";
        cell.quantField.enabled = NO;
        cell.quantField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        
        cell.cell5.text = @"PRICE";
        cell.cell5.textAlignment = UITextAlignmentCenter;
        
        //////////////////////////
        // EMail Strings
        [self.emailOrderBody 
         appendFormat:@"<table border=\"1\"><tr><th>%@</th><th>%@</th><th>%@</th><th>%@</th><th>%@</th></tr>",
        @"Description",@"Code",@"Comments",@"Qty",@"Price"];
        [self.emailOrderBodyNoPrice
         appendFormat:@"<table border=\"1\"><tr><th>%@</th><th>%@</th><th>%@</th><th>%@</th></tr>",
         @"Description",@"Code",@"Comments",@"Qty"];
        
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
        cell.commentField.contentInset = UIEdgeInsetsMake(10,50,0,0);
        
        cell.cell5.text = [formatter stringFromNumber:[NSNumber numberWithFloat:orderTotal]];
        
        [self.emailOrderBody 
         appendFormat:@"<tr><th>%@</th><th>%@</th><th colspan=\"2\">%@</th><th>%@</th></tr></table>",
         @"",@"",@"TOTAL:",cell.cell5.text];
        [self.emailOrderBodyNoPrice 
         appendFormat:@"</table>"];
        
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
        [cell.cell2 sizeToFit];
        
        // comments
        //cell.commentField.placeholder = @"- - - - - - -";
        cell.commentField.tag = indexPath.row -1;
        cell.commentField.delegate = self;
        cell.commentField.text = [currentRecord valueForKey:@"comment"];
        
        
        // Qty
        //cell.cell3.text = [NSString stringWithFormat:@"%@",[currentRecord valueForKey:@"quantity"]]; //@"2";
        cell.quantField.tag = indexPath.row -1;
        cell.quantField.text = [NSString stringWithFormat:@"%@",[currentRecord valueForKey:@"quantity"]];
        //cell.quantField.keyboardType = UIKeyboardTypeNumberPad;
        cell.quantField.delegate = self;
        cell.quantField.frame = CGRectMake(cell.quantField.frame.origin.x, cell.quantField.frame.origin.y +5, cell.quantField.frame.size.width, cell.cellHeight);
        //NSLog(@" FRAME HEIGHT : %f",cell.cellHeight);
        
        //////////////////
        // Price
        
        NSNumber *theLineTotal = [NSNumber numberWithFloat:
                                        [[parts objectAtIndex:2] floatValue] * [[currentRecord valueForKey:@"quantity"] floatValue]];
        if(adjustPrice){
            float multiplier = [[[NSUserDefaults standardUserDefaults] stringForKey:@"ud_PricePercentage"] floatValue] /100;
            //NSLog(@" MUltiplier -- |%f|",[[[NSUserDefaults standardUserDefaults] stringForKey:@"ud_PricePercentage"] floatValue]);
            theLineTotal = [NSNumber numberWithFloat:[theLineTotal floatValue]+ [theLineTotal floatValue] * multiplier];
        }
        
        NSString *totalFormat = [formatter stringFromNumber:
                                 theLineTotal];
        
        cell.cell5.text = totalFormat; //@"$72.80";
        cell.cell5.textAlignment = UITextAlignmentRight;
        
        //////////////////////////////////
        // increment the internal counters
        orderTotal += [theLineTotal floatValue];
        quantityCount += [[currentRecord valueForKey:@"quantity"] intValue];
        
        ///////////////////////////////////
        // stored email string
        [self.emailOrderBody 
         appendFormat:@"<tr><td valign=\"top\">%@</td><td valign=\"top\">%@</td><td valign=\"top\">%@</td><td valign=\"top\">%@</td><td valign=\"top\">%@</td></tr>",
         [cell.cell1.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"],
         [cell.cell2.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"],
         [cell.commentField.text  stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"],
         cell.quantField.text,
         cell.cell5.text];
        
        [self.emailOrderBodyNoPrice 
         appendFormat:@"<tr><td valign=\"top\">%@</td><td valign=\"top\">%@</td><td valign=\"top\">%@</td><td valign=\"top\">%@</td></tr>",
         [cell.cell1.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"],
         [cell.cell2.text stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"],
         [cell.commentField.text  stringByReplacingOccurrencesOfString:@"\n" withString:@"<br />"],
         cell.quantField.text]; 
    }
    
    [formatter release];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

#pragma mark - respond to the UIAlerts

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];

    if([editingText isEqualToString:@""])
    {
        [self emailOrder:title];

    }
    //    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    //
    //    if([editingText isEqualToString:@""])
    //    {
    //        [self emailOrder:title];
    //
    //    }else if([editingText isEqualToString:@"quantity"]){
    //        if([title isEqualToString:@"OK"]){
    //
    //            NSString *entered = [(AlertPrompt *)alertView enteredText];
    //            NSManagedObject *curr = [_fetchedResultsController.fetchedObjects objectAtIndex:alertView.tag];
    //
    //            // make sure it is 1 or more
    //            int enteredNumber = [entered intValue];
    //            if(enteredNumber == 0){
    //                enteredNumber = 1;
    //            }
    //
    //            [curr setValue:[NSNumber numberWithInt:enteredNumber]
    //                    forKey:@"quantity"];
    //            NSError *error;
    //            [self.context save:&error];
    //        }
    //        editingText = @"";
    //    }else if([editingText isEqualToString:@"comment"]){
    //        if([title isEqualToString:@"OK"]){
    //            NSString *entered = [(AlertPrompt *)alertView enteredText];
    //
    //            NSManagedObject *curr = [_fetchedResultsController.fetchedObjects objectAtIndex:alertView.tag];
    //            [curr setValue:entered
    //                    forKey:@"comment"];
    //            NSError *error;
    //            [self.context save:&error];
    //        }
    //        
    //        editingText = @"";
    //    }
    
    
}

#pragma mark - UITextField delegates

#pragma mark Quantity Changes

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    //NSLog(@" - TextField - ");
    
    editingText = @"quantity";
//    
//    if( editPrompt == nil){
//        editPrompt = [AlertPrompt alloc];
//    }else{
//        [editPrompt release];
//        editPrompt = [AlertPrompt alloc];
//    }
//    
//    editPrompt = [editPrompt initWithTitle:@"Change Quantity" message:@"\n\n" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"OK"];
//    editPrompt.tag = textField.tag;
//    editPrompt.textField.text = textField.text;
//    
//	[editPrompt show];
    /*
    
    AlertPrompt *prompt = [AlertPrompt alloc];
	prompt = [prompt initWithTitle:@"Change Quantity" message:@"\n\n" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"OK"];
    prompt.tag = textField.tag;
    prompt.textField.text = textField.text;
    
	[prompt show];
	[prompt release];
    */
    
    
    // add the alert view now
    CollectInfoAlertView *prompt = [CollectInfoAlertView alloc];
	prompt = [prompt initWithTitle:@"Change Quantity" message:@"Please enter Value" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"OK"];
    [prompt setTextFieldStyle:UIKeyboardTypeNumberPad];
    prompt.tag = textField.tag;
    prompt.entry_txt.text = textField.text;
    [prompt addObserver:self forKeyPath:@"buttonIndex" options:NSKeyValueObservingOptionNew context:nil];
    
    prompt.modalPresentationStyle = UIModalPresentationFormSheet;
    prompt.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:prompt animated:YES completion:nil];
    prompt.view.superview.bounds = CGRectMake(0, 0, 300, 200);
	//[prompt show];
	[prompt release];
    
    return NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    
    [object removeObserver:self forKeyPath:@"buttonIndex"];

    if([[change objectForKey:@"new"] integerValue] == 1)
    {
        NSString *entered = [(CollectInfoAlertView *)object enteredText];
        int tag = [(CollectInfoAlertView *)object tag];
        NSManagedObject *curr = [_fetchedResultsController.fetchedObjects objectAtIndex:tag];
        
        if([editingText isEqualToString:@"quantity"])
        {
            // make sure it is 1 or more
            int enteredNumber = [entered intValue];
            if(enteredNumber == 0){
                enteredNumber = 1;
            }

            [curr setValue:[NSNumber numberWithInt:enteredNumber]
                 forKey:@"quantity"];
            
        }else if([editingText isEqualToString:@"comment"]){
            [curr setValue:entered
                    forKey:@"comment"];
        
        }

        editingText = @"";
        NSError *error =nil;
        [self.context save:&error];
        
    }
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    // move the tableviewcell to the top
    NSIndexPath *myIndexPath = [NSIndexPath indexPathForRow:textField.tag inSection:0];//[NSIndexPath indexPathWithIndex:textField.tag +1];
     [self.tableView scrollToRowAtIndexPath:myIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    // now move it down to allow for the bar
    //[self.tableView m
    /*
    // this actually moves the whole tableview !!
    float yOffset = 44.0f; // Change this how much you want!
    self.tableView.frame =  CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y + yOffset, self.tableView.frame.size.width, self.tableView.frame.size.height);
     */
    
    
}
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

#pragma mark - UITextView delegate

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    if([editingText isEqualToString:@"comment"]) return NO;
    
    editingText = @"comment";
//    NSLog(@"Edit comment called");
//    if( editPrompt == nil){
//        editPrompt = [AlertPrompt alloc];
//    }else{
//        
//        [editPrompt release];
//        editPrompt = [AlertPrompt alloc];
//    }
//	editPrompt = [editPrompt initWithTitle:@"Change Comment" message:@"\n\n" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"OK"];
//    editPrompt.tag = textView.tag;
//    editPrompt.textField.text = textView.text;
//    
//	[editPrompt show];
	//[prompt release];
    
    CollectInfoAlertView *prompt = [CollectInfoAlertView alloc];
	prompt = [prompt initWithTitle:@"Change Quantity" message:@"Please enter Value" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"OK"];
    [prompt setTextFieldStyle:UIKeyboardTypeNumberPad];
    prompt.tag = textView.tag;
    prompt.entry_txt.text = textView.text;
    [prompt addObserver:self forKeyPath:@"buttonIndex" options:NSKeyValueObservingOptionNew context:nil];
    
    prompt.modalPresentationStyle = UIModalPresentationFormSheet;
    prompt.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:prompt animated:YES completion:nil];
    prompt.view.superview.bounds = CGRectMake(0, 0, 300, 200);
	//[prompt show];
	[prompt release];
    
    return NO;
}

-(void)textViewDidBeginEditing:(UITextField *)textField{
   // NSLog(@"TextField did bigoin");
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


- (BOOL)textViewShouldReturn:(UITextField*)textField
{
    NSLog(@"TEXT Field should return");
    [textField resignFirstResponder];
    return YES;
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
        


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    if(indexPath.row == 0 || indexPath.row == [_fetchedResultsController.fetchedObjects count] +1){
        return; 
    }
    //NSLog(@"Index path for orderline %@, row %i",indexPath,indexPath.row);
    NSArray *items = [[[_fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row -1] valueForKey:@"items"] allObjects]; 
   // NSLog(@" --- %@",items);
    
    NSManagedObject *last;
    if([[[items lastObject] valueForKey:@"type"] isEqualToString:@"Mechanism"]){
        last = [[items lastObject] valueForKey:@"mechanism"];
    }else{
        last = [[items lastObject] valueForKey:@"faceplate"];
    }
    NSString *orientation = [[last valueForKey:@"product"] valueForKey:@"orientation"];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // default to iPad vertical
    CGFloat width = 480;
    CGFloat height = 700;
    if([orientation isEqualToString:@"Horizontal"]){
        width = 700;
        height = 480;
    }
    
    // create a detail view contoller for the iPhone
    OrderLineModal *detailViewController = [[OrderLineModal alloc] initWithNibName:nil bundle:nil];
    detailViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    detailViewController.context = self.context;
    detailViewController.orderLineManagedObject = [_fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row -1];
    
    // allow for a smaller centered version for the iPhone
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        width = screenWidth * 0.8;
        height = screenHeight * 0.8;

       detailViewController.sizeRect = CGRectMake((screenWidth - width)/2, (screenHeight - height)/2, width, height);
        detailViewController.view.backgroundColor = [UIColor whiteColor];
        
    }else{
    
        detailViewController.sizeRect = CGRectMake(0, 0, width, height);
       
    }
    [self presentModalViewController:detailViewController animated:YES];
    
    // sets the size
    detailViewController.view.superview.frame = CGRectMake(0, 0, width, height);//it's important to do this after 
    detailViewController.view.superview.center = self.view.center;
    [detailViewController release];
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

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch * touch = [touches anyObject];
    if(touch.phase == UITouchPhaseBegan) {
        [aTextField resignFirstResponder];
    }
}
*/
@end
