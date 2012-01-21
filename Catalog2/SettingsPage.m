//
//  SettingsPage.m
//  Catalog2
//
//  Created by Ashley McCoy on 18/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "SettingsPage.h"

@implementation SettingsPage

@synthesize infomationString;
@synthesize logoImage;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]autorelease];
    self.view.backgroundColor = [UIColor blackColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    /*
    ///////////////////////////////////////////////
    // ToolBar at the bottom
    UIToolbar *toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.tintColor = [UIColor blackColor];
    [toolBar sizeToFit];//Set the toolbar to fit the width of the app.
    CGFloat toolBarHeight = [toolBar frame].size.height;//Caclulate the height of the toolbar
    
    
    //Reposition and resize the receiver
    [toolBar setFrame:CGRectMake(0, screenHeight-toolBarHeight - 40, screenWidth, toolBarHeight)];
    
    
    UIBarButtonItem	*flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *chooseItem = [[UIBarButtonItem alloc] initWithTitle:@"OK" style:UIBarButtonItemStyleBordered target:self action:@selector(finish)];
    
    UIBarButtonItem	*flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [toolBar setItems:[NSArray arrayWithObjects:flex,chooseItem,flex2, nil]];
    
    
    [self.view addSubview:toolBar];
    [flex release];
    [chooseItem release];
    [flex2 release];
    
    [toolBar release];
    //
    /////////////////////////
    */
    CGFloat startY = 20;
    //CGFloat textViewHeight = screenHeight - toolBarHeight - 80;
    CGFloat textViewHeight = screenHeight - 80;
    if(self.logoImage != nil){
        CGFloat imgViewWidth = 500;
        CGFloat startImgX = (screenWidth - imgViewWidth)/2;
        // add the Logo
        UIImageView *innerShadow =[[UIImageView alloc] initWithImage:self.logoImage];
        innerShadow.frame = CGRectMake(startImgX, 40, imgViewWidth, imgViewWidth);
        innerShadow.backgroundColor = [UIColor whiteColor];
        innerShadow.contentMode = UIViewContentModeCenter;// UIViewContentModeScaleAspectFit;
        /// 
        
        
        // an inner shadow from stackoverflow
        [[innerShadow layer] setMasksToBounds:YES];
        [[innerShadow layer] setCornerRadius:12.0f];        
        [[innerShadow layer] setBorderColor:[[UIColor colorWithWhite:1.0 alpha:0.3] CGColor]];
        [[innerShadow layer] setBorderWidth:1.0f];
        [[innerShadow layer] setShadowColor:[[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f] CGColor]];
        [[innerShadow layer] setShadowOffset:CGSizeMake(0, 0)];
        [[innerShadow layer] setShadowOpacity:1];
        [[innerShadow layer] setShadowRadius:20.0];
        
        [self.view addSubview:innerShadow];
        [innerShadow release];
        
        /* some CGColors
         CGColorRef white = [UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:1.0f];
         CGColorRef black = [UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:1.0f];
         
         //	CGColorRef gray25 = [UIView colorWithRed:0.25f green:0.25f blue:0.25f alpha:1.0f];
         CGColorRef gray75 = [UIView colorWithRed:0.75f green:0.75f blue:0.75f alpha:1.0f];
         CGColorRef gray65 = [UIView colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.0f];
         CGColorRef gray50 = [UIView colorWithRed:0.65f green:0.65f blue:0.65f alpha:1.0f];
         
         CGColorRef white25 = [UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.25f];
         CGColorRef white50 = [UIView colorWithRed:1.0f green:1.0f blue:1.0f alpha:0.5f];
         CGColorRef black75 = [UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.75f];
         
         CGColorRef transparent = [UIView colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.0f];
         */
        startY += imgViewWidth;
        textViewHeight -= imgViewWidth;
        
    }
    
    //////////////////////////////////////////////////////
    // textview for information
    UITextView *info = [[UITextView alloc] initWithFrame:CGRectMake(40, startY, screenWidth - 80, textViewHeight)];
    info.textColor = [UIColor whiteColor];
    info.backgroundColor = [UIColor blackColor];
    info.editable = NO;
    info.text = self.infomationString;
    info.font = [UIFont systemFontOfSize:16];
    
    [self.view addSubview:info];
    [info release];
    
    
}

-(void)finish
{
    [self dismissModalViewControllerAnimated:YES];
}
/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
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
