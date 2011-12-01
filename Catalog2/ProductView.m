//
//  ProductView.m
//  Catalog2
//
//  Created by Ashley McCoy on 13/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "ProductView.h"
#import "PartView.h"
#import "MechanismView.h"
#import "FacePlateView.h"

#import "AddItemToOrderView.h"
#import "AddOrderView.h"

#import "SmallDisplay.h"

#import <QuartzCore/QuartzCore.h>

@implementation ProductView

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

// scrollable iVars
@synthesize scrollView;
@synthesize pageOneDoc, pageTwoDoc, pageThreeDoc;
@synthesize prevIndex, currIndex, nextIndex;

@synthesize currentBrand,currentCategory,activeEntity;

@synthesize wallBg,mechBg,scrollHolder;

@synthesize selectedMechanism;
@synthesize selectedFacePlate;
@synthesize selectedProductName;
@synthesize currentFacePlates;

@synthesize manipulationMethodsShouldReturn;

@synthesize toolBar;

-(void)dealloc
{
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    self.context = nil;
    [pageOneDoc removeObserver:self forKeyPath:@"selected"];
    [pageOneDoc release];
    [pageTwoDoc removeObserver:self forKeyPath:@"selected"];
    [pageTwoDoc release];
    [pageThreeDoc removeObserver:self forKeyPath:@"selected"];
    [pageThreeDoc release];
    [wallBg release];
    mechBg = nil;
    scrollHolder = nil;
    [toolBar release];
    //[scrollView release];
    [selectedProductName release];
    [selectedMechanism release];
    [super dealloc];
}

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

#pragma mark - Core Data

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription 
                                   entityForName:@"Product" inManagedObjectContext:_context];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate 
                              predicateWithFormat:@"(%K == %@ AND %K == %@)",
                              @"category.name",self.currentCategory,
                              @"brand.name",self.currentBrand];
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

#pragma mark - selection handling

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"Choosen the Product %@",
          [[_fetchedResultsController.fetchedObjects objectAtIndex:self.currIndex] valueForKey:@"name"]);
    
    self.selectedProductName = [[_fetchedResultsController.fetchedObjects objectAtIndex:self.currIndex] valueForKey:@"name"];
    
    if([self.activeEntity isEqualToString:@"Mechanism"]){
        
        //self.selectedMechanism = [_fetchedResultsController.fetchedObjects objectAtIndex:self.currIndex];
        self.selectedMechanism = [self getObjToScroll:self.currIndex forEntityName:@"Mechanism"];

        /// push the passed image into the background Holder
        UIImage *mechPic = [pageTwoDoc getMechanismImage];
        //mechBg = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        // needs to match the size
        mechBg = [[UIView alloc]initWithFrame:self.view.frame];
        
        UIImageView *mechToAdd = [[UIImageView alloc] initWithImage:mechPic];
        mechToAdd.frame = [[UIScreen mainScreen] applicationFrame];
        
        [mechBg addSubview:mechToAdd];
        [mechToAdd release];
        
        [self.view addSubview:mechBg];
        [self.view sendSubviewToBack:mechBg];
        /*
         CALayer *sublayer = [CALayer layer];
         sublayer.frame = [[UIScreen mainScreen] applicationFrame];
         sublayer.contents = (id) mechPic.CGImage;
         [self.layer addSublayer:sublayer];
         */
        // remove the mechanisms observers
        [pageOneDoc   removeObserver:self forKeyPath:@"selected"];
        [pageTwoDoc   removeObserver:self forKeyPath:@"selected"];
        [pageThreeDoc removeObserver:self forKeyPath:@"selected"];
        
        // clear the mechanisms from the scrollView
        for (UIView *view in [scrollView subviews]) { [view removeFromSuperview]; }
        
        [self addFacePlatesToScrollView];
        
    }else{
        // FacePlate Choice
        
        UIImage *faceplatePic = [pageTwoDoc getMechanismImage];
        NSLog(@"PAssed faceplate image %@",faceplatePic);
        
        UIImageView *faceplateToAdd = [[UIImageView alloc] initWithImage:faceplatePic];
        faceplateToAdd.frame = [[UIScreen mainScreen] applicationFrame];
        
        self.selectedFacePlate = [self.currentFacePlates objectAtIndex:self.currIndex];
        /* these guys are retained because they are iVars
         the observation will be ceased when
        [pageOneDoc   removeObserver:self forKeyPath:@"selected"];
        [pageTwoDoc   removeObserver:self forKeyPath:@"selected"];
        [pageThreeDoc removeObserver:self forKeyPath:@"selected"];
        */
        // clear the mechanisms from the scrollView
        for (UIView *view in [scrollView subviews]) { [view removeFromSuperview]; }
        
        [mechBg addSubview:faceplateToAdd];
        [faceplateToAdd release];
        [self showManipulationControls];
    }
}

