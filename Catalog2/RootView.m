//
//  RootView.m
//  Catalog2
//
//  Created by Ashley McCoy on 12/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "RootView.h"
#import <MediaPlayer/MediaPlayer.h>
//#import "BrandTableView.h"
#import "BrandCatalogTableView.h"

#import "AppSettingsTableView.h"
#import "BackgroundLibrary.h"
#import "SearchPage.h"
#import "OrdersTableView.h"

@implementation RootView

@synthesize context;
@synthesize button1,button2,button3,button4,button5,button6;
@synthesize popOver;
@synthesize bgImgLand,bgImgPort;

@synthesize moviePlayer;

@synthesize choosenWall;

-(void)dealloc
{
    self.context = nil;
    self.view = nil;
    self.bgImgLand = nil;
    self.bgImgPort = nil;
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

-(void)viewDidAppear:(BOOL)animated
{
    NSLog(@"Appearing View \n %i : %i",[[NSUserDefaults standardUserDefaults] boolForKey:@"ud_Movie"],[[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]);
    //if([[NSUserDefaults standardUserDefaults] boolForKey:@"ud_Movie"]//){ 
       //&& 
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]){
        //NSLog(@"Enter the movie");
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self playMovie];
    }else{
        [self renderInterface];
    }
}
- (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    NSLog(@"View Will Appear");
    
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    //allocate the view
    self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]autorelease];
    self.view.backgroundColor = [UIColor blackColor];
    //self.wantsFullScreenLayout = YES;
    
    /*
    //if([[NSUserDefaults standardUserDefaults] boolForKey:@"playMovie"]){
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"ud_Movie"]){
        [self playMovie];
    }else{ 
        [self renderInterface];
    }
     */
    
    
    ///////////////////////////
    // A default image for manipulation (empty by default)
    
    self.choosenWall = [UIImage imageWithContentsOfFile:
                        [[NSBundle mainBundle] pathForResource:@"Paint_Sample_Hog_Bristle" ofType:@"jpg"]];
    
}

-(void)renderInterface
{

    // background Image
    UIImage *bgPort = [UIImage imageWithContentsOfFile:
                   [[NSBundle mainBundle] pathForResource:@"main-bg-port-white" ofType:@"png"]];
    bgImgPort =[[UIImageView alloc] initWithImage:bgPort];
    UIImage *bgLand = [UIImage imageWithContentsOfFile:
                       [[NSBundle mainBundle] pathForResource:@"main-bg-land" ofType:@"png"]];
    bgImgLand =[[UIImageView alloc] initWithImage:bgLand];
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    bgImgLand.frame = CGRectMake(0, -40, screenHeight, screenWidth);
    //bgImg.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:bgImgLand];
    [self.view addSubview:bgImgPort];
    

    //////////////////////////////
    // main Navigation Options
    // 1. show catalog
    UIImage *img1 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"catalog-btn" ofType:@"png"]]; 
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:img1 forState:UIControlStateNormal];
    
    //button1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setTitle:@"Catalog" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(showCatalog) forControlEvents:UIControlEventTouchUpInside];

    // 2. Choose Background (from supplied)
    UIImage *img2 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"bg-btn" ofType:@"png"]];
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:img2 forState:UIControlStateNormal];
    //button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setTitle:@"Choose BG" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(chooseBackgroundFromLibrary) forControlEvents:UIControlEventTouchUpInside];
    
    // 3. Create Background (camera or library)
    UIImage *img3 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"photo-btn" ofType:@"png"]];
    
    button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setImage:img3 forState:UIControlStateNormal];
    //button3 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setTitle:@"Create BG" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(takePicture:) forControlEvents:UIControlEventTouchUpInside];
    
    // 4. show Orders
    UIImage *img4 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"cart-btn" ofType:@"png"]];
    button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button4 setImage:img4 forState:UIControlStateNormal];
    //button4 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button4 setTitle:@"Orders" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(showOrders) forControlEvents:UIControlEventTouchUpInside];
    
    // 5. show Search
    UIImage *img5 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"search-btn" ofType:@"png"]];
    button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button5 setImage:img5 forState:UIControlStateNormal];
    //button5 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button5 setTitle:@"Search" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(searchPage) forControlEvents:UIControlEventTouchUpInside];
    
    // 6. show Settings
    UIImage *img6 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"setting-btn" ofType:@"png"]];
    button6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button6 setImage:img6 forState:UIControlStateNormal];
    //button6 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button6 setTitle:@"Settings" forState:UIControlStateNormal];
    [button6 addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
    
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
    
    //////////////////////////
    // swap bg for orientation
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        screenWidth = screenRect.size.height;
        screenHeight = screenRect.size.width - 160;
        
        [self.view sendSubviewToBack:bgImgPort];
       
    }else{
        [self.view sendSubviewToBack:bgImgLand];
    }
    
    
    
    float pad = 50;
    float buttonWidth = 150;
    float buttonHeight = 150;
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        pad = 10;
        buttonWidth = 80;
        buttonHeight = 80;
    }
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
#pragma mark - MoviePlayer
-(void)playMovie
{
    /////////////////////////////////////////////
    // Play movie
    NSURL *url;
    if(YES){
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] 
                                         pathForResource:@"ipadIntro" ofType:@"mov"]];
    }else{
        url = [NSURL fileURLWithPath:[[NSBundle mainBundle] 
                                         pathForResource:@"iPhoneIntro" ofType:@"mov"]];
    }
    
    moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:moviePlayer];
    
    
    moviePlayer.controlStyle = MPMovieControlStyleNone;
    moviePlayer.shouldAutoplay = YES;
    moviePlayer.fullscreen = YES;
    moviePlayer.view.frame = [[UIScreen mainScreen] bounds];
    
    
    [moviePlayer setFullscreen:YES animated:YES];
    //[moviePlayer release];
    [self.view addSubview:moviePlayer.view];
    
    /* This doesn't work for the movie but does if you apply it to the view */
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    UIView *aView = [[UIView alloc] initWithFrame:moviePlayer.view.bounds];
    [aView addGestureRecognizer:tap];
    [moviePlayer.view addSubview:aView];
    //[moviePlayer.view addGestureRecognizer:tap];
    [tap release];
    [aView release];
    
}

