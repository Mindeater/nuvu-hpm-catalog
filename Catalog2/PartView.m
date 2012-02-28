//
//  PartView.m
//  Catalog2
//
//  Created by Ashley McCoy on 17/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "PartView.h"
#import "ProductChooserView.h"
#import <QuartzCore/QuartzCore.h>

#import "AddPartToOrder.h"
#import "FacePlateView.h"


@implementation PartView

@synthesize categoryName;
@synthesize selected;
@synthesize controlsView;
@synthesize partLabel;
@synthesize countLabel;

@synthesize adjustImagePositionY;
@synthesize adjustImageFrameHeightFactor;

@synthesize countNum,countTotal;

@synthesize orientationPrefix;
@synthesize brandName;
@synthesize productName;
@synthesize price;
@synthesize parts;

@synthesize wallImage;

@synthesize _parent;
@synthesize toolBar;

@synthesize currentAction;

@synthesize popupQuery;

-(void)dealloc
{
    [toolBar release];
    [currentAction release];
    self.price = nil;
    self.parts = nil;
    [controlsView release];
    [partLabel release];
    [countLabel release];
    [super dealloc];
}

/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
 */

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        controlsView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        self.currentAction = @"";
        
        adjustImagePositionY = 60.0;
        adjustImageFrameHeightFactor = 60.0;
    }
    return self;
}

#pragma mark - view lifecycle
-(void)viewDidLoad
{
    [self addNavigationBar];
    countNum = 1;
    
    //self.view.backgroundColor = [UIColor redColor];
    //self.view.backgroundColor = [UIColor clearColor];
    //[self addToolBarToView];
    ///////////////////////////////////
    // Gesture recognisers
    // adapted from https://github.com/nicktmro/NPGesturedViewController
    
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] 
                                                        initWithTarget:self
                                                        action:@selector(previousItem:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:swipeGestureRecognizer];
    [swipeGestureRecognizer release];
    
    //-- please note that Apple does not respect the contract in their header file for the direction property. Sadly only one direction can be used per gesture recogniser
    swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] 
                              initWithTarget:self
                              action:@selector(nextItem:)];
    swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:swipeGestureRecognizer];    
    [swipeGestureRecognizer release];
}

#pragma mark - UI additions

-(void)addNavigationBar
{    
    //////////////////////////////////
    // Navigation Bar buttons
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuSheet:)];
    self.navigationItem.leftBarButtonItem = infoButton;
    [infoButton release];
    
    // this guy only gets added for faceplates
    if([self isKindOfClass:[FacePlateView class]]){
        UIBarButtonItem *newOrderButton = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Order" style:UIBarButtonItemStyleBordered target:self action:@selector(addItemToCart:)];
        self.navigationItem.rightBarButtonItem = newOrderButton;
        [newOrderButton release];
    }
    
    ////////////////////////
    // view title
    self.title = self.categoryName;
    
    
}

