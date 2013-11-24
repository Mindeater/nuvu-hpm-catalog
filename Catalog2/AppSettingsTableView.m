//
//  AppSettingsTableView.m
//  Catalog2
//
//  Created by Ashley McCoy on 21/12/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "AppSettingsTableView.h"
#import "SettingsPage.h"

#import "CollectInfoAlertView.h"

@implementation AppSettingsTableView

@synthesize tableData;
@synthesize tableHeadings;
@synthesize infoStrings;

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
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView setBackgroundView:nil];
    self.tableView.backgroundColor = [UIColor blackColor];
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    ///////////////////////////////////////////
    // headings
    
    self.tableHeadings = [NSArray arrayWithObjects: 
                          @"Application defaults",
                          @"Contact Information",
                          @"About",
                          nil];
    
    ///////////////////////////////////////////////
    // info blocks
    self.infoStrings = [NSArray arrayWithObjects:
                        @"Welcome to the L&H Selector App\n\nThe quick and easy tool for creating an order of electrical accessories, such as switches and power points.\n\nThe App lets you compose pictures of switches and sockets from a variety of Legrand or HPM product ranges, on pre-set background colours to help you choose the best cover plate finish. Or, you can take a photo of a wall to see exactly how the plates look in a particular environment.\n\nThe featured brands and ranges include: Legrand Excel Life, Legrand Arteor, HPM Linea, and HPM Excel.\n\nOnce you have selected all the products you need and saved to the cart, the App will create a comprehensive product list, (including product codes and trade prices from HPM and Legrand ex GST), which you can then email to your local L&H electrical wholesaler, making ordering a breeze!\n\nPlease note: this app contains a sub-set of HPM and Legrand ranges of switches and sockets. For a comprehensive list please see the respective catalogues available online at:\nwww.legrand.com.au\nwww.hpm.com.au\n\nFor further information call 1300 369 777.\n\nHappy creating!\n\n\n"
                        /*"Instructions\n\nA) How to browse the catalogue?\n\n1. Go to main menu and tap the 'Product Catalogue' icon\n2. Select a brand of switches \n3. Swipe left or right through the mechanisms product list, once you like one then select cover plate at the bottom of the screen\n4. Select your choice of cover plate - you can also go back to the menu or mechanisms  by tapping the menu button at the top left of the screen to view more products\n\nB) How to create an order?\n\n1. Go to main menu and tap the 'Shopping Cart' icon\n2. Tap the plus button and name the order\n3. Go to main menu and tap the 'Product Catalogue' icon\n4. Select a brand of switches \n5. Swipe left or right through the mechanisms product list, once you like one then select a cover plate at the bottom of the screen\n6. Select your choice of cover plate - you can also go back to the menu or mechanisms  by tapping the menu button at the top left of the screen\n7. Choose 'Add to cart'  from the top right hand corner of the screen and select  'save to cart' \nIf you want to see the currently added product in the shopping cart then select 'go to cart' from the 'add to cart' button to view your current order\nIf you want to select more products to add to the cart then select the menu button to return to the catalogue\n\nC) Choosing a pre-set wall background or taking a picture of a wall.\n\nL&H selector allows you to choose a background to enable you to look at the catalogue to see how a product will look on different coloured backgrounds or you can even take a photo of your own wall to see how the product will look in your own interior.\n\nHow to select a pre-set background\n\n1. Go to main menu and select the 'Choose Wall Colour'  icon\n\n2. Select a background and then continue browsing the catalogue or creating an order as described above. The chosen wall colour will now appear as background on your product selections\n\nHow to take a photo\n\n1. Go to main menu and select 'Photograph Wall' \n2. Take a picture of your wall where a switch or power point will be installed. Select use if you are happy with the photograph\n3. Continue browsing the catalogue or creating an order as described above. The photograph will now appear as background on your product selections\n4. Once you have chosen your cover plate from the product catalogue you can then select the 'Resize and Save'  to resize the cover plate so it looks right on your photographed wall and also save it to your photo library"*/,
                        @"\n\n\n\tStudio NUVU 2011",
                        @"instructions",
                        nil];
    
    NSArray *switches = [NSArray arrayWithObjects:
                         //[NSArray arrayWithObjects:@"Movie Plays everytime App loads:",@"ud_Movie",nil],
                         [NSArray arrayWithObjects:@"Add Contact Settings to Email:",@"ud_AddContact",nil],
                         [NSArray arrayWithObjects:@"Price Adjustment:",@"ud_AddPricePercentage",nil],
                         nil];
    NSArray *contact = [NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:@"First Name:",@"ud_FName",nil],
                        [NSArray arrayWithObjects:@"Last Name:", @"ud_LName",nil],
                        [NSArray arrayWithObjects:@"Email:",     @"ud_Email",nil],
                        [NSArray arrayWithObjects:@"Phone:",     @"ud_Phone",nil],
                        [NSArray arrayWithObjects:@"Company:",   @"ud_Company",nil],
                        nil];
    NSArray *about = [NSArray arrayWithObjects:
                      @"About App",
                      @"Development and Design",
#ifdef LNHVERSION
#else
                      @"Instructions",
#endif
                     
                      nil];
    
    self.tableData = [NSArray arrayWithObjects:switches,contact,about, nil];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.title = @"Settings / Info";
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.tableData count];
}

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
    
    label.textColor = [UIColor whiteColor];
    label.shadowColor = [UIColor grayColor];
    label.shadowOffset = CGSizeMake(0.0, 1.0);
    label.font = [UIFont boldSystemFontOfSize:16];
    label.text = [self.tableHeadings objectAtIndex:section];
    
    // Create header view and add label as a subview
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, SectionHeaderHeight)];
    [view autorelease];
    [view addSubview:label];
    
    return view;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    // fixed font style. use custom view (UILabel) if you want something different
    return [self.tableHeadings objectAtIndex:section];
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[self.tableData objectAtIndex:section] count];
}

