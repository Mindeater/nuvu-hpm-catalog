//
//  ProductView.m
//  Catalog2
//
//  Created by Ashley McCoy on 13/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "ProductView.h"
#import "MechanismView.h"

@implementation ProductView

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

// scrollable iVars
@synthesize scrollView;
@synthesize documentTitles;
@synthesize pageOneDoc, pageTwoDoc, pageThreeDoc;
@synthesize prevIndex, currIndex, nextIndex;

@synthesize currentBrand,currentCategory;

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
    
    // hook up the product data
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}
        
    // the size of the screen
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    // add a scrollview
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    scrollView=[[UIScrollView alloc] initWithFrame:fullScreenRect];
    scrollView.delegate = self;
    
    // create three Mechanism Views to cycle and observe their selected property
	pageOneDoc = [[MechanismView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 200)];
    [pageOneDoc addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
	pageTwoDoc = [[MechanismView alloc] initWithFrame:CGRectMake(screenWidth, 0, screenWidth, 200)];
    [pageTwoDoc addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
	pageThreeDoc = [[MechanismView alloc] initWithFrame:CGRectMake(screenWidth *2, 0, screenWidth, 200)];
    [pageThreeDoc addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
    
    // set the starting three items 
    pageOneDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:
                                 [_fetchedResultsController.fetchedObjects count] -1] valueForKey:@"name"];
    pageTwoDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:0] valueForKey:@"name"];
    pageThreeDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:1] valueForKey:@"name"];
    
	// load all three pages into our scroll view
	[self loadPageWithId:[_fetchedResultsController.fetchedObjects count] -1 onPage:0];
	[self loadPageWithId:0 onPage:1];
	[self loadPageWithId:1 onPage:2];
	
	[scrollView addSubview:pageOneDoc];
	[scrollView addSubview:pageTwoDoc];
	[scrollView addSubview:pageThreeDoc];
	
	// adjust content size for three pages of data and reposition to center page
	scrollView.contentSize = CGSizeMake(screenWidth * 3, 100);	
	[scrollView scrollRectToVisible:CGRectMake(screenWidth,0,screenWidth,screenHeight -40) animated:NO];
    
    // release scrollView as self.view retains it
    self.view = scrollView;
    [scrollView release];
    
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


-(NSArray *)getObjToScroll:(int)index
{
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Mechanism"
                                              inManagedObjectContext:_context];
    [request setEntity:entity];
        
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(%K == %@)",
                              @"product.name",
                              [[_fetchedResultsController.fetchedObjects objectAtIndex:index] valueForKey:@"name"]];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *result = [_context executeFetchRequest:request error:&error];
    return result;
}

#pragma mark - Scrollable

- (void)loadPageWithId:(int)index onPage:(int)page {
    NSArray *productMechanisms = [self getObjToScroll:index];
	switch (page) {
		case 0:
            pageOneDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:index] valueForKey:@"name"];
            [pageOneDoc drawWithMechanisms:productMechanisms];
			break;
		case 1:
            pageTwoDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:index] valueForKey:@"name"];
			[pageTwoDoc drawWithMechanisms:productMechanisms];
            break;
		case 2:
			//pageThreeDoc.text = [[_fetchedResultsController.fetchedObjects objectAtIndex:index] valueForKey:@"name"];
            //[pageThreeDoc drawWithManagedObject:[_fetchedResultsController.fetchedObjects objectAtIndex:index]];
            pageThreeDoc.parentProduct = [[_fetchedResultsController.fetchedObjects objectAtIndex:index] valueForKey:@"name"];
            [pageThreeDoc drawWithMechanisms:productMechanisms];
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
		[self loadPageWithId:currIndex onPage:0]; 
        
		// Add one to the currentIndex or reset to 0 if we have reached the end.         
		currIndex = (currIndex >= objCount-1) ? 0 : currIndex + 1;         
		[self loadPageWithId:currIndex onPage:1];  
        
		// Load content on the last page. This is either from the next item in the array         
		// or the first if we have reached the end.         
		nextIndex = (currIndex >= objCount-1) ? 0 : currIndex + 1;         
		[self loadPageWithId:nextIndex onPage:2];     
	}     
	if(scrollView.contentOffset.x < scrollView.frame.size.width) { 
        
		// We are moving backward. Load the current doc data on the last page.         
		[self loadPageWithId:currIndex onPage:2];  
        
		// Subtract one from the currentIndex or go to the end if we have reached the beginning.         
		currIndex = (currIndex == 0) ? objCount -1 : currIndex - 1;         
		[self loadPageWithId:currIndex onPage:1];  
        
		// Load content on the first page. This is either from the prev item in the array         
		// or the last if we have reached the beginning.         
		prevIndex = (currIndex == 0) ? objCount-1 : currIndex - 1;         
		[self loadPageWithId:prevIndex onPage:0];     
	}     
	
	// Reset offset back to middle page
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
	[scrollView scrollRectToVisible:CGRectMake(screenWidth,0,screenWidth,screenHeight - 40) animated:NO]; 
}

@end