-(void)addToolBarToView
{    
    ///////////////////////
    // reusable heights
    CGFloat textBoxHeight = 30;
    // supposed to - With Personal Hotspot enabled, it returns 40, and returns 20 otherwise
    // but doesn't !!
    CGFloat statusBarHeight = 20.0; //[[UIApplication sharedApplication] statusBarFrame].size.height;
    
    NSLog(@"\n\nTOOL bar Height : %f\n\n",statusBarHeight);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = self.view.frame.size.height -20;//screenRect.size.height;
    CGFloat fontSize = 12;
    /*
    NSLog(@"\n\n\n VIEW - Called AddToolBar\n x: %f, y: %f, w: %f, y: %f",
          self.view.frame.origin.x,
          self.view.frame.origin.y,
          self.view.frame.size.width,
          self.view.frame.size.height);
     */
    
    ///////////////////////////////
    // passed background image
    UIImageView *bg = [[UIImageView alloc] initWithImage:self.wallImage];
    //NSLog(@"\n\nimage Size \nwidth:%f - height:%f",self.wallImage.size.width,self.wallImage.size.height);
    
    bg.frame = CGRectMake(0, 0, 1000, 1000); // this is the size of the in built bg's
    [self.controlsView addSubview:bg];
    [self.view sendSubviewToBack:self.controlsView];
    [bg release];
    
    ///////////////////////////////////////////////
    // ToolBar
    toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.tintColor = [UIColor blackColor];
    [toolBar sizeToFit];//Set the toolbar to fit the width of the app.
    
    CGFloat toolBarHeight = [toolBar frame].size.height;//Caclulate the height of the toolbar

   // NSLog(@"\nSCREEN SIZE \nwidth:%f height:%f",screenWidth,screenHeight);
    
    /*
    
    NSLog(@"\nSCREEN SIZE \nwidth:%f height:%f \n statusBarHeight:%f tooBarHeight:%f",screenWidth,screenHeight, statusBarHeight,toolBarHeight);

    NSLog(@"frame.origin.x: %f", self.view.frame.origin.x);
    NSLog(@"frame.origin.y: %f", self.view.frame.origin.y);
    NSLog(@"frame.size.width: %f", self.view.frame.size.width);
    NSLog(@"frame.size.height: %f", self.view.frame.size.height);
    */
    
    toolBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin);

    //Reposition and resize the toolBar
    [toolBar setFrame:CGRectMake(0, screenHeight-statusBarHeight-toolBarHeight, screenWidth, toolBarHeight)];


    ///////////////////////////////////////////////
    // Labels for the part
    partLabel = [[UILabel alloc] 
                        initWithFrame:CGRectMake(0,screenHeight-statusBarHeight-toolBarHeight-textBoxHeight, screenWidth, textBoxHeight)];      
   // partLabel.text = @"LABEL PlaceHolder +++++++ here ";
    if([self.parts isEqualToString:@"h-No-coverplate"]){
        self.productName = @"No Coverplate Available";
    }
    partLabel.font = [UIFont systemFontOfSize:fontSize];
    partLabel.text = self.productName;
    partLabel.textColor = [UIColor whiteColor];
    //partLabel.backgroundColor = [UIColor blackColor];
    partLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    partLabel.lineBreakMode = UILineBreakModeWordWrap;
    partLabel.numberOfLines = 0;
    partLabel.textAlignment = UITextAlignmentCenter;
    [self.controlsView addSubview:partLabel];
    
    ////////////////////////////////////////////////
    // Label for counting
    countLabel = [[UILabel alloc]
                  initWithFrame:CGRectMake(0,screenHeight-statusBarHeight-toolBarHeight-textBoxHeight*2, screenWidth, textBoxHeight)];
    countLabel.font = [UIFont systemFontOfSize:fontSize];
    countLabel.text = [NSString stringWithFormat:@"%i of %i",countNum,countTotal];
    countLabel.textAlignment = UITextAlignmentCenter;
    countLabel.textColor = [UIColor whiteColor];
    //countLabel.backgroundColor = [UIColor blackColor];
    countLabel.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
    [self.controlsView addSubview:countLabel];
    
    ///////////////////
    //Buttons
    
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextItem:)];          
    
    UIBarButtonItem	*flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    ///////////////////////////////
    // button to choose item
    UIBarButtonItem *chooseItem;
    if([self isKindOfClass:[FacePlateView class]]){
        chooseItem = [[UIBarButtonItem alloc] initWithTitle:@"Resize and Save" style:UIBarButtonItemStyleBordered target:self action:@selector(chooseMe)];
    }else{
        chooseItem = [[UIBarButtonItem alloc] initWithTitle:@"Choose Cover Plate" style:UIBarButtonItemStyleBordered target:self action:@selector(chooseMe)];
    }
    
    UIBarButtonItem	*flex2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previousItem:)];          
    
    if(countTotal > 1){
        [toolBar setItems:[NSArray arrayWithObjects:prevButton,flex,chooseItem,flex2,nextButton, nil]];
    }else{
        [toolBar setItems:[NSArray arrayWithObjects:flex,chooseItem,flex2,nil]];
    }
    [self.controlsView addSubview:toolBar];
    [prevButton release];
    [flex release];
    [chooseItem release];
    [flex2 release];
    [nextButton release];
    
    [toolBar release];
    
    
    //////////////////////////////////////
    // gesture recogniser for the part
    UITapGestureRecognizer *oneFingerTwoTaps = 
    [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pressThePart:)] autorelease];
    
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    
    // Add the gesture to the view
    [[self view] addGestureRecognizer:oneFingerTwoTaps];
}

