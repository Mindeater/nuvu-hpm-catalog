//
//  ProductChooserView.m
//  Catalog2
//
//  Created by Ashley McCoy on 2/12/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "ProductChooserView.h"

#import "MechanismView.h"
#import "FacePlateView.h"

#import "ProductBackgroundResize.h"
#import "AddPartToOrder.h"
#import "AlertPrompt.h"

#import "OrdersTableView.h"
#import "OrderDetailTableView.h"

@implementation ProductChooserView

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize context = _context;

@synthesize currentBrand,currentCategory,currentEntityName;

@synthesize vc1,vc2,vc3;
@synthesize currIndex,prevIndex,nextIndex;
@synthesize selectedProductIndex;
@synthesize vcIndex;


@synthesize selectedProductName;
@synthesize currentFacePlates;
@synthesize selectedMechanismImage;
@synthesize mechanismObject;

@synthesize shoppingCart;

@synthesize wallImage;

-(void)dealloc
{
    self.fetchedResultsController.delegate = nil;
    self.fetchedResultsController = nil;
    self.context = nil;
    
    [vc1 release];
    [vc2 release];
    [vc3 release];
    //[self.selectedProductName release];
    //[self.currentFacePlates release];
    //[self.shoppingCart release];
    [super dealloc];
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
                              initWithKey:@"menuOrder" ascending:YES];
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

-(void)addActivePartToCart
{
    // add the alert view now
    AlertPrompt *prompt = [AlertPrompt alloc];
	prompt = [prompt initWithTitle:@"Add Comment" message:@"Please enter a note" delegate:self cancelButtonTitle:@"Cancel" okButtonTitle:@"OK"];
	[prompt show];
	[prompt release];
    /*
    // this will have already been set when the mechanism was selected
    if(self.selectedProductName == nil){
        self.selectedProductName = [[_fetchedResultsController.fetchedObjects objectAtIndex:currIndex] valueForKey:@"name"];
    }
    // Not adding Mechanisms on their own - defaults to faceplate with mechanims
    if([self.currentEntityName isEqualToString:@"Mechanism"]){
        [self.shoppingCart addMechanismsToDefaultOrder:[self getObjToScroll:currIndex forEntityName:@"Mechanism"]
                                       withProductName:self.selectedProductName];
    }else{
        [self.shoppingCart addMechanismsToDefaultOrder:self.mechanismObject
                                       withProductName:self.selectedProductName];
        [self.shoppingCart addFaceplateToDefaultOrder:[self getObjToScroll:currIndex forEntityName:@"Faceplate"]
                                    withProductName:self.selectedProductName];
    }
     */
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	if (buttonIndex != [alertView cancelButtonIndex])
	{
		NSString *entered = [(AlertPrompt *)alertView enteredText];
		//label.text = [NSString stringWithFormat:@"You typed: %@", entered];
        [self.shoppingCart addMechanismsToDefaultOrder:self.mechanismObject
                                       withProductName:self.selectedProductName];
        [self.shoppingCart addCommentToActiveOrderLine:entered];
        
        if([self.currentFacePlates count] >= 1){
          [self.shoppingCart addFaceplateToDefaultOrder:[self getObjToScroll:currIndex forEntityName:@"Faceplate"] withProductName:self.selectedProductName];  
        }
        
        PartView *active = (PartView *)self.navigationController.topViewController;
        [active updateSelectedStatus];
	}
}

