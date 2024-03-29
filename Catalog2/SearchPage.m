//
//  SearchPage.m
//  Catalog2
//
//  Created by Ashley McCoy on 19/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "SearchPage.h"
#import "SearchResultTableView.h"

@implementation SearchPage

@synthesize searchBar;
@synthesize resultTable;
@synthesize searchController;

@synthesize context;

-(void)dealloc
{
    self.searchBar = nil;
    self.resultTable = nil;
    self.searchController = nil;
    //self.view = nil;
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

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]autorelease];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    self.title = @"Search Catalogue";
    
    if ( [self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;
    }

    ///////////////////////////////
    // create a search bar
    searchBar = [[UISearchBar alloc] init];
    //[searchBar setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    searchBar.frame = CGRectMake(0, 0, self.view.frame.size.width, 0);
    [searchBar sizeToFit];
    searchBar.tintColor = [UIColor blackColor];
    searchBar.showsScopeBar = YES;
    searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"Products",@"Mechanisms",@"Coverplates", nil];
    
    [self.view addSubview:searchBar];
    
    
    
    ////////////////////////////////////////////////////
    // create a tableView Controller to show the results
    resultTable = [[SearchResultTableView alloc] init];
    resultTable.context = self.context;
    resultTable.LINK = self;
    [resultTable viewWillAppear:NO];
    
    searchBar.delegate = resultTable;
    
    ////////////////////////////////////////
    // create the UISearchDisplay controller
    
    searchController = [[UISearchDisplayController alloc]
                        initWithSearchBar:searchBar contentsController:self];
    searchController.delegate = resultTable;
    searchController.searchResultsDataSource = resultTable;
    searchController.searchResultsDelegate = resultTable;
    
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//}


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