- (void)handleTap:(UITapGestureRecognizer *)gesture {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self      
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    if ([moviePlayer 
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [moviePlayer.view removeFromSuperview];
    }
    [moviePlayer release];
    [self renderInterface];
}


-(void)moviePlayBackDidFinish:(NSNotification*)notification 
{
    
    //MPMoviePlayerController *moviePlayer = [notification object];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self      
                                                    name:MPMoviePlayerPlaybackDidFinishNotification
                                                  object:moviePlayer];
    
    if ([moviePlayer 
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [moviePlayer.view removeFromSuperview];
    }
    [moviePlayer release];
    [self renderInterface];
}

#pragma mark - Button call Backs
-(void)showCatalog
{
    //BrandTableView *brand = [[BrandTableView alloc]initWithNibName:nil bundle:nil];
    //BrandTableView *brand = [[BrandTableView alloc] initWithStyle:UITableViewStyleGrouped];
    BrandCatalogTableView *brand = [[BrandCatalogTableView alloc] initWithStyle:UITableViewStyleGrouped];
    brand.context = self.context;
    brand.wallImage = [UIImage imageWithCGImage: self.choosenWall.CGImage];
   // NSLog(@"show catalog - >background Image :: %@",self.choosenWall);
    [self.navigationController pushViewController:brand animated:YES];
    [brand release];
}

-(void)showOrders
{
    //OrdersTableView *orders = [[OrdersTableView alloc]init];
    OrdersTableView *orders = [[OrdersTableView alloc] initWithStyle:UITableViewStyleGrouped];
    orders.context = self.context;
    [self.navigationController pushViewController:orders animated:YES];
    [orders release];
}
-(void)showSettings
{
    AppSettingsTableView *settings = [[AppSettingsTableView alloc]initWithStyle:UITableViewStyleGrouped ];
    [self.navigationController pushViewController:settings animated:YES];
    [settings release];
}

-(void)chooseBackgroundFromLibrary
{
    BackgroundLibrary *bgLibrary = [[BackgroundLibrary alloc]init];
    // watch for it's compleation
    bgLibrary.selected = NO;
    [bgLibrary addObserver:self forKeyPath:@"selected" options:NSKeyValueObservingOptionNew context:NULL];
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
-(void)setBackgroundImageFromLibrary
{
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // catch the background selection finish
    //NSLog(@"CAtch Change");
    [object removeObserver:self forKeyPath:@"selected"];
    BackgroundLibrary *senderType = (BackgroundLibrary *)object;
    /*
    UIImageView *imageView = [[UIImageView alloc] initWithImage: senderType.selectedImage]; 
    
    [self.view addSubview: imageView]; 
    [self.view sendSubviewToBack:imageView];
    [imageView release];
    */
    NSLog(@"observer - > background Image :: %@",senderType.selectedImage);
    self.choosenWall = [UIImage imageWithCGImage:[senderType.selectedImage CGImage]];
    NSLog(@"observer - > background Image :: %@",self.choosenWall);
    // [self showOrders];
    [senderType.navigationController popViewControllerAnimated:YES];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



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
-(CGFloat)degreesToRadians:(CGFloat) degrees
{return degrees * M_PI / 180;};
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
    //NSLog(@"sent %@",info);
    //NSLog(@"\n\nOrientation %@ ",[[info objectForKey:UIImagePickerControllerMediaMetadata] objectForKey:@"Orientation"]);
    
    if([[[info objectForKey:UIImagePickerControllerMediaMetadata] objectForKey:@"Orientation"] intValue] == 6){    //EXIF 6
    // fix info for original image.
        NSLog(@"EXIF 6");
        /* v1 - doesn't work
        self.choosenWall = [[UIImage alloc] initWithCGImage: [[info objectForKey:UIImagePickerControllerOriginalImage] CGImage]
                                   scale: 1.0
                             orientation: UIImageOrientationRight];
         */
        /* v2 seems to scale the image
        UIImage *taken = [info objectForKey:UIImagePickerControllerOriginalImage]; 
        
        // calculate the size of the rotated view's containing box for our drawing space
        UIView *rotatedViewBox = [[UIView alloc] initWithFrame:CGRectMake(0,0,taken.size.width, taken.size.height)];
        CGAffineTransform t = CGAffineTransformMakeRotation([self degreesToRadians:90.0]);
        rotatedViewBox.transform = t;
        CGSize rotatedSize = rotatedViewBox.frame.size;
        [rotatedViewBox release];
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize);
        CGContextRef bitmap = UIGraphicsGetCurrentContext();
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
        
        // Rotate the image context
        CGContextRotateCTM(bitmap, [self degreesToRadians:90.0]);
        
        // Now, draw the rotated/scaled image into the context
        CGContextScaleCTM(bitmap, 1.0, -1.0);
        CGContextDrawImage(bitmap, CGRectMake(-taken.size.width / 2, -taken.size.height / 2, taken.size.height, taken.size.width), [taken CGImage]);
        
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        
        self.choosenWall = [UIImage imageWithCGImage: [newImage CGImage]];
         */
/*        
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = screenRect.size.height;
        
        //self.choosenWall.frame = CGRectMake(0, 0, screenWidth, screenHeight);
 */
        
        self.choosenWall = [self imageByRotatingImage:[info objectForKey:UIImagePickerControllerOriginalImage]
                                 fromImageOrientation:UIImageOrientationRight];
    }else{
    
        self.choosenWall = [info objectForKey:UIImagePickerControllerOriginalImage]; 
    }
    
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


-(UIImage*)imageByRotatingImage:(UIImage*)initImage fromImageOrientation:(UIImageOrientation)orientation
{
    CGImageRef imgRef = initImage.CGImage;
    
    CGFloat width = CGImageGetWidth(imgRef);
    CGFloat height = CGImageGetHeight(imgRef);
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imgRef), CGImageGetHeight(imgRef));
    CGFloat boundHeight;
    UIImageOrientation orient = orientation;
    switch(orient) {
            
        case UIImageOrientationUp: //EXIF = 1
            return initImage;
            break;
            
        case UIImageOrientationUpMirrored: //EXIF = 2
            transform = CGAffineTransformMakeTranslation(imageSize.width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown: //EXIF = 3
            transform = CGAffineTransformMakeTranslation(imageSize.width, imageSize.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored: //EXIF = 4
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored: //EXIF = 5
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, imageSize.width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft: //EXIF = 6
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, imageSize.width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored: //EXIF = 7
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight: //EXIF = 8
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(imageSize.height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            [NSException raise:NSInternalInconsistencyException format:@"Invalid image orientation"];
            
    }
    // Create the bitmap context
    CGContextRef    context2 = NULL;
    void *          bitmapData;
    int             bitmapByteCount;
    int             bitmapBytesPerRow;
    
    // Declare the number of bytes per row. Each pixel in the bitmap in this
    // example is represented by 4 bytes; 8 bits each of red, green, blue, and
    // alpha.
    bitmapBytesPerRow   = (bounds.size.width * 4);
    bitmapByteCount     = (bitmapBytesPerRow * bounds.size.height);
    bitmapData = malloc( bitmapByteCount );
    if (bitmapData == NULL)
    {
        return nil;
    }
    
    // Create the bitmap context. We want pre-multiplied ARGB, 8-bits
    // per component. Regardless of what the source image format is
    // (CMYK, Grayscale, and so on) it will be converted over to the format
    // specified here by CGBitmapContextCreate.
    CGColorSpaceRef colorspace = CGImageGetColorSpace(imgRef);
    context2 = CGBitmapContextCreate (bitmapData,bounds.size.width,bounds.size.height,8,bitmapBytesPerRow,
                                     colorspace,kCGImageAlphaPremultipliedLast);
    //@TODO CGColorSpaceRelease(colorspace);
    
    if (context2 == NULL)
        // error creating context
        return nil;
    
    CGContextScaleCTM(context2, -1.0, -1.0);
    CGContextTranslateCTM(context2, -height, -width);
    
    CGContextConcatCTM(context2, transform);
    
    // Draw the image to the bitmap context. Once we draw, the memory
    // allocated for the context for rendering will then contain the
    // raw image data in the specified color space.
    CGContextDrawImage(context2, CGRectMake(0,0,width, height), imgRef);
    
    CGImageRef imgRef2 = CGBitmapContextCreateImage(context2);
    CGContextRelease(context2);
    free(bitmapData);
    UIImage * image = [UIImage imageWithCGImage:imgRef2 scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    CGImageRelease(imgRef2);
    return image;
}
@end
