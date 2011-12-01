//
//  RootView.m
//  Catalog2
//
//  Created by Ashley McCoy on 12/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "RootView.h"
//#import "BrandTableView.h"
#import "BrandCatalogTableView.h"

#import "SettingsPage.h"
#import "BackgroundLibrary.h"
#import "SearchPage.h"
#import "OrdersTableView.h"

@implementation RootView

@synthesize context;
@synthesize button1,button2,button3,button4,button5,button6;
@synthesize popOver;

-(void)dealloc
{
    self.context = nil;
    self.view = nil;
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    NSLog(@"Root - Load view");
    // create the main view Controller
    //allocate the view
    self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]autorelease];
    self.view.backgroundColor = [UIColor blackColor];
    //self.wantsFullScreenLayout = YES;
    

    // main Navigation Options
    // 1. show catalog
    button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"Catalog" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(showCatalog) forControlEvents:UIControlEventTouchUpInside];

    // 2. Choose Background (from supplied)
    button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"Choose BG" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(chooseBackgroundFromLibrary) forControlEvents:UIControlEventTouchUpInside];
    
    // 3. Create Background (camera or library)
    button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setTitle:@"Create BG" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    
    // 4. show Orders
    button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button4 setTitle:@"Orders" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(showOrders) forControlEvents:UIControlEventTouchUpInside];
    
    // 5. show Settings
    button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button5 setTitle:@"Settings" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    
    // 6. show Search
    button6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button6 setTitle:@"Search" forState:UIControlStateNormal];
    [button6 addTarget:self action:@selector(searchPage) forControlEvents:UIControlEventTouchUpInside];
    
    //[[UIApplication sharedApplication] statusBarOrientation];
    [self layoutButtons: [[UIApplication sharedApplication] statusBarOrientation]];
    
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [self.view addSubview:button3];
    [self.view addSubview:button4];
    [self.view addSubview:button5];
    [self.view addSubview:button6];
   
}

-(void)layoutButtons:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        screenWidth = screenRect.size.height;
        screenHeight = screenRect.size.width;
    }


    
    float buttonWidth = 100;
    float buttonHeight = 100;
    float pad = 20;
    float startX = (screenWidth - (3 * buttonWidth + pad * 2))/2;
    float startY = (screenHeight -(2 * buttonHeight+pad))/2;
    
    button1.frame =  CGRectMake(startX, startY,
                                buttonWidth, buttonHeight);
    button2.frame =  CGRectMake(startX + buttonWidth+pad, startY,
                                buttonWidth, buttonHeight);
    button3.frame =  CGRectMake((startX + (buttonWidth * 2.0))+2*pad, startY,
                                buttonWidth, buttonHeight);
    button4.frame =  CGRectMake(startX, startY + buttonHeight+pad,
                                buttonWidth, buttonHeight);
    button5.frame =  CGRectMake(startX + buttonWidth +pad, startY + buttonHeight+pad,
                                buttonWidth, buttonHeight);
    button6.frame =  CGRectMake(startX + buttonHeight*2+2*pad, startY + buttonHeight+pad,
                                buttonWidth, buttonHeight);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutButtons:toInterfaceOrientation];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.button1 = nil;
    self.button2 = nil;
    self.button3 = nil;
    self.button4 = nil;
    self.button5 = nil;
    self.button6 = nil;
}

#pragma mark - Button call Backs
-(void)showCatalog
{
    //BrandTableView *brand = [[BrandTableView alloc]initWithNibName:nil bundle:nil];
    //BrandTableView *brand = [[BrandTableView alloc] initWithStyle:UITableViewStyleGrouped];
    BrandCatalogTableView *brand = [[BrandCatalogTableView alloc] initWithStyle:UITableViewStyleGrouped];
    brand.context = self.context;
    [self.navigationController pushViewController:brand animated:YES];
    [brand release];
}

-(void)showOrders
{
    OrdersTableView *orders = [[OrdersTableView alloc]init];
    orders.context = self.context;
    [self.navigationController pushViewController:orders animated:YES];
    [orders release];
}
-(void)showSettings
{
    SettingsPage *settings = [[SettingsPage alloc]init];
    [self.navigationController pushViewController:settings animated:YES];
    [settings release];
}

-(void)chooseBackgroundFromLibrary
{
    BackgroundLibrary *bgLibrary = [[BackgroundLibrary alloc]init];
    [self.navigationController pushViewController:bgLibrary animated:YES];
    [bgLibrary release];
}

-(void)searchPage
{
    SearchPage *search = [[SearchPage alloc]init];
    search.context = self.context;
    [self.navigationController pushViewController:search animated:YES];
    [search release];
}

-(void)showAlert:(id)sender 
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"HPM Catalog" message: @"This feature. \n\nNot Yet Available" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
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




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES; //(interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark
#pragma - Image Picking
#pragma mark - TAke a picture

-(void)takePicture:(id)sender;
{
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.showsCameraControls = YES;
        imagePicker.wantsFullScreenLayout = YES;
        /*
         CGAffineTransform cameraTransform = CGAffineTransformMakeScale(1.132, 1.132);
         imagePicker.cameraViewTransform = cameraTransform;
         
         UIView *headsUpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 480, 320)];
         
         [imagePicker setCameraOverlayView:headsUpView];
         */
    } else {
        NSLog(@"Camera not available.");
        //return;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary; 
        //UIImagePickerControllerSourceTypeSavedPhotosAlbum;  
    }
    
    // iPad vs iPhone
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        UIPopoverController  *aPopover = [[UIPopoverController alloc]
                                          initWithContentViewController:imagePicker];
        aPopover.delegate = self;
        
        self.popOver = aPopover;
        UIButton *b = (UIButton *)sender;
        
        CGRect buttonRect = [b.superview convertRect:b.frame toView:self.view];
        
        [aPopover presentPopoverFromRect:buttonRect inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    }else{
    
        [self presentModalViewController:imagePicker animated:YES];
        //[self.navigationController pushViewController:imagePicker animated:YES];
        //[imagePicker release];
    }
    
   
    
}

#pragma mark - UIImagePickerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    NSLog(@"sent %@",info);
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];    
    NSLog(@"Choosen an Image %@",image);
    
    if (self.popOver != nil) {
        [self.popOver dismissPopoverAnimated:YES];
    } 
    
    /*
    ImageManipulator *imgManip = [[ImageManipulator alloc]init];
    imgManip.title = @"Go WIld";
    imgManip.bgImg = image;
    
    [self.navigationController pushViewController:imgManip animated:YES];
    [imgManip release];
    */
    [picker release];
    
}

@end