-(void)pressThePart:(id)sender
{
    // number format for price
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
    [formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    float adjustedPrice = [self.price floatValue];
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ud_AddPricePercentage"]){
        float multiplier = [[[NSUserDefaults standardUserDefaults] stringForKey:@"ud_PricePercentage"] floatValue] /100;
        //NSLog(@" MUltiplier -- |%f|",[[[NSUserDefaults standardUserDefaults] stringForKey:@"ud_PricePercentage"] floatValue]);
        adjustedPrice = adjustedPrice + adjustedPrice * multiplier;
    }
    
    NSString *message = [NSString stringWithFormat:@"%@ - %@:\n%@\n%@\n%@",
                         self.brandName,
                         self.categoryName,
                         self.productName,
                         [formatter stringFromNumber: [NSNumber numberWithFloat: adjustedPrice]],
                         self.parts];
    
    UIAlertView *notice = [[UIAlertView alloc] initWithTitle:@"Part Details" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [notice show];
    
    [notice release];
    [formatter release];
}

-(void)setOrientationPrefix:(NSString *)newValue
{
    // retain the passed value
    if([newValue isEqualToString:@"Horizontal"]){
        orientationPrefix = [[NSString stringWithString:@"h-"] retain];
    }else if([newValue isEqualToString:@"Vertical"]){
        orientationPrefix = [[NSString stringWithString:@"v-"] retain];
    }else{
        orientationPrefix = [[NSString stringWithString:@""] retain];
    }
    //NSLog(@" Now is %@\n\n",orientationPrefix);
}

-(void)nextItem:(id)sender
{
    [self._parent nextItem:self];
}
-(void)previousItem:(id)sender
{
    [self._parent prevItem:self];
}

#pragma mark - OrderStatus

-(void)updateSelectedStatus
{
    
    // show the item is in the cart
    [self addOrderStatusToView];
}

-(void)addOrderStatusToView
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    ///////////////////////////////////
    //OrderStatus
    UILabel *orderStatusLabel = [[UILabel alloc] 
                        initWithFrame:CGRectMake(screenWidth-60,20, 60, 30)]; 
    // initWithFrame:CGRectMake(20,20, 400, 100)];      
    orderStatusLabel.text = @"Added";
    orderStatusLabel.textColor = [UIColor whiteColor];
    orderStatusLabel.backgroundColor = [UIColor clearColor];
    [self.controlsView addSubview:orderStatusLabel];
    [orderStatusLabel release]; 
}

#pragma mark - Actions from toolbar

-(void)showMenuSheet:(id)sender
{
    self.currentAction = @"menu";
    
    if (self.popupQuery)
    {
        [self.popupQuery dismissWithClickedButtonIndex:self.popupQuery.cancelButtonIndex animated:YES];
        self.popupQuery = nil;
        
        //return;
    }
    
    //UIActionSheet *popupQuery;
    if([self isKindOfClass:[FacePlateView class]]){
        popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Return To Main Menu" otherButtonTitles:@"Return to Catalogue", @"Mechanism", nil];
    }else{
        popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Return To Main Menu" otherButtonTitles:@"Return to Catalogue", nil];
    }
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	//[popupQuery showInView:self.view];
    [popupQuery showFromBarButtonItem:sender animated:YES];
	//[popupQuery release];  
}

-(void)addItemToCart:(id)sender
{
    self.currentAction = @"cart";
    
    if (self.popupQuery)
    {
        [self.popupQuery dismissWithClickedButtonIndex:self.popupQuery.cancelButtonIndex animated:YES];
        self.popupQuery = nil;
        
        //return;
    }
    
    popupQuery = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Add To Order" otherButtonTitles: @"Go To Current Order", @"View All Orders", @"New Order", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	//[popupQuery showInView:self.view];
    [popupQuery showFromBarButtonItem:sender animated:YES];
	//[popupQuery release];    
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([self.currentAction isEqualToString:@"menu"]){
        if (buttonIndex == 0) {
            //NSLog(@"Return to Main Menu");
            [self returnToMainMenu];
        } else if (buttonIndex == 1) {
            //NSLog(@"Return to Catalog");
            [self returnToCatalogMenu];
        } else if (buttonIndex == 2) {
            [self returnToMechanism];
        } else if (buttonIndex == 3) {
            //NSLog(@"Cancel Button Clicked");
        }
    }else if([self.currentAction isEqualToString:@"cart"]){
        if (buttonIndex == 0) {
            //NSLog(@"Add Whatever is here to the cart");
            [self addToDefaultActiveOrder];
        } else if (buttonIndex == 1) {
            [self gotoCart];
        } else if (buttonIndex == 2) {
            // show orders
            [self showOrders];
        } else if (buttonIndex == 3) {
            // new order
            [self addNewOrder];
        } else if (buttonIndex == 4) {
            // show orders
            //cancel
        }
    }
}
#pragma mark - actions for toolbar selections

-(void)addToDefaultActiveOrder
{
    //[self updateSelectedStatus];
    [self._parent addActivePartToCart];
    
}
-(void)returnToMainMenu
{
    [self._parent returnToMainMenu];
}
-(void)returnToCatalogMenu
{
    [self._parent returnToCatalogMenu];
}
-(void)returnToMechanism
{
    [self._parent returnToMechanism];
}
-(void)gotoCart
{
    [self._parent gotoCartPassBackString:self.title];
}
-(void)showOrders
{
    [self._parent showOrders];
}
-(void)addNewOrder
{
    [self._parent addNewOrder];
}

// don't forget Quartz.Core with this method
-(UIImage *)getMechanismImage
{
    self.controlsView.hidden = YES;
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
    self.controlsView.hidden = NO;
    return screenshot;
}

-(void)chooseMe
{
    self.selected =YES;
}


#pragma mark - abstract methods should defined in subclass

-(void)drawWithItems:(NSArray *)items
{
}

@end
