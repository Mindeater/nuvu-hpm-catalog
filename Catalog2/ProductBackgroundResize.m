//
//  ProductBackgroundResize.m
//  Catalog2
//
//  Created by Ashley McCoy on 5/12/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "ProductBackgroundResize.h"


// http://b2cloud.com.au/how-to-guides/ios-distort-transform
#define CGAffineTransformDistort(t, x, y) (CGAffineTransformConcat(t, CGAffineTransformMake(1, y, x, 1, 0, 0)))
#define CGAffineTransformMakeDistort(x, y) (CGAffineTransformDistort(CGAffineTransformIdentity, x, y))

@implementation ProductBackgroundResize

@synthesize backgroundImage,resizingImage;
@synthesize canvas;

- (void)dealloc
{
    [backgroundImage release];
    // auto released [resizingImage release];
    [canvas release];
    [_marque release];
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



#pragma mark - Private Methods

-(void)showOverlayWithFrame:(CGRect)frame {
    
    if (![_marque actionForKey:@"linePhase"]) {
        CABasicAnimation *dashAnimation;
        dashAnimation = [CABasicAnimation animationWithKeyPath:@"lineDashPhase"];
        [dashAnimation setFromValue:[NSNumber numberWithFloat:0.0f]];
        [dashAnimation setToValue:[NSNumber numberWithFloat:15.0f]];
        [dashAnimation setDuration:0.5f];
        [dashAnimation setRepeatCount:HUGE_VALF];
        [_marque addAnimation:dashAnimation forKey:@"linePhase"];
    }
    
    _marque.bounds = CGRectMake(frame.origin.x, frame.origin.y, 0, 0);
    _marque.position = CGPointMake(frame.origin.x + canvas.frame.origin.x, frame.origin.y + canvas.frame.origin.y);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, frame);
    [_marque setPath:path];
    CGPathRelease(path);
    
    _marque.hidden = NO;
    
}

-(void)resetSize:(id)sender
{
    // scale
    // rotation
    // translation
    
    // remove current view
    [canvas removeFromSuperview];
    
    [self viewDidLoad];
    //[self showOverlayWithFrame:photoImage.frame];
}
-(void)scale:(id)sender {
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = photoImage.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [photoImage setTransform:newTransform];
    
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    [self showOverlayWithFrame:photoImage.frame];
}

-(void)rotate:(id)sender {
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        _lastRotation = 0.0;
        return;
    }
    
    //photoImage.layer.anchorPoint = CGPointMake(0.0, 0.5);
    /*
    CATransform3D rotatedTransform = photoImage.layer.transform;
    rotatedTransform = CATransform3DRotate(rotatedTransform, 60.0 * M_PI / 180.0, 0.0f, 0.0f, 1.0f);
    photoImage.layer.transform = rotatedTransform;
    */
    //CATransform3DRotate the3DRotation ??
    //CATransform3D rotatedTransform = photoImage.layer.transform;
   // photoImage.layer.transform = CATransform3DMakeRotation(M_PI, 0, 0.0, 1.0);
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    
    CGAffineTransform currentTransform = photoImage.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [photoImage setTransform:newTransform];
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
     
    [self showOverlayWithFrame:photoImage.frame];
}


-(void)move:(id)sender {
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:canvas];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [photoImage center].x;
        _firstY = [photoImage center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
    [photoImage setCenter:translatedPoint];
    [self showOverlayWithFrame:photoImage.frame];
}

-(void)tapped:(id)sender {
    //NSLog(@"TAPPED");
    _marque.hidden = YES;
}




#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


