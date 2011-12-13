//
//  FacePlateView.m
//  Catalog2
//
//  Created by Ashley McCoy on 13/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "FacePlateView.h"
#import <QuartzCore/QuartzCore.h>

@implementation FacePlateView


-(void)dealloc
{
    [categoryName release];
    [controlsView release];
    
    [super dealloc];
}


-(void)drawWithItems:(NSArray *)items
{
    // remove any views that already exist
    for (UIView *view in [self.view subviews]) { [view removeFromSuperview]; }
    

    // the Control View is going to hold the non-image elements
    controlsView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self.view addSubview:self.controlsView];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    ////////////////////
    //Product Name
    UILabel *myLabel = [[UILabel alloc] 
                        initWithFrame:CGRectMake(20,screenHeight - 250, screenWidth - 40, 100)];      
    myLabel.text = self.productName;
    myLabel.textColor = [UIColor whiteColor];
    myLabel.backgroundColor = [UIColor clearColor];
    [self.controlsView addSubview:myLabel];
    [myLabel release];
    
    ////////////////////////////////
    // button to choose this one
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    //button.frame = CGRectMake(10, 10, 50, 30);
    button.frame = CGRectMake(20, screenHeight - 300, 200, 30);
    [button setTitle: @"Resize on Background" forState: UIControlStateNormal];
    [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
    [button addTarget:self action:@selector(chooseMe) forControlEvents:UIControlEventTouchUpInside];
    [self.controlsView addSubview: button];
    
    // the mechanism picture
    UIImageView *bgMech = [[UIImageView alloc] initWithImage:[items objectAtIndex:0]];
    [self.view addSubview:bgMech];
    [bgMech release];
    
    // FacePlate Picture
   // NSLog(@" \n\n Passed Image \n\n%@\n\n",items );
    NSString *img = [[items lastObject] valueForKey:@"id"];
    
    self.price = [[items lastObject] valueForKey:@"price"];
    
    NSString *dir = [NSString stringWithFormat:@"%@/Faceplate",
           [self.brandName stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    NSString *imgCleaned = [NSString stringWithFormat:@"%@%@",
                            self.orientationPrefix,
                            [img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
    
    //NSLog(@"  - File NAme %@",imgCleaned);
    // Grab the image off disk and load it up
    NSString *imageName = [[NSBundle mainBundle] 
                           pathForResource:imgCleaned
                           ofType:@"png" 
                           inDirectory:dir];
    //NSLog(@" - - - Path\n %@\n",imageName);
    
    // Grab the image off disk and load it up
    /*
    NSString *imageName = [[NSBundle mainBundle] pathForResource:
                           [img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]
                           ofType:@"png"];
    */
    UIImage *image = [UIImage imageWithContentsOfFile:imageName];
    UIImageView *nextImage = [[UIImageView alloc] initWithImage:image];
    nextImage.backgroundColor = [UIColor clearColor];
    nextImage.contentMode = UIViewContentModeScaleAspectFit;
   // nextImage.frame = CGRectMake(20, 20, screenWidth-40, screenHeight-140);
    float iWidth = screenWidth * 0.8;
    float iHeight = screenHeight * 0.8;
    float sX = (screenWidth -iWidth)/2.0;
    float sY = (screenHeight - iHeight)/2.0 - 60;
    
    //nextImage.frame = CGRectMake(80, 80, screenWidth-160, screenHeight-260);
    nextImage.frame = CGRectMake(sX, sY, iWidth, iHeight- 100.0);
    
    [self.view addSubview:nextImage];
    [nextImage release];

    
    [self addToolBarToView];
    
}
-(void)chooseMe
{
    self.selected =YES;
}

#pragma mark - View lifecycle
/*
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.selected = NO;
    self.backgroundColor = [UIColor clearColor];
    if (self) {
        // Initialization code
        
    }
    return self;
}
 */

// don't forget Quartz.Core with this method
-(UIImage *)getMechanismImage
{
    //[self.controlsView removeFromSuperview];
    self.controlsView.hidden = YES;
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    //UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
    self.controlsView.hidden = NO;
    return screenshot;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    
    self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]autorelease];
    self.selected = NO;
    self.view.backgroundColor = [UIColor clearColor];
    /*
     // Add a view cause there ain't no nib
     UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
     [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
     [view setBackgroundColor:[UIColor blueColor]];
     self.view = view;
     [view release];
     */
    // the size of the screen
    
}


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad
 {
 [super viewDidLoad];
 }
 */


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
@end
