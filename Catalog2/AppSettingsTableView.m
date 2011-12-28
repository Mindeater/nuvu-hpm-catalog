//
//  AppSettingsTableView.m
//  Catalog2
//
//  Created by Ashley McCoy on 21/12/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "AppSettingsTableView.h"
#import "SettingsPage.h"

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
                        @"Welcome to the L&H Switches & Sockets Selector App \n\nThe quick and easy tool for creating an order of electrical accessories, such as switches and powerpoints.\n\nThe App lets you compose pictures of switches and sockets from a variety of Legrand or HPM product ranges, on pre-set background colours to help you choose the best coverplate finish. Or, you can upload a photo of a wall to see exactly how the plates look in a particular environment.\n\nThe featured brands and ranges include: Legrand Excel Life, Legrand Arteor, HPM Linea, HPM Excel and BTicino Living, Light and Light Tech.\n\nOnce you have selected all the products you need and saved to the cart, the App will create a comprehensive product list, (including product codes and trade prices from HPM and Legrand ex GST), which you can then email to your local L&H electrical wholesaler, making ordering a breeze!\n\n\nPlease note: this app contains a sub-set of HPM and Legrand ranges of switches and sockets. For a comprehensive list please see the respective catalogues available online at:\nwww.legrand.com.au\nwww.hpm.com.au\n\nFor further information call 1300 369 777.\n\nHappy creating!",
                        @"Studio NUVU 2011",
                        nil];
    
    NSArray *switches = [NSArray arrayWithObjects:
                         [NSArray arrayWithObjects:@"Movie Plays everytime App loads:",@"ud_Movie",nil],
                         [NSArray arrayWithObjects:@"Add Contact Settings to Email:",@"ud_AddContact",nil],
                         nil];
    NSArray *contact = [NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:@"First Name:",@"ud_FName",nil],
                        [NSArray arrayWithObjects:@"Last Name:", @"ud_LName",nil],
                        [NSArray arrayWithObjects:@"Email:",     @"ud_Email",nil],
                        [NSArray arrayWithObjects:@"Phone:",     @"ud_Phone",nil],
                        [NSArray arrayWithObjects:@"Company:",   @"ud_Company",nil],
                        nil];
    NSArray *about = [NSArray arrayWithObjects:
                      @"App Usage",
                      @"Development and Design",
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
            cell.textLabel.text = [[[self.tableData objectAtIndex:SWITCH_SECTION] 
                                    objectAtIndex:indexPath.row] objectAtIndex:0];
        }
            break;
        case TEXT_SECTION:
        {
            // add textfield to the cell
            UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(5, 5, 200, 21)];
            textField.text = [[NSUserDefaults standardUserDefaults] 
                              stringForKey:[[[self.tableData objectAtIndex:TEXT_SECTION] 
                                        objectAtIndex:indexPath.row] objectAtIndex:1]];
            //textField.text = @"A Longer field here than you'd expect";
            textField.tag = indexPath.row;
            textField.delegate = self;
            textField.textColor = [UIColor whiteColor];
            cell.accessoryView = textField;
            //[cell.accessoryView addSubview:textField];
            [textField release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = [[[self.tableData objectAtIndex:TEXT_SECTION] 
                                    objectAtIndex:indexPath.row] objectAtIndex:0];
        }
            break;
        case VIEW_SECTION:
            // this one will make a modal view
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
    
    NSLog(@"Switched %i",switchedSwitch.tag);
    
    NSString *userSettingName = [[[self.tableData objectAtIndex:SWITCH_SECTION] 
                                  objectAtIndex:switchedSwitch.tag] objectAtIndex:1];
    NSLog(@"Need to change : %@",userSettingName);
    
    [[NSUserDefaults standardUserDefaults] 
     setBool: [switchedSwitch isOn]
     forKey:userSettingName];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    

}

#pragma mark - text edit callback

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField resignFirstResponder];
    NSLog(@"Editing done for %i",textField.tag);
    NSString *userSettingName = [[[self.tableData objectAtIndex:TEXT_SECTION] 
                                  objectAtIndex:textField.tag] objectAtIndex:1];
    NSLog(@"Need to change : %@",userSettingName);
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
            break;
        case TEXT_SECTION:
            // add textfield to the cell
            break;
        case VIEW_SECTION:
        {
        // this one will make a modal view
            NSLog(@"Here we go add a modal view controller");
            SettingsPage *addController = [[SettingsPage alloc]
                                                      initWithNibName:nil bundle:nil];
            
            addController.infomationString = [self.infoStrings objectAtIndex:indexPath.row];
            
            if(indexPath.row == 1){
                addController.logoImage = [UIImage imageWithContentsOfFile:
                                           [[NSBundle mainBundle] pathForResource:@"nuvulogo" ofType:@"png"]];
            }
            // Create the navigation controller and present it modally.
            UINavigationController *navigationController = [[UINavigationController alloc]
                                                            initWithRootViewController:addController];
            [self presentModalViewController:navigationController animated:YES];
            
            // The navigation controller is now owned by the current view controller
            // and the root view controller is owned by the navigation controller,
            // so both objects should be released to prevent over-retention.
            [navigationController release];
            [addController release];
            
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

@end
