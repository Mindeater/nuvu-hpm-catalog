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

@implementation PartView

@synthesize categoryName;
@synthesize selected;
@synthesize controlsView;
@synthesize orientationPrefix;
@synthesize brandName;
@synthesize productName;

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
        [self addNavigationBar];
        controlsView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        self.currentAction = @"";
    }
    return self;
}

-(void)viewDidLoad
{

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

-(void)addNavigationBar
{
   // NSLog(@"\nAdding NAvigation BAr\n");
    
    //////////////////////////////////
    // Navigation Bar
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextItem:)];          
    self.navigationItem.rightBarButtonItem = anotherButton;
    [anotherButton release];
    
    UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc] initWithTitle:@"Previous" style:UIBarButtonItemStylePlain target:self action:@selector(previousItem:)];          
    self.navigationItem.leftBarButtonItem = anotherButton2;
    [anotherButton2 release];
     
}

-(void)addToolBarToView
{
    ///////////////////////////////////////////////
    // ToolBar
    toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleDefault;
    toolBar.tintColor = [UIColor blackColor];
    //Set the toolbar to fit the width of the app.
    [toolBar sizeToFit];
    //Caclulate the height of the toolbar
    CGFloat toolBarHeight = [toolBar frame].size.height;
    //Get the bounds of the parent view
    CGRect rootViewBounds = self.view.bounds;
    //Get the height of the parent view.
    CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
    //Get the width of the parent view,
    CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
    //Create a rectangle for the toolbar
    CGRect rectArea = CGRectMake(0, rootViewHeight - toolBarHeight - 80, rootViewWidth, toolBarHeight);
    //CGRect rectArea = CGRectMake(0, 400, rootViewWidth, toolBarHeight);
    //Reposition and resize the receiver
    [toolBar setFrame:rectArea];
    
    //Create a button
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Menu" style:UIBarButtonItemStyleBordered target:self action:@selector(showMenuSheet)];
    UIBarButtonItem *newOrderButton = [[UIBarButtonItem alloc]
                                       initWithTitle:@"Add to Cart" style:UIBarButtonItemStyleBordered target:self action:@selector(addItemToCart)];
    
    [toolBar setItems:[NSArray arrayWithObjects:infoButton,newOrderButton, nil]];
    
    [self.controlsView addSubview:toolBar];
    [infoButton release];
    [newOrderButton release];
    [toolBar release];
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

#pragma mark - Actions from toolbar

-(void)showMenuSheet
{
    self.currentAction = @"menu";
    
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Menu Choices" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Return To Main Menu" otherButtonTitles:@"Return to Catalog", @"Go To Cart", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
	[popupQuery release];  
}
-(void)addItemToCart
{
    self.currentAction = @"cart";
    UIActionSheet *popupQuery = [[UIActionSheet alloc] initWithTitle:@"Menu Choices" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Save to Cart" otherButtonTitles: @"Go To Cart", nil];
	popupQuery.actionSheetStyle = UIActionSheetStyleBlackOpaque;
	[popupQuery showInView:self.view];
    //[popupQuery showFromToolbar:toolBar];
	[popupQuery release];    
}



-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if([self.currentAction isEqualToString:@"menu"]){
        if (buttonIndex == 0) {
            NSLog(@"Return to Main Menu");
            [self returnToMainMenu];
        } else if (buttonIndex == 1) {
            NSLog(@"Return to Catalog");
            [self returnToCatalogMenu];
        } else if (buttonIndex == 2) {
            NSLog(@"Go To Cart");
        } else if (buttonIndex == 3) {
            NSLog(@"Cancel Button Clicked");
        }
    }else if([self.currentAction isEqualToString:@"cart"]){
        if (buttonIndex == 0) {
            NSLog(@"Add Whatever is here to the cart");
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
