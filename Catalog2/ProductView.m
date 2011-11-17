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
#import <QuartzCore/QuartzCore.h>

@implementation ProductView

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

// scrollable iVars
@synthesize scrollView;
@synthesize documentTitles;
@synthesize pageOneDoc, pageTwoDoc, pageThreeDoc;
@synthesize prevIndex, currIndex, nextIndex;

@synthesize currentBrand,currentCategory,activeEntity;

@synthesize wallBg,mechBg,scrollHolder;

-(void)dealloc
{
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    [pageOneDoc removeObserver:self forKeyPath:@"selected"];
	[pageOneDoc release];
    [pageTwoDoc removeObserver:self forKeyPath:@"selected"];
	[pageTwoDoc release];
    [pageThreeDoc removeObserver:self forKeyPath:@"selected"];
	[pageThreeDoc release];
    [wallBg release];
    mechBg = nil;
    scrollHolder = nil;
    [scrollView release];
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
    
    // adjust content size for three pages of data and reposition to center page
	scrollView.contentSize = CGSizeMake(screenWidth * 3, 100);	
	[scrollView scrollRectToVisible:CGRectMake(screenWidth,0,screenWidth,screenHeight -40) animated:NO];
    //scrollView.backgroundColor = [UIColor redColor];
    
    // release scrollView as self.view retains it
    [self.scrollHolder addSubview:scrollView];
    [scrollView release];
    self.view = scrollHolder;
    [scrollHolder release];
    
    
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
    
    // set the starting three items 
    pageOneDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:
                                 [_fetchedResultsController.fetchedObjects count] -1] valueForKey:@"name"];
    pageTwoDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:0] valueForKey:@"name"];
    pageThreeDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:1] valueForKey:@"name"];
    
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
    
    
    //NSLog(@"\n\n\nAdding Faceplates \n\n\n %@",[self.view subviews]);
    //for (UIView *view in [self.view subviews]) { [view removeFromSuperview]; }
    //for (UIView *view in [scrollView subviews]) { [view removeFromSuperview]; }
    NSLog(@"1.- - - stripped subviews from scrollView");
    
    // the size of the screen
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    
    // create three Mechanism Views to cycle and observe their selected property
	pageOneDoc = [[FacePlateView alloc] 
                  initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight)];
    pageTwoDoc = [[FacePlateView alloc] 
                  initWithFrame:CGRectMake(screenWidth, 0, screenWidth, screenHeight)];
    pageThreeDoc = [[FacePlateView alloc] 
                    initWithFrame:CGRectMake(screenWidth *2, 0, screenWidth, screenHeight)];
    
    NSLog(@"4.Created FAcePlates for pages");
    [pageOneDoc addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
    [pageTwoDoc addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
    [pageThreeDoc addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
    
    NSLog(@"5.Set up observing");
    // set the starting three items 
    pageOneDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:
                                 [_fetchedResultsController.fetchedObjects count] -1] valueForKey:@"name"];
    pageTwoDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:0] valueForKey:@"name"];
    pageThreeDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:1] valueForKey:@"name"];
    
    NSLog(@"6.Set parent product");
	// load all three pages into our scroll view
	[self loadPageWithId:[_fetchedResultsController.fetchedObjects count] -1 onPage:0 withEntity:self.activeEntity];
	[self loadPageWithId:0 onPage:1 withEntity:self.activeEntity];
	[self loadPageWithId:1 onPage:2 withEntity:self.activeEntity];
	
    NSLog(@"7.Set the specific faceplate for each page");
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

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"Choosen the Product %@",
          [[_fetchedResultsController.fetchedObjects objectAtIndex:self.currIndex] valueForKey:@"name"]);
   
    if([self.activeEntity isEqualToString:@"Mechanism"]){
        
        UIImage *mechPic = [pageTwoDoc getMechanismImage];
        NSLog(@" \n\n\n\nPicture Passed %@\n\n\n\n",mechPic);
        mechBg = [[UIView alloc]initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        //mechBg.backgroundColor = [UIColor yellowColor];
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
        [pageOneDoc removeObserver:self forKeyPath:@"selected"];
        [pageTwoDoc removeObserver:self forKeyPath:@"selected"];
        [pageThreeDoc removeObserver:self forKeyPath:@"selected"];
        for (UIView *view in [scrollView subviews]) { [view removeFromSuperview]; }
        [self addFacePlatesToScrollView];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.view = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Loading items in ScrollView

-(NSArray *)getObjToScroll:(int)index forEntityName:(NSString *)name
{
    NSLog(@"Getting %@ with index:%d",name,index);
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:name
                                              inManagedObjectContext:_context];
    [request setEntity:entity];
        
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(%K == %@)",
                              @"product.name",
                              [[_fetchedResultsController.fetchedObjects objectAtIndex:index] valueForKey:@"name"]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [_context executeFetchRequest:request error:&error];
    if([name isEqualToString:@"Faceplate"]){
        NSLog(@"resultSet \n\n\n%@\n\n\n",result);
        return [result objectAtIndex:index];
    }
    return result;
}



- (void)loadPageWithId:(int)index onPage:(int)page withEntity:(NSString *)entityName
{
    
    NSArray *productItems = [self getObjToScroll:index forEntityName:entityName];
    
	switch (page) {
		case 0:
            pageOneDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:index] valueForKey:@"name"];
            [pageOneDoc drawWithItems:productItems];
			break;
		case 1:
            pageTwoDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:index] valueForKey:@"name"];
			[pageTwoDoc drawWithItems:productItems];
            break;
		case 2:
			//pageThreeDoc.text = [[_fetchedResultsController.fetchedObjects objectAtIndex:index] valueForKey:@"name"];
            //[pageThreeDoc drawWithManagedObject:[_fetchedResultsController.fetchedObjects objectAtIndex:index]];
            pageThreeDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:index] valueForKey:@"name"];
            [pageThreeDoc drawWithItems:productItems];
			break;
	}	
    
    // set the page title
    self.title = [NSString 
                  stringWithFormat:@"%@ %d/%d",
                  self.currentCategory,
                  index +1,
                  [_fetchedResultsController.fetchedObjects count]];
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {     
  
    int objCount = [_fetchedResultsController.fetchedObjects count];
    
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