#pragma mark - object init

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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
 self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]autorelease];
}
*/
-(void)viewWillAppear:(BOOL)animated
{
    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
   [super viewDidLoad];
    
    
    //NSLog(@"\n^Chooser 1.^^^^^^\n Nav Controller :%@ \nNav Bar : %@^^^^^^^^^^\n\n",
      //    self.navigationItem, self.navigationController.navigationBar);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    /////////////////////////////
    // hook up the product data
    NSError *error;
	if (![[self fetchedResultsController] performFetch:&error]) {
		// Update to handle the error appropriately.
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		exit(-1);  // Fail
	}

    self.currentEntityName = @"Mechanism";
    
    // set up the current Index
    prevIndex = [_fetchedResultsController.fetchedObjects count]-1;
    currIndex = 0;
    nextIndex = 1;
    

    /*
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    */
    vc1 = [[MechanismView alloc]init];
    vc2 = [[MechanismView alloc]init];
    vc3 = [[MechanismView alloc]init];
    

    
    vc1.productName = [[_fetchedResultsController.fetchedObjects 
                        objectAtIndex:prevIndex] 
                       valueForKey:@"name"];
    vc2.productName = [[_fetchedResultsController.fetchedObjects 
                        objectAtIndex:currIndex] 
                       valueForKey:@"name"];
    vc3.productName = [[_fetchedResultsController.fetchedObjects 
                        objectAtIndex:nextIndex] 
                       valueForKey:@"name"];
    
    
    
    ////////////////////////////////////////////
    // Set up the nav controller
    
    /* manually setting
    NSMutableArray *baseViewStack = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    [baseViewStack addObjectsFromArray:[NSArray arrayWithObjects:vc1,vc2, nil]];
    NSArray *newStack = (NSArray *)baseViewStack;
    
    [self.navigationController setViewControllers:newStack animated:NO];
    */
    // vs pushing
    [self.navigationController pushViewController:vc1 animated:NO];
    [self.navigationController pushViewController:vc2 animated:YES];
    

    [self setMechanismsOnViewControllers];
    

    vcIndex = 2;
    
    //NSLog(@"\n^^^Chooser 2.^^^^\n Nav Controller :%@ \nNav Bar : %@^^^^^^^^^^\n\n",
     //     self.navigationController, self.navigationController.navigationBar);
    
    //[self.navigationController.navigationBar popNavigationItemAnimated:YES];
    
    //////////////////////////////
    // Shopping cart Instance
    self.shoppingCart = [[[AddPartToOrder alloc]init] autorelease];
    self.shoppingCart.context = self.context;
    
}


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

#pragma mark - setting data for view controllers

