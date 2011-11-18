//
//  RootView.m
//  Catalog2
//
//  Created by Ashley McCoy on 12/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "RootView.h"
#import "BrandTableView.h"

@implementation RootView

@synthesize context;
@synthesize button1,button2,button3,button4,button5,button6;

-(void)dealloc
{
    //[self.context release];
    //[self.view release];
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        NSLog(@"init with nib");
        /*
        UIViewController *rootController = [[UIViewController alloc] init];
        UINavigationController *navCtl = [[UINavigationController alloc] initWithRootController:rootController];
         */
        
        
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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    NSLog(@"Load view");
    // create the main view Controller
    //allocate the view
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view.backgroundColor = [UIColor blackColor];

    // main Navigation Options
    // 1. show catalog
    button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"Catalog" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(showCatalog) forControlEvents:UIControlEventTouchUpInside];

    // 2. Choose Background (from supplied)
    button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"Choose BG" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(showAlert:) forControlEvents:UIControlEventTouchUpInside];
    
    // 3. Create Background (camera or library)
    button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setTitle:@"Create BG" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(showAlert:) forControlEvents:UIControlEventTouchUpInside];
    
    // 4. show Orders
    button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button4 setTitle:@"Orders" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(showAlert:) forControlEvents:UIControlEventTouchUpInside];
    
    // 5. show Settings
    button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button5 setTitle:@"Settings" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(showAlert:) forControlEvents:UIControlEventTouchUpInside];
    
    // 6. show Search
    button6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button6 setTitle:@"Searc" forState:UIControlStateNormal];
    [button6 addTarget:self action:@selector(showAlert:) forControlEvents:UIControlEventTouchUpInside];
    
    //[[UIApplication sharedApplication] statusBarOrientation];
    [self layoutButtons: [[UIApplication sharedApplication] statusBarOrientation]];
    
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [self.view addSubview:button3];
    [self.view addSubview:button4];
    [self.view addSubview:button5];
    [self.view addSubview:button6];
   
}

-(void)layoutButtons:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        screenWidth = screenRect.size.height;
        screenHeight = screenRect.size.width;
    }


    
    float buttonWidth = 100;
    float buttonHeight = 100;
    float pad = 20;
    float startX = (screenWidth - (3 * buttonWidth + pad * 2))/2;
    float startY = (screenHeight -(2 * buttonHeight+pad))/2;
    
    button1.frame =  CGRectMake(startX, startY,
                                buttonWidth, buttonHeight);
    button2.frame =  CGRectMake(startX + buttonWidth+pad, startY,
                                buttonWidth, buttonHeight);
    button3.frame =  CGRectMake((startX + (buttonWidth * 2.0))+2*pad, startY,
                                buttonWidth, buttonHeight);
    button4.frame =  CGRectMake(startX, startY + buttonHeight+pad,
                                buttonWidth, buttonHeight);
    button5.frame =  CGRectMake(startX + buttonWidth +pad, startY + buttonHeight+pad,
                                buttonWidth, buttonHeight);
    button6.frame =  CGRectMake(startX + buttonHeight*2+2*pad, startY + buttonHeight+pad,
                                buttonWidth, buttonHeight);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutButtons:toInterfaceOrientation];
    
}


#pragma mark - Button call Backs
-(void)showCatalog
{
    NSLog(@"StartCatalog");
    //BrandTableView *brand = [[BrandTableView alloc]initWithNibName:nil bundle:nil];
    BrandTableView *brand = [[BrandTableView alloc] initWithStyle:UITableViewStyleGrouped];
    brand.context = self.context;
    [self.navigationController pushViewController:brand animated:YES];
    [brand release];
}


-(void)showAlert:(id)sender 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HPM Catalog" message: @"This feature. \n\nNot Yet Available" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [alert show];
    [alert release];
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
 - (void)viewDidLoad
{
    NSLog(@"View Did load");
     [super viewDidLoad];
    
    [self showAlert:button];
 


}
*/


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    self.button4 = nil;
    self.button5 = nil;
    self.button6 = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES; //(interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
