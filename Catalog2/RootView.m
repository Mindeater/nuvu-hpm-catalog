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

-(void)dealloc
{
    //[self.context release];
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
    //set the view's background color
    //self.view.backgroundColor = [UIColor whiteColor];
    //create the button
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //set the position of the button
    button.frame = CGRectMake(100, 170, 100, 30);
    //set the button's title
    [button setTitle:@"Catalog" forState:UIControlStateNormal];
    //listen for clicks
    [button addTarget:self action:@selector(showCatalog) forControlEvents:UIControlEventTouchUpInside];
    //add the button to the view
    [self.view addSubview:button];
    [button release];

   
}

-(void)showCatalog
{
    NSLog(@"StartCatalog");
    BrandTableView *brand = [[BrandTableView alloc]initWithNibName:nil bundle:nil];
    brand.context = self.context;
    [self.navigationController pushViewController:brand animated:YES];
    [brand release];
}


-(void)showAlert:(id)sender 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"My App" message: @"Welcome to ******. \n\nSome Message........" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
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
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
