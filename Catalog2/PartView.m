//
//  PartView.m
//  Catalog2
//
//  Created by Ashley McCoy on 17/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "PartView.h"
#import "ProductChooserView.h"

#import "AddPartToOrder.h"
#import "FacePlateView.h"

@implementation PartView

@synthesize categoryName;
@synthesize selected;
@synthesize controlsView;
@synthesize orientationPrefix;
@synthesize brandName;
@synthesize productName;
@synthesize price;

@synthesize _parent;
@synthesize toolBar;

@synthesize currentAction;

-(void)dealloc
{
    [toolBar release];
    [currentAction release];
    [controlsView release];
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
    }
    return self;
}

-(void)viewDidLoad
{
    [self addNavigationBar];
    //_view.backgroundColor = [UIColor whiteColor];
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
   NSLog(@"\n1. Adding NAvigation BAr\n");
    
    //////////////////////////////////
    // Navigation Bar
    
    /* next and prev
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextItem:)];          
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];
    
    UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(previousItem:)];          
    self.navigationItem.leftBarButtonItem = anotherButton2;
    [anotherButton2 release];
    */
    
    
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuSheet:)];
    self.navigationItem.leftBarButtonItem = infoButton;
    [infoButton release];
    
    // this guy only gets added for faceplates
    if([self isKindOfClass:[FacePlateView class]]){
        UIBarButtonItem *newOrderButton = [[UIBarButtonItem alloc]
                                           initWithTitle:@"Add to Cart" style:UIBarButtonItemStyleBordered target:self action:@selector(addItemToCart:)];
        self.navigationItem.rightBarButtonItem = newOrderButton;
        [newOrderButton release];
    }
    
     
}

-(void)addToolBarToView
{
    NSLog(@"\n2. Adding ToolBAr");
    
    ///////////////////////////////////////////////
    // ToolBar
    toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.tintColor = [UIColor blackColor];
    [toolBar sizeToFit];//Set the toolbar to fit the width of the app.
    CGFloat toolBarHeight = [toolBar frame].size.height;//Caclulate the height of the toolbar
    NSLog(@"%f",toolBarHeight);
    /*
    CGRect rootViewBounds = self.view.bounds; //Get the bounds of the parent view
    //Get the height of the parent view.
    CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
    //Get the width of the parent view,
    CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
    //Create a rectangle for the toolbar
    CGRect rectArea = CGRectMake(0, rootViewHeight - toolBarHeight-60, rootViewWidth, toolBarHeight);
    //CGRect rectArea = CGRectMake(0, 400, rootViewWidth, toolBarHeight);
    */
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //Reposition and resize the receiver
    [toolBar setFrame:CGRectMake(0, screenHeight-toolBarHeight-80, screenWidth, toolBarHeight)];
    
    //Create a button
    
    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(nextItem:)];          
    
    UIBarButtonItem	*flex = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];

    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStyleBordered target:self action:@selector(previousItem:)];          
    
    /*
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuSheet)];
    UIBarButtonItem *newOrderButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Add to Cart" style:UIBarButtonItemStyleBordered target:self action:@selector(addItemToCart)];
    */
    //[toolBar setItems:[NSArray arrayWithObjects:infoButton,newOrderButton, nil]];
    [toolBar setItems:[NSArray arrayWithObjects:prevButton,flex,nextButton, nil]];

    [self.controlsView addSubview:toolBar];
    [prevButton release];
    [flex release];
    [nextButton release];
    
    //[infoButton release];
    //[newOrderButton release];
    [toolBar release];
    
    
    //////////////////////////////////////
    // gesture recogniser for the part
    /*
    UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressThePart:)];
    [self.view addGestureRecognizer:press];
    [press release];
    */
    // Create gesture recognizer
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
    NSString *message = [NSString stringWithFormat:@"%@ - %@:\n%@\n%@",
                         self.brandName,self.categoryName,self.productName,self.price];
    UIAlertView *notice = [[UIAlertView alloc] initWithTitle:@"Part Details" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
    [notice show];
    [notice release];
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
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Menu Choices" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Return To Main Menu" otherButtonTitles:@"Return to Catalog", @"Go To Cart", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	//[popupQuery showInView:self.view];
    [popupQuery showFromBarButtonItem:sender animated:YES];
	[popupQuery release];  
}

-(void)addItemToCart:(id)sender
{
    self.currentAction = @"cart";
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Menu Choices" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Save to Cart" otherButtonTitles: @"Go To Cart", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	//[popupQuery showInView:self.view];
    [popupQuery showFromBarButtonItem:sender animated:YES];
	[popupQuery release];    
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
            NSLog(@"Go To Cart");
        } else if (buttonIndex == 3) {
            //NSLog(@"Cancel Button Clicked");
        }
    }else if([self.currentAction isEqualToString:@"cart"]){
        if (buttonIndex == 0) {
            //NSLog(@"Add Whatever is here to the cart");
            [self addToDefaultActiveOrder];
        } else if (buttonIndex == 1) {
            NSLog(@"Go to the Cart");
        } else if (buttonIndex == 2) {
            NSLog(@"No Action from CArt");
        } 
    }
}
#pragma mark - actions for toolbar selections

-(void)addToDefaultActiveOrder
{
    [self updateSelectedStatus];
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
#pragma mark - abstract methods should defined in subclass

-(void)drawWithItems:(NSArray *)items
{
}
-(void)chooseMe
{
}
-(UIImage *)getMechanismImage
{
    return [[[UIImage alloc] init ] autorelease];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