#pragma mark - core graphics manipulation
/*
- (CGContextRef)createCGContextFromCGImage:(CGImageRef)img
{
    size_t width = CGImageGetWidth(img);
    size_t height = CGImageGetHeight(img);
    size_t bitsPerComponent = CGImageGetBitsPerComponent(img);
    size_t bytesPerRow = CGImageGetBytesPerRow(img);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL, // Let CG allocate it for us
                                             width,
                                             height,
                                             bitsPerComponent,
                                             bytesPerRow,
                                             colorSpace,
                                             kCGImageAlphaPremultipliedLast); // RGBA
    CGColorSpaceRelease(colorSpace);
    NSAssert(ctx, @"CGContext creation fail");
    
    return ctx;
}
*/
-(UIImage *)cleanTransparentPixelsFromImage:(UIImage *)anImage
{
    // http://iphonedevelopertips.com/graphics/how-to-crop-an-image.html
    
    CGImageRef imageRef = anImage.CGImage;
    NSData *data        = (NSData *)CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    char *pixels        = (char *)[data bytes];
    
    // this is where you manipulate the individual pixels
    // assumes a 4 byte pixel consisting of rgb and alpha
    // for PNGs without transparency use i+=3 and remove int a
    
    
    // need to create a CGRect for the internal image ignoring the transparency outside
    size_t width                    = CGImageGetWidth(imageRef);
    //size_t height                   = CGImageGetHeight(imageRef);
    
    int topLX = 0;
    int topLY = 0; 
    int topRX = 0; 
    int botLY = 0;
    
    size_t colCount= 0;
    size_t lineCount = 0;
    
    BOOL firstPixelFound = NO;
    BOOL secondPixelFound = NO;
    BOOL thirdPixelFound = NO;
    
    BOOL fullLineTranparent = YES;
    int transLineCount = 0;
    
    for(int i = 0; i < [data length]; i += 4)
    {
        /*int r = i;
        int g = i+1;
        int b = i+2;*/
        int a = i+3;
        
        
        // line count
        if(colCount == width){ // new line
            
            if(transLineCount == colCount && fullLineTranparent){
                // whole line is empty pixels
                transLineCount = 0;
            }else{
                // the line above should be used
                topLY = lineCount-1;
                fullLineTranparent = NO;
            }
            lineCount++;
            colCount = 0;
        }
        colCount++;
        
        // catch all the transparent pixels on a line
        if(pixels[a] == 0){
            transLineCount++;
        }
        
        
        //@TODO: this logic only works if the image has 90 degree corners
        // need to allow tolerance for rounded edges
        
        // the first pixel that is not transparent gives the startpoint to crop from
        if(pixels[a] != 0 && !firstPixelFound ){
            topLX = colCount;
            
            firstPixelFound = YES;
            
        }
        // after that the next transparent pixel on the same line will be the end
        // ?? && colCount > topLX+30
        if(!secondPixelFound && firstPixelFound  && pixels[a] == 0 ){
            topRX = colCount;
            secondPixelFound = YES;
            
        }
        // after that anytime the pixel next to the start one is transparent we should be at the end.
        if(firstPixelFound && secondPixelFound && !thirdPixelFound && pixels[a] == 0 && colCount == topLX +1){
            botLY = lineCount;
           // NSLog(@"Got bottom point");
            thirdPixelFound = YES;
        }
        // modify the image pixels
       /*
        if(a !=0){
            pixels[r]   = pixels[r];
            pixels[g]   = pixels[g];
            pixels[b]   = pixels[b];
            pixels[a]   = pixels[a];
        }
        */
    }
    /*
    NSLog(@" \n\nThe points ::\ntopLX,topLY (%i , %i),\ntopRX,topRY (%i , %i),\nbotLX,botLY(%i , %i)\n\n",
          topLX,topLY,
          topRX,topRY,
          botLX,botLY);
    */
    //crop an image based on CGRect bounds
     CGImageRef imageRefCrop = CGImageCreateWithImageInRect([anImage CGImage],
                                                            CGRectMake(topLX,
                                                                       topLY, 
                                                                       topRX - topLX,
                                                                       //width - topLX , 
                                                                       botLY - topLY));
                                                                       //height - topLY));
     UIImage *croppedImage = [UIImage imageWithCGImage:imageRefCrop];
     CGImageRelease(imageRefCrop);
    [data release];
     return croppedImage;
    
}
 

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelResize:)];          
    self.navigationItem.leftBarButtonItem = anotherButton;
    [anotherButton release];
    
    UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc] initWithTitle:@"Keep" style:UIBarButtonItemStylePlain target:self action:@selector(saveResized:)];          
    self.navigationItem.rightBarButtonItem = anotherButton2;
    [anotherButton2 release];
    
    //////////////////////
    // background image
    
    UIImageView *bg = [[UIImageView alloc]initWithImage:self.backgroundImage];
    
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenWidth = screenRect.size.width;
        CGFloat screenHeight = self.view.frame.size.height;
        // original height / original width x new width = new height
        
        
        if(self.backgroundImage.size.width == self.backgroundImage.size.height){
            // this is a built in one
            CGFloat newWidth = self.backgroundImage.size.width / self.backgroundImage.size.height *screenHeight;
            bg.frame = CGRectMake(0, 0, newWidth, screenHeight); 
            // NSLog(@"Resized to :\nwidth:%f - height:%f",newWidth,screenHeight);
        }else{
            // original height / original width x new width = new height
            CGFloat newHeight = self.backgroundImage.size.height / self.backgroundImage.size.width * screenWidth;
            bg.frame = CGRectMake(0, 0, screenWidth, newHeight); 
        }
    }
    
    /*
    CGSize boundsSize = self.view.bounds.size;
    CGRect frameToCenter = bg.frame;
    
    // center horizontally
    if (frameToCenter.size.width < boundsSize.width)
        frameToCenter.origin.x = (boundsSize.width - frameToCenter.size.width) / 2;
    else
        frameToCenter.origin.x = 0;
    
    // center vertically
    if (frameToCenter.size.height < boundsSize.height)
        frameToCenter.origin.y = (boundsSize.height - frameToCenter.size.height) / 2;
    else
        frameToCenter.origin.y = 0;
    
    bg.frame = frameToCenter;
    */
    
    [self.view addSubview:bg];
    [bg release];
    
    /////////////////////
    // product
    
    canvas = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];

    ////////////////////////
    // The image
    photoImage =[[UIImageView alloc] initWithImage:self.resizingImage];
    /*
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    UIImage *new = [self cleanTransparentPixelsFromImage:self.resizingImage];
    photoImage =[[UIImageView alloc] initWithImage: new];
    photoImage.frame = CGRectMake((screenWidth - new.size.width)/2,
                                  (screenHeight - new.size.height)/2 -100, 
                                  new.size.width, new.size.height);
    */
    [self.canvas addSubview:photoImage];
    
    [self.view addSubview:canvas];
     
    
    ////////////////////////////
    // Set up interface
    
    if (!_marque) {
        _marque = [[CAShapeLayer layer] retain];
        _marque.fillColor = [[UIColor clearColor] CGColor];
        _marque.strokeColor = [[UIColor grayColor] CGColor];
        _marque.lineWidth = 1.0f;
        _marque.lineJoin = kCALineJoinRound;
        _marque.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:10],[NSNumber numberWithInt:5], nil];
        _marque.bounds = CGRectMake(photoImage.frame.origin.x, photoImage.frame.origin.y, 0, 0);
        _marque.position = CGPointMake(photoImage.frame.origin.x + canvas.frame.origin.x, photoImage.frame.origin.y + canvas.frame.origin.y);
    }
    //[[self.view layer] addSublayer:_marque];
    
    /// Pinch to scale -yes
    UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)] autorelease];
    [pinchRecognizer setDelegate:self];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    
    UIRotationGestureRecognizer *rotationRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)] autorelease];
    [rotationRecognizer setDelegate:self];
    [self.view addGestureRecognizer:rotationRecognizer];
    
    
    // single touch move 
    UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] autorelease];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [canvas addGestureRecognizer:panRecognizer];
    
    // tap switch marquee on and off
    UITapGestureRecognizer *tapProfileImageRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease];
    [tapProfileImageRecognizer setNumberOfTapsRequired:1];
    [tapProfileImageRecognizer setDelegate:self];
    [canvas addGestureRecognizer:tapProfileImageRecognizer];
    
    
    // reset on double tap
    // Create gesture recognizer
    UITapGestureRecognizer *oneFingerTwoTaps = 
    [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetSize:)] autorelease];
    
    // Set required taps and number of touches
    [oneFingerTwoTaps setNumberOfTapsRequired:2];
    [oneFingerTwoTaps setNumberOfTouchesRequired:1];
    
    // Add the gesture to the view
    [canvas addGestureRecognizer:oneFingerTwoTaps];
    /*
    UISwipeGestureRecognizerDirectionDown *downRecognizer = [[[UISwipeGestureRecognizerDirectionDown alloc] initWithTarget:self action:@selector(swipeDown:)]autorelease];
    [canvas addGestureRecognizer:downRecognizer];
    */

    
}

#pragma mark UIGestureRegognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && ![gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
   
}


#pragma mark - navbar event handlers
-(void)cancelResize:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)saveResized:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
