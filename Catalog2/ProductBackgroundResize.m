//
//  ProductBackgroundResize.m
//  Catalog2
//
//  Created by Ashley McCoy on 5/12/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "ProductBackgroundResize.h"

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
    NSLog(@"TAPPED");
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
    //CFDataRef imageData = CGDataProviderCopyData(CGImageGetDataProvider(anImage.CGImage)); 
    //const UInt32 *pixels = (const UInt32*)CFDataGetBytePtr(imageData);
    
    //the new image
   // unsigned char* pixelBytes = (unsigned char *)[imageData bytes];
    //and you can just iterate through it:
    /*
    for (int j = 0; j < (anImage.size.height * anImage.size.width); j++)
    {
        if (pixels[j] & 0xff000000)
        {
            //this is not a transparent pixel
            // add it to the new image
           // NSLog(@"%lu", pixels[j]); //trace hexes
            
        }
    }*/
    /*
    CGImageRef imageRef = anImage.CGImage;
    NSData *data        = (NSData *)CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    char *pixels        = (char *)[data bytes];
    
    // this is where you manipulate the individual pixels
    // assumes a 4 byte pixel consisting of rgb and alpha
    // for PNGs without transparency use i+=3 and remove int a
    for(int i = 0; i < [data length]; i += 4)
    {
        int r = i;
        int g = i+1;
        int b = i+2;
        int a = i+3;
        if(a !=0){
        pixels[r]   = pixels[r];
        pixels[g]   = pixels[g];
        pixels[b]   = pixels[b];
        pixels[a]   = pixels[a];
        }
    }
    
    // create a new image from the modified pixel data
    size_t width                    = CGImageGetWidth(imageRef);
    size_t height                   = CGImageGetHeight(imageRef);
    size_t bitsPerComponent         = CGImageGetBitsPerComponent(imageRef);
    size_t bitsPerPixel             = CGImageGetBitsPerPixel(imageRef);
    size_t bytesPerRow              = CGImageGetBytesPerRow(imageRef);
    
    CGColorSpaceRef colorspace      = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo         = CGImageGetBitmapInfo(imageRef);
    CGDataProviderRef provider      = CGDataProviderCreateWithData(NULL, pixels, [data length], NULL);
    
    CGImageRef newImageRef = CGImageCreate (
                                            width,
                                            height,
                                            bitsPerComponent,
                                            bitsPerPixel,
                                            bytesPerRow,
                                            colorspace,
                                            bitmapInfo,
                                            provider,
                                            NULL,
                                            false,
                                            kCGRenderingIntentDefault
                                            );
    // the modified image
    UIImage *newImage   = [UIImage imageWithCGImage:newImageRef];
    
   // NSUInteger myImageDataLength = [data length]; 
    //UIImage *newImage = [UIImage imageWithData:[NSData dataWithBytes:pixels length:myImageDataLength]];;
    // cleanup
    free(pixels);
    CGImageRelease(imageRef);
    CGColorSpaceRelease(colorspace);
    CGDataProviderRelease(provider);
    CGImageRelease(newImageRef);
    
    return newImage;
    //*/return [[[UIImage alloc]init]autorelease];
}
 

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = [UIColor blackColor];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelResize:)];          
    self.navigationItem.leftBarButtonItem = anotherButton;
    [anotherButton release];
    
    UIBarButtonItem *anotherButton2 = [[UIBarButtonItem alloc] initWithTitle:@"Keep" style:UIBarButtonItemStylePlain target:self action:@selector(saveResized:)];          
    self.navigationItem.rightBarButtonItem = anotherButton2;
    [anotherButton2 release];
    
    //////////////////////
    // background image
    
    
    
    UIImageView *bg = [[UIImageView alloc]initWithImage:self.backgroundImage];
    [self.view addSubview:bg];
    [bg release];
    
    //self.view.backgroundColor = [UIColor yellowColor];
    /////////////////////
    // product
    
    
    canvas = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    
    
    photoImage =[[UIImageView alloc] initWithImage:self.resizingImage];
    //photoImage =[[UIImageView alloc] initWithImage: [self cleanTransparentPixelsFromImage:self.resizingImage]];
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
    [[self.view layer] addSublayer:_marque];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)] autorelease];
    [pinchRecognizer setDelegate:self];
    [self.view addGestureRecognizer:pinchRecognizer];
    
    UIRotationGestureRecognizer *rotationRecognizer = [[[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(rotate:)] autorelease];
    [rotationRecognizer setDelegate:self];
    [self.view addGestureRecognizer:rotationRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)] autorelease];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [canvas addGestureRecognizer:panRecognizer];
    
    UITapGestureRecognizer *tapProfileImageRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease];
    [tapProfileImageRecognizer setNumberOfTapsRequired:1];
    [tapProfileImageRecognizer setDelegate:self];
    [canvas addGestureRecognizer:tapProfileImageRecognizer];
    

    
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

-(void)cancelResize:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
-(void)saveResized:(id)sender
{
    [self dismissModalViewControllerAnimated:YES];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