#define SWITCH_SECTION 0
#define TEXT_SECTION 1
#define VIEW_SECTION 2

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 40;
    switch (indexPath.section) {
        case SWITCH_SECTION:
            // add a switch to the cell
            break;
        case TEXT_SECTION:
            // add textfield to the cell
            break;
        case VIEW_SECTION:
            // this one will make a modal view
            break;
        default:
            break;
    }
    
    return height;
    /*
     CGSize size = [str sizeWithFont:[UIFont fontWithName:@"Georgia-Bold" size:18.0] constrainedToSize:CGSizeMake(240.0, 480.0) lineBreakMode:UILineBreakModeWordWrap];
     return size.height + 20;
     */
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    
    switch (indexPath.section) {
        case SWITCH_SECTION:
        {
            // add a switch to the cell
            /////////////////////////////////
            // the active switch
            UISwitch *switchview = [[UISwitch alloc] initWithFrame:CGRectZero];
            switchview.tag = indexPath.row;
            //switchview.delegate = self;
            [switchview addTarget:self action:@selector(switched:) forControlEvents:UIControlEventValueChanged];
            
            NSString *settingName = [[[self.tableData objectAtIndex:SWITCH_SECTION] 
                                      objectAtIndex:indexPath.row] objectAtIndex:1];
            
            if([[NSUserDefaults standardUserDefaults] boolForKey:settingName]){
                switchview.on = YES;
            }
            cell.accessoryView = switchview;
            [switchview release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            if(indexPath.row == 1){
                cell.textLabel.text = [NSString stringWithFormat:@"%@ (%i%%)",
                               [[[self.tableData objectAtIndex:SWITCH_SECTION] 
                                 objectAtIndex:indexPath.row] objectAtIndex:0],
                               [[[NSUserDefaults standardUserDefaults] stringForKey:@"ud_PricePercentage"] intValue]
                               ];
                
            }else{
                cell.textLabel.text = [[[self.tableData objectAtIndex:SWITCH_SECTION] 
                                    objectAtIndex:indexPath.row] objectAtIndex:0];
            }
        }
            break;
        case TEXT_SECTION:
        {
            cell.accessoryView = nil;
            // how wide is the device ?
            CGRect screenRect = [[UIScreen mainScreen] bounds];
            CGFloat screenWidth = screenRect.size.width;
            // add textfield to the cell
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(105, 5, screenWidth -200, 21)];
            textField.text = [[NSUserDefaults standardUserDefaults] 
                              stringForKey:[[[self.tableData objectAtIndex:TEXT_SECTION] 
                                        objectAtIndex:indexPath.row] objectAtIndex:1]];
            //textField.text = @"A Longer field here than you'd expect";
            textField.tag = indexPath.row;
            textField.delegate = self;
            textField.textColor = [UIColor whiteColor];
            //cell.accessoryView = textField;
            [cell.contentView addSubview:textField];
            //[cell.contentView bringSubviewToFront:textField];
            [textField release];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            //cell.textLabel.text = [[[self.tableData objectAtIndex:TEXT_SECTION] 
                                    //objectAtIndex:indexPath.row] objectAtIndex:0];
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 100, 21)];
            label.text = [[[self.tableData objectAtIndex:TEXT_SECTION] 
                           objectAtIndex:indexPath.row] objectAtIndex:0];
            label.textColor = [UIColor whiteColor];
            label.backgroundColor = [UIColor blackColor];
            [cell.contentView addSubview:label];
            [label release];
        }
            break;
        case VIEW_SECTION:
            cell.accessoryView = nil;
            cell.textLabel.text = [[self.tableData objectAtIndex:VIEW_SECTION] objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    
    // custom coloring
    cell.backgroundColor = [UIColor blackColor];
    cell.textLabel.textColor = [UIColor whiteColor];
    return cell;
}