-(NSArray *)getObjToScroll:(int)index forEntityName:(NSString *)name
{
    //NSLog(@"Getting |%@| with index:%d",name,index);
    if([name isEqualToString:@"Faceplate"]){
        
        // NSLog(@" \n\n\n NOW __ Current FAcePlates %d \n %@ \n\n\n======\n",[self.currentFacePlates count],[[self.currentFacePlates objectAtIndex:index] valueForKey:@"name"]);
        
        return [NSArray arrayWithObjects:self.selectedMechanismImage,[self.currentFacePlates objectAtIndex:index],nil];
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

-(void)setViewControllerCommonProperties
{
    vc1._parent = self;
    vc2._parent = self;
    vc3._parent = self;
    
    vc1.wallImage = self.wallImage;
    vc2.wallImage = self.wallImage;
    vc3.wallImage = self.wallImage;
    
    // pass the product name through
    vc1.categoryName = self.currentCategory;
    vc2.categoryName = self.currentCategory;
    vc3.categoryName = self.currentCategory;
    
    // pass the Brand name through
    vc1.brandName = self.currentBrand;
    vc2.brandName = self.currentBrand;
    vc3.brandName = self.currentBrand;
    
    // pass the orientation
    NSString *productOrientation = [[_fetchedResultsController.fetchedObjects 
                                     objectAtIndex:self.currIndex] 
                                    valueForKey:@"orientation"];
   // NSLog(@"\n\n\nSetting Orientation Prefix :%@\n for\n%@\n%@",productOrientation,self.currentBrand,self.currentCategory);
    
    vc1.orientationPrefix = productOrientation;
    vc2.orientationPrefix = productOrientation;
    vc3.orientationPrefix = productOrientation;
    
  
}
-(void)setMechanismsOnViewControllers
{
    [self setViewControllerCommonProperties];
    
    int totalMechanisms = [_fetchedResultsController.fetchedObjects count];
    vc1.countTotal = totalMechanisms;
    vc2.countTotal = totalMechanisms;
    vc3.countTotal = totalMechanisms;
    
    [vc1 drawWithItems:[self getObjToScroll:prevIndex forEntityName:@"Mechanism"]];
    [vc2 drawWithItems:[self getObjToScroll:currIndex forEntityName:@"Mechanism"]];
    [vc3 drawWithItems:[self getObjToScroll:nextIndex forEntityName:@"Mechanism"]];
    
    [vc1 addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
    [vc2 addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
    [vc3 addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL]; 
}

-(void)setFacePlatesOnViewControllers
{
    vc1 = [[FacePlateView alloc]init];
    vc2 = [[FacePlateView alloc]init];
    vc3 = [[FacePlateView alloc]init];
    
    int totalFacePlates = [self.currentFacePlates count];
    vc1.countTotal = totalFacePlates;
    vc2.countTotal = totalFacePlates;
    vc3.countTotal = totalFacePlates;
    
    [self setViewControllerCommonProperties];
    
    if(totalFacePlates == 0 ){
        // 4 gang horizontal has no faceplate
        //NSLog(@"\n\nNO FACEPLATE !!\n\n");
        // this will never happen because the data has been manipulated to put in an empty faceplate
        vc1.productName = @"";
        [vc1 drawWithItems:[NSArray arrayWithObjects:self.selectedMechanismImage,nil]];
        [vc1 addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
        [vc1.view sendSubviewToBack:vc1.toolBar];
        
        // reset the view controller stack
        NSMutableArray *baseViewStack = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
        [baseViewStack removeObjectAtIndex:[baseViewStack count]-1 ];
        [baseViewStack removeObjectAtIndex:[baseViewStack count]-1 ];
        
        [self.navigationController pushViewController:vc1 animated:YES];
        
    }else if(totalFacePlates == 1){
        
        // Excel Life has single faceplates
        vc1.productName = [[self.currentFacePlates lastObject] valueForKey:@"name"];
        [vc1 drawWithItems:[self getObjToScroll:0 forEntityName:@"Faceplate"]];
        [vc1 addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
        [vc1.view sendSubviewToBack:vc1.toolBar];
        
        // reset the view controller stack
        NSMutableArray *baseViewStack = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
        [baseViewStack removeObjectAtIndex:[baseViewStack count]-1 ];
        [baseViewStack removeObjectAtIndex:[baseViewStack count]-1 ];
        //vc1.productName = [[self.currentFacePlates objectAtIndex:currIndex] valueForKey:@"name"];
        
        [self.navigationController pushViewController:vc1 animated:YES];
        
        
    }else if(totalFacePlates >1 ){
        
        vc1.productName = [[self.currentFacePlates objectAtIndex:prevIndex] valueForKey:@"name"];
        vc2.productName = [[self.currentFacePlates objectAtIndex:currIndex] valueForKey:@"name"];
        vc3.productName = [[self.currentFacePlates objectAtIndex:nextIndex] valueForKey:@"name"];
        
        [vc1 drawWithItems:[self getObjToScroll:prevIndex forEntityName:@"Faceplate"]];
        [vc2 drawWithItems:[self getObjToScroll:currIndex forEntityName:@"Faceplate"]];
        [vc3 drawWithItems:[self getObjToScroll:nextIndex forEntityName:@"Faceplate"]];
        
        [vc1 addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
        [vc2 addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
        [vc3 addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL]; 
        
        [self resetViewControllers];
    }
}

-(void)getFaceplatesForCurrentMechanism
{
    //////////////////////////////////////////////////////////
    // Work out how many faceplates there are for this product
    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Faceplate"
                                              inManagedObjectContext:_context];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(%K == %@) && (%K == %@)",
                              @"product.name",
                              self.selectedProductName,
                              @"product.category.name",
                              self.currentCategory];
    //[[_fetchedResultsController.fetchedObjects objectAtIndex:index] valueForKey:@"name"]];
    [request setPredicate:predicate];
    // NSLog(@" Predicate %@",predicate);
    NSError *error = nil;
    self.currentFacePlates = [NSArray arrayWithArray:[_context executeFetchRequest:request error:&error]];
    
    //NSLog(@"Getting Current Faceplates");
    //@TODO: There may be only one of these faceplates returned
}

#pragma mark - selection handling

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
        
    if([self.currentEntityName isEqualToString:@"Mechanism"]){
        
        // this can also be set when a mechanism is added to the cart
        self.selectedProductName = [[_fetchedResultsController.fetchedObjects objectAtIndex:currIndex] valueForKey:@"name"];
        self.mechanismObject = [self getObjToScroll:currIndex forEntityName:@"Mechanism"];
        
        // get the faceplates
        [self getFaceplatesForCurrentMechanism];
        
        // keep the mechanism counter
        self.selectedProductIndex = currIndex;
        
        //reset the indexes
        self.currentEntityName = @"Faceplate";
        prevIndex = [self.currentFacePlates count]-1;
        currIndex = 0;
        nextIndex = 1;
        
        vcIndex = 2;
        
        // remove the mechanisms observers
        [vc1 removeObserver:self forKeyPath:@"selected"];
        [vc2 removeObserver:self forKeyPath:@"selected"];
        [vc3 removeObserver:self forKeyPath:@"selected"];
        
        [vc1 release];
        [vc2 release];
        [vc3 release];
        
        self.selectedMechanismImage = [object getMechanismImage];
        [self setFacePlatesOnViewControllers];
        
    }else{
        // FacePlate button hit
        ProductBackgroundResize *resizeSheet = [[ProductBackgroundResize alloc]init];
        
        resizeSheet.resizingImage = [object getMechanismImage];
        resizeSheet.backgroundImage = self.wallImage;
        
        //[self.navigationController pushViewController:resizeSheet animated:NO];
        // Create the navigation controller and present it modally.
        UINavigationController *navigationController = [[UINavigationController alloc]
                                                        initWithRootViewController:resizeSheet];
        navigationController.navigationBar.tintColor = [UIColor blackColor];
        [self presentModalViewController:navigationController animated:YES];
        
        // The navigation controller is now owned by the current view controller
        // and the root view controller is owned by the navigation controller,
        // so both objects should be released to prevent over-retention.
        [navigationController release];
        [resizeSheet release];
        
    }
}

-(void)returnToMainMenu
{
    // remove the top two items from the viewcontroller and get the base of the stack
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];  
}

-(void)returnToCatalogMenu
{
    // remove the top two items from the viewcontroller and get the base of the stack
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];  
}

-(void)returnToMechanism
{
    //@TODO : this resets the counter - needs to return to the actual base mechanism
    self.currentEntityName = @"Mechanism";
    
    // remove the observers
    [vc1 removeObserver:self forKeyPath:@"selected"];
    // make sure we don't try to remove observers that have not been established
    if([self.currentFacePlates count] > 1){
        [vc2 removeObserver:self forKeyPath:@"selected"];
        [vc3 removeObserver:self forKeyPath:@"selected"];  
    }
    
    
    
    // reinitalize the mechanisms
    self.currentEntityName = @"Mechanism";
    
    // set up the current Indexs
    prevIndex = (selectedProductIndex == 0) ? [self.fetchedResultsController.fetchedObjects count] -1 : selectedProductIndex - 1;
    currIndex = selectedProductIndex;
    nextIndex = (selectedProductIndex >= [self.fetchedResultsController.fetchedObjects count]-1) ? 0 : selectedProductIndex + 1;
    
    vc1 = [[MechanismView alloc]init];
    vc2 = [[MechanismView alloc]init];
    vc3 = [[MechanismView alloc]init];
    
    vcIndex = 2;
    
    [self setMechanismsOnViewControllers];
    
    [self resetViewControllers];
    
}

-(void)gotoCartPassBackString:(NSString *)backString
{
    OrderDetailTableView *cart = [[OrderDetailTableView alloc] init];
    //OrderDetailTableView *detailViewController = [[OrderDetailTableView alloc] initWithStyle:UITableViewStyleGrouped];
    cart.context = self.context;
    //NSManagedObject *currentRecord = [_fetchedResultsController objectAtIndexPath:indexPath];
    cart.orderId = [self.shoppingCart getActiveOrderId];//[currentRecord valueForKey:@"uniqueId"];
    cart.backString = backString;
    

    [self.navigationController pushViewController:cart animated:YES];
    [cart release];
}

-(void)showOrders
{
    OrdersTableView *orders = [[OrdersTableView alloc] initWithStyle:UITableViewStyleGrouped];
    orders.context = self.context;
    [self.navigationController pushViewController:orders animated:YES];
    [orders release];
}

-(void)addNewOrder
{
    [self.shoppingCart addNewOrder];
}


#pragma mark - manage cycling view controllers

-(void)resetViewControllers
{
    
    //NSLog(@"ResetViewControllers currIndex is: %d",currIndex);
    // calculate next and previous based on current
    //nextIndex = (currIndex >= [self.dataModel count]-1) ? 0 : currIndex + 1;
    //prevIndex = (currIndex <= 0) ? [self.dataModel count]-1 : currIndex - 1;
    
    // remove the top two items from the viewcontroller to get the base of the stack
    //[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:NO];
    NSMutableArray *baseViewStack = [NSMutableArray arrayWithArray: self.navigationController.viewControllers];
    [baseViewStack removeObjectAtIndex:[baseViewStack count]-1 ];
    [baseViewStack removeObjectAtIndex:[baseViewStack count]-1 ];
    
    ///////////////////////////////////////////////
    // get the current product name to pass through
    NSString *productName;
    if([self.currentEntityName isEqualToString:@"Mechanism"]){
        productName = [[_fetchedResultsController.fetchedObjects 
                        objectAtIndex:currIndex] 
                       valueForKey:@"name"];
    }else{
        productName = [[self.currentFacePlates objectAtIndex:currIndex] valueForKey:@"name"];
    }
    
    
    switch (vcIndex) {
        case 0:
            [baseViewStack addObjectsFromArray:[NSArray arrayWithObjects:vc2,vc3, nil]];
            vc3.productName = productName;
            vc3.countNum = currIndex+1;
            [vc3 drawWithItems:[self getObjToScroll:currIndex forEntityName:self.currentEntityName]];            
            break;
        case 1:
            [baseViewStack addObjectsFromArray:[NSArray arrayWithObjects:vc3,vc1, nil]];
            vc1.productName = productName;
            vc1.countNum = currIndex+1;
            [vc1 drawWithItems:[self getObjToScroll:currIndex forEntityName:self.currentEntityName]];            
            break;
        case 2:
            [baseViewStack addObjectsFromArray:[NSArray arrayWithObjects:vc1,vc2, nil]];
            vc2.productName = productName;
            vc2.countNum = currIndex+1;
            [vc2 drawWithItems:[self getObjToScroll:currIndex forEntityName:self.currentEntityName]];
            break;
        default:
            break;
    }
    
    NSArray *newStack = (NSArray *)baseViewStack;
    //NSLog(@"\n\n%@\n\n",newStack);    
    [self.navigationController setViewControllers:newStack animated:YES];
    
}

-(void)nextItem:(id)sender
{
    vcIndex = (vcIndex >= 2) ? vcIndex = 0 : vcIndex + 1;
    
    // shift the data counters
    if([self.currentEntityName isEqualToString:@"Mechanism"]){
        currIndex = (currIndex >= [self.fetchedResultsController.fetchedObjects count]-1) ? 0 : currIndex + 1; 
    }else{
        currIndex = (currIndex >= [self.currentFacePlates count]-1) ? 0 : currIndex + 1;
    }
    
    [self resetViewControllers];
    //self.nav.topViewController.title = [NSString stringWithFormat:@": %d :",vcIndex];    
}

-(void)prevItem:(id)sender
{
    vcIndex = (vcIndex <= 0) ? vcIndex = 2 : vcIndex - 1;
    
    // Subtract one from the currentIndex or go to the end if we have reached the beginning.
    if([self.currentEntityName isEqualToString:@"Mechanism"]){
        currIndex = (currIndex == 0) ? [self.fetchedResultsController.fetchedObjects count] -1 : currIndex - 1;
    }else{
        currIndex = (currIndex == 0) ? [self.currentFacePlates count] -1 : currIndex - 1;
    }
    [self resetViewControllers];
    //self.nav.topViewController.title = [NSString stringWithFormat:@": %d :",vcIndex];
}

@end