-(void)showManipulationControls
{
    self.manipulationMethodsShouldReturn = YES;
    /* Set these up for the scrollView defaults
    self.scrollView.minimumZoomScale=0.5;
    self.scrollView.maximumZoomScale=6.0;
    self.scrollView.contentSize=CGSizeMake(1280, 960);
    self.scrollView.delegate=self;
     */
}


#pragma mark - toolBar Functions and delegates

-(void)addToOrder
{
    // Create the root view controller for the navigation controller
    // The new view controller configures a Cancel and Done button for the
    // navigation bar.
    AddItemToOrderView *addController = [[AddItemToOrderView alloc] init];
    addController.context = self.context;
    if(self.selectedFacePlate){
        addController.faceplate = self.selectedFacePlate;
    }
    if(self.selectedMechanism){
        addController.mechanism = self.selectedMechanism;
    }
    
    addController.productToAdd = self.selectedProductName;
    
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
-(void)newOrder
{
    /*
    AddOrderView *addOrder = [[AddOrderView alloc] init];
    addOrder.context = self.context;
    
    // Create the navigation controller and present it modally.
    UINavigationController *navigationController = [[UINavigationController alloc]
                                                    initWithRootViewController:addOrder];
    [self presentModalViewController:navigationController animated:YES];
    
    // The navigation controller is now owned by the current view controller
    // and the root view controller is owned by the navigation controller,
    // so both objects should be released to prevent over-retention.
    [navigationController release];
    [addOrder release];
     */
    
    SmallDisplay *addOrder = [[SmallDisplay alloc]init];
    [self presentModalViewController:addOrder animated:YES];
    [addOrder release];
    
}



#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // the size of the screen
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    
    // hook up the product data
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
    ///////////////////////////////////////////////
    // ToolBar
    toolBar = [[UIToolbar alloc] init];
    toolBar.barStyle = UIBarStyleDefault;
    
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
    CGRect rectArea = CGRectMake(0, rootViewHeight - toolBarHeight - 40, rootViewWidth, toolBarHeight);
    //CGRect rectArea = CGRectMake(0, 400, rootViewWidth, toolBarHeight);
    //Reposition and resize the receiver
    [toolBar setFrame:rectArea];
    
    //Create a button
    UIBarButtonItem *infoButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Add To Order" style:UIBarButtonItemStyleBordered target:self action:@selector(addToOrder)];
    UIBarButtonItem *newOrderButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Create a new order" style:UIBarButtonItemStyleBordered target:self action:@selector(newOrder)];
    
    [toolBar setItems:[NSArray arrayWithObjects:infoButton,newOrderButton, nil]];
    
    //Add the toolbar as a subview to the navigation controller.
    //[self.navigationController.view addSubview:toolbar];
    NSLog(@"     -      -           -       \n\n%@",toolBar);
    
    
    
    
    
    ///////////////////////////////////////////////
    // the scrollHolder is going to hold everything
    //  view = scrollHolder
    //           - wallBg
    //           - mechBg
    //           - scrollView
    
    scrollHolder = [[UIView alloc] initWithFrame:fullScreenRect];
    
    ////////////////////////////////////////////////
    //
    scrollView = [[UIScrollView alloc] initWithFrame:fullScreenRect];
    scrollView.delegate = self;
    self.manipulationMethodsShouldReturn = NO; // this will stop pinching from doing anything to the scrllView
    
    // adjust content size for three pages of data and reposition to center page
	scrollView.contentSize = CGSizeMake(screenWidth * 3, 100);	
	[scrollView scrollRectToVisible:CGRectMake(screenWidth,0,screenWidth,screenHeight) animated:NO];
  //  scrollView.backgroundColor = [UIColor redColor];
    
    // release scrollView as self.view retains it
    [self.scrollHolder addSubview:scrollView];
    [scrollView release];
    self.view = scrollHolder;
    [scrollHolder release];
    
    [self.view addSubview:toolBar];
    
    // setup and load the first set of mechanism views
    self.activeEntity = @"Mechanism";
    [self addMechanismsToScrollView];
    
    
}