#pragma mark - switch call back
- (void)switched:(id)sender 
{
    UISwitch *switchedSwitch = (UISwitch *)sender;
    [switchedSwitch resignFirstResponder];
    
    //NSLog(@"Switched %i",switchedSwitch.tag);
    
    NSString *userSettingName = [[[self.tableData objectAtIndex:SWITCH_SECTION] 
                                  objectAtIndex:switchedSwitch.tag] objectAtIndex:1];
    //NSLog(@"Need to change : %@",userSettingName);
    
    [[NSUserDefaults standardUserDefaults] 
     setBool: [switchedSwitch isOn]
     forKey:userSettingName];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    

}

#pragma mark - text edit callback

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
   // NSLog(@"Editing done for %i",textField.tag);
    NSString *userSettingName = [[[self.tableData objectAtIndex:TEXT_SECTION] 
                                  objectAtIndex:textField.tag] objectAtIndex:1];
    //NSLog(@"Need to change : %@",userSettingName);
    [[NSUserDefaults standardUserDefaults] 
     setObject:textField.text
     forKey:userSettingName];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    switch (indexPath.section) {
        case SWITCH_SECTION:
            // add a switch to the cell
            if(indexPath.row == 1){
                // Pricing info from here ...
               // NSLog(@"Pricing INformation here please");
                [self setPricingPercentage];
            }
            break;
        case TEXT_SECTION:
            // add textfield to the cell
            break;
        case VIEW_SECTION:
        {
        // this one will load a new view controller
            SettingsPage *addController = [[SettingsPage alloc]
                                                      initWithNibName:nil bundle:nil];
            
            if(indexPath.row == 0){
                addController.infomationString = [self.infoStrings objectAtIndex:indexPath.row]; 
                [self.navigationController pushViewController:addController animated:YES];
                
            }
            
            
            if(indexPath.row == 1){
//                addController.logoImage = [UIImage imageWithContentsOfFile:
//                                           [[NSBundle mainBundle] pathForResource:@"nuvulogo" ofType:@"png"]];
//                // add the nuvu movie
                addController.movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] 
                                                                 pathForResource:@"NuvuDevLogo2" ofType:@"mov"]];
                UINavigationController *navigationController = [[UINavigationController alloc]
                                                                initWithRootViewController:addController];
                [self presentModalViewController:navigationController animated:YES];
                [navigationController release];
                
                
            }
            if(indexPath.row == 2){
                addController.infomationString = [self.infoStrings objectAtIndex:indexPath.row];
                addController.movieURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] 
                                                                 pathForResource:@"AppInstructionVideo_4MArch" ofType:@"mov"]];
                UINavigationController *navigationController = [[UINavigationController alloc]
                                                                initWithRootViewController:addController];
                [self presentModalViewController:navigationController animated:YES];
                [navigationController release];                
            }
            [addController release];
            /*
            // Create the navigation controller and present it modally.
            UINavigationController *navigationController = [[UINavigationController alloc]
                                                            initWithRootViewController:addController];
            [self presentModalViewController:navigationController animated:YES];
            
            // The navigation controller is now owned by the current view controller
            // and the root view controller is owned by the navigation controller,
            // so both objects should be released to prevent over-retention.
            [navigationController release];
             */
            
            
        }
            break;
        default:
            break;
    }
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}

#pragma mark - pricng percentage add methods
-(void)setPricingPercentage
{
    
    
    // add the alert view now
    CollectInfoAlertView *prompt = [CollectInfoAlertView alloc];
	prompt = [prompt initWithTitle:@"Price Adjustment (+/-)" message:@"Please enter a Percentage Value" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"OK"];
    [prompt setTextFieldStyle:UIKeyboardTypeNumberPad];
    [prompt addObserver:self forKeyPath:@"buttonIndex" options:NSKeyValueObservingOptionNew context:nil];
    
    prompt.modalPresentationStyle = UIModalPresentationFormSheet;
    prompt.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:prompt animated:YES completion:nil];
    prompt.view.superview.bounds = CGRectMake(0, 0, 300, 200);
	//[prompt show];
	[prompt release];
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
        [[NSUserDefaults standardUserDefaults]
         setFloat: [entered floatValue]
         forKey:@"ud_PricePercentage"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self.tableView reloadData];

    }
    
    [self dismissModalViewControllerAnimated:YES];
}


@end