-(void)addMechanismsToScrollView
{
    // the size of the screen
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // create three Mechanism Views to cycle and observe their selected property
	pageOneDoc = [[MechanismView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    pageTwoDoc = [[MechanismView alloc] initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight)];
    pageThreeDoc = [[MechanismView alloc] initWithFrame:CGRectMake(screenWidth *2, 0, screenWidth, screenHeight)];

    [pageOneDoc addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
    [pageTwoDoc addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
    [pageThreeDoc addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
    
    // pass the product name through
    pageOneDoc.parentProduct = self.currentCategory;
    pageTwoDoc.parentProduct = self.currentCategory;
    pageThreeDoc.parentProduct = self.currentCategory;
    
    // pass the Brand name through
    pageOneDoc.brandName = self.currentBrand;
    pageTwoDoc.brandName = self.currentBrand;
    pageThreeDoc.brandName = self.currentBrand;
    
    // pass though the orentation
    pageOneDoc.orientationPrefix = [[_fetchedResultsController.fetchedObjects objectAtIndex:
                                     [_fetchedResultsController.fetchedObjects count] -1] 
                                    valueForKey:@"orientation"];
    pageTwoDoc.orientationPrefix = [[_fetchedResultsController.fetchedObjects objectAtIndex:0] 
                                    valueForKey:@"orientation"];
    pageThreeDoc.orientationPrefix = [[_fetchedResultsController.fetchedObjects objectAtIndex:1] 
                                      valueForKey:@"orientation"];

	// load all three pages into our scroll view
	[self loadPageWithId:[_fetchedResultsController.fetchedObjects count] -1 onPage:0 withEntity:self.activeEntity];
	[self loadPageWithId:0 onPage:1 withEntity:self.activeEntity];
	[self loadPageWithId:1 onPage:2 withEntity:self.activeEntity];
	
	[scrollView addSubview:pageOneDoc];
	[scrollView addSubview:pageTwoDoc];
	[scrollView addSubview:pageThreeDoc];
    
    // set the page title
    self.title = [NSString 
                  stringWithFormat:@"%@ %d/%d",
                  self.currentCategory,
                  1,
                  [_fetchedResultsController.fetchedObjects count]];
     
    
}

-(void)addFacePlatesToScrollView
{
    self.activeEntity = @"Faceplate";
    
    //////////////////////////////////////////////////////////
    // Work out how many faceplates there are for this product
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Faceplate"
                                              inManagedObjectContext:_context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(%K == %@)",
                              @"product.name",
                              self.selectedProductName];
    //[[_fetchedResultsController.fetchedObjects objectAtIndex:index] valueForKey:@"name"]];
    [request setPredicate:predicate];
    // NSLog(@" Predicate %@",predicate);
    NSError *error = nil;
    self.currentFacePlates = [NSArray arrayWithArray:[_context executeFetchRequest:request error:&error]];
    
    NSLog(@" \n\n\n Current FAcePlates %d \n %@ \n\n\n======\n",[self.currentFacePlates count],[[self.currentFacePlates objectAtIndex:5] valueForKey:@"name"]);
    ////////////////////////////////////////////////
    // the size of the screen
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    if([self.currentFacePlates count] >= 3){
        // create three Mechanism Views to cycle and observe their selected property
        pageOneDoc = [[FacePlateView alloc] 
                      initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
        pageTwoDoc = [[FacePlateView alloc] 
                      initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight)];
        pageThreeDoc = [[FacePlateView alloc] 
                        initWithFrame:CGRectMake(screenWidth *2, 0, screenWidth, screenHeight)];
        
        [pageOneDoc   addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
        [pageTwoDoc   addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
        [pageThreeDoc addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
        
        // pass the product name through
        pageOneDoc.parentProduct   = self.currentCategory;
        pageTwoDoc.parentProduct   = self.currentCategory;
        pageThreeDoc.parentProduct = self.currentCategory;
        
        // pass the Brand name through
        pageOneDoc.brandName   = self.currentBrand;
        pageTwoDoc.brandName   = self.currentBrand;
        pageThreeDoc.brandName = self.currentBrand;
        
        // pass the orientation
        NSString *productOrientation = [[_fetchedResultsController.fetchedObjects 
                                         objectAtIndex:self.currIndex] 
                                        valueForKey:@"orientation"];
        pageOneDoc.orientationPrefix   = productOrientation;
        pageTwoDoc.orientationPrefix   = productOrientation;
        pageThreeDoc.orientationPrefix = productOrientation;
        
        
        
        ///NSLog(@"Current FAcePlates :- \n%@\n\n",self.currentFacePlates);
        
        // load all three pages into our scroll view
        [self loadPageWithId:[self.currentFacePlates count] -1 onPage:0 withEntity:self.activeEntity];
        [self loadPageWithId:0 onPage:1 withEntity:self.activeEntity];
        [self loadPageWithId:1 onPage:2 withEntity:self.activeEntity];
        
        [scrollView addSubview:pageOneDoc];
        [scrollView addSubview:pageTwoDoc];
        [scrollView addSubview:pageThreeDoc];
    }
    // set the page title
    self.title = [NSString 
                  stringWithFormat:@"%@ %d/%d",
                  self.currentCategory,
                  1,
                  [currentFacePlates count]];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
//    self.view = nil;

    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



#pragma mark - scroll View Delegates




#pragma mark - Loading items in ScrollView

-(NSArray *)getObjToScroll:(int)index forEntityName:(NSString *)name
{
    NSLog(@"Getting |%@| with index:%d",name,index);
    if([name isEqualToString:@"Faceplate"]){
        
       // NSLog(@" \n\n\n NOW __ Current FAcePlates %d \n %@ \n\n\n======\n",[self.currentFacePlates count],[[self.currentFacePlates objectAtIndex:index] valueForKey:@"name"]);
        
        return [NSArray arrayWithObject:[self.currentFacePlates objectAtIndex:index]];
    }
    
    // Get all the mechanisms assosiated with the product
    NSFetchRequest*request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name
                                              inManagedObjectContext:_context];
    [request setEntity:entity];
    
    NSPredicate *predicate= [NSPredicate predicateWithFormat:
                    @"(%K == %@ AND %K == %@) ",
                    @"product.name", [[_fetchedResultsController.fetchedObjects objectAtIndex:index]valueForKey:@"name"],
                    @"product.category.name", self.currentCategory
                     ];
    /*
    NSPredicate *predicate = [NSPredicate 
                              predicateWithFormat:@"(%K == %@ AND %K == %@)",
                              @"category.name",self.currentCategory,
                              @"brand.name",self.currentBrand];
     */
    
    [request setPredicate:predicate];    
    NSError *error = nil;
   
    NSArray *result = [_context executeFetchRequest:request error:&error];
    if (result == nil)
    {
        // Deal with error...
        NSLog(@"Error Returned from the fetchRequest ");
    }

    return result;
}



- (void)loadPageWithId:(int)index onPage:(int)page withEntity:(NSString *)entityName
{
    
    NSArray *productItems = [self getObjToScroll:index forEntityName:entityName];
    
    NSString *product;
    if([self.activeEntity isEqualToString:@"Faceplate"]){
        product = self.selectedProductName;
    }else{
        product = [[_fetchedResultsController.fetchedObjects objectAtIndex:index] valueForKey:@"name"];
    }
    
	switch (page) {
		case 0:
            pageOneDoc.parentProduct = product;
            [pageOneDoc drawWithItems:productItems];
			break;
		case 1:
            pageTwoDoc.parentProduct = product;
			[pageTwoDoc drawWithItems:productItems];
            break;
		case 2:
			//pageThreeDoc.text = [[_fetchedResultsController.fetchedObjects objectAtIndex:index] valueForKey:@"name"];
            //[pageThreeDoc drawWithManagedObject:[_fetchedResultsController.fetchedObjects objectAtIndex:index]];
            pageThreeDoc.parentProduct = product;
            [pageThreeDoc drawWithItems:productItems];
			break;
	}	
    
    // set the page title
    
    if([self.activeEntity isEqualToString:@"Faceplate"]){
        self.title = [NSString 
                      stringWithFormat:@"%@ %d/%d",
                      self.currentCategory,
                      1,
                      [currentFacePlates count]];
    }else{
        self.title = [NSString 
                  stringWithFormat:@"%@ %d/%d",
                  self.currentCategory,
                  index +1,
                  [_fetchedResultsController.fetchedObjects count]];
    }
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {  
    
    int objCount;
    
    if([self.activeEntity isEqualToString:@"Faceplate"]){
        objCount = [self.currentFacePlates count];
    }else{
        objCount = [_fetchedResultsController.fetchedObjects count];
    }
    
	if(scrollView.contentOffset.x > scrollView.frame.size.width) {  
        
		// We are moving forward. Load the current doc data on the first page.         
		[self loadPageWithId:currIndex onPage:0 withEntity:self.activeEntity]; 
        
		// Add one to the currentIndex or reset to 0 if we have reached the end.         
		currIndex = (currIndex >= objCount-1) ? 0 : currIndex + 1;         
		[self loadPageWithId:currIndex onPage:1 withEntity:self.activeEntity];  
        
		// Load content on the last page. This is either from the next item in the array         
		// or the first if we have reached the end.         
		nextIndex = (currIndex >= objCount-1) ? 0 : currIndex + 1;         
		[self loadPageWithId:nextIndex onPage:2 withEntity:self.activeEntity];     
	}     
	if(scrollView.contentOffset.x < scrollView.frame.size.width) { 
        
		// We are moving backward. Load the current doc data on the last page.         
		[self loadPageWithId:currIndex onPage:2 withEntity:self.activeEntity];  
        
		// Subtract one from the currentIndex or go to the end if we have reached the beginning.         
		currIndex = (currIndex == 0) ? objCount -1 : currIndex - 1;         
		[self loadPageWithId:currIndex onPage:1 withEntity:self.activeEntity];  
        
		// Load content on the first page. This is either from the prev item in the array         
		// or the last if we have reached the beginning.         
		prevIndex = (currIndex == 0) ? objCount-1 : currIndex - 1;         
		[self loadPageWithId:prevIndex onPage:0 withEntity:self.activeEntity];     
	}     
	
	// Reset offset back to middle page
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
	[scrollView scrollRectToVisible:CGRectMake(screenWidth,0,screenWidth,screenHeight - 40) animated:NO]; 
}

@end
