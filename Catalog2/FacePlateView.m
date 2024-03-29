//
//  FacePlateView.m
//  Catalog2
//
//  Created by Ashley McCoy on 13/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "FacePlateView.h"


@implementation FacePlateView


-(void)dealloc
{
    [categoryName release];
    [controlsView release];
    
    [super dealloc];
}


-(void)drawWithItems:(NSArray *)items
{
    // the frame gets shortened somewhere so this makes sure it's the right size
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    // remove any views that already exist
    for (UIView *view in [self.view subviews]) { [view removeFromSuperview]; }
    
    ////////////////////////////////////////////////////////////
    // the Control View is going to hold the non-image elements
    if(!controlsView){
        controlsView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    }
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    controlsView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.view addSubview:self.controlsView];
    
    ////////////////////////////////////
    // the mechanism picture goes behind
    UIImageView *bgMech = [[UIImageView alloc] initWithImage:[items objectAtIndex:0]];
    [self.view addSubview:bgMech];
    [bgMech release];
    
    //NSLog(@" Part view Draw %i",[items count]);
    if([items count] >1){
       // NSLog(@" looking for coverplate to draw");
        /////////////////////////////////////
        // Build the file path and image name
        NSString *img = [[items lastObject] valueForKey:@"id"];
        
      
        NSString *dir = [NSString stringWithFormat:@"%@/Faceplate",
               [self.brandName stringByReplacingOccurrencesOfString:@" " withString:@""]];
        
        NSString *imgCleaned = [NSString stringWithFormat:@"%@%@",
                                self.orientationPrefix,
                                [img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
        
       // NSLog(@"\nCoverPlate \n\n - File NAme %@ \nwith PAth: %@\n\n\n\n",imgCleaned,dir);
        NSString *imageName = [[NSBundle mainBundle] 
                               pathForResource:imgCleaned
                               ofType:@"png" 
                               inDirectory:dir];
        //NSLog(@"\nFacePlate added from - - - Path\n %@\n",imageName);
        
        ///////////////////////////////
        // store internals
        self.parts = [NSString stringWithFormat:@"%@",img];
        self.price = [[items lastObject] valueForKey:@"price"];
        
        /////////////////////////////////////////
        // Grab the image off disk and load it up

        UIImage *image = [UIImage imageWithContentsOfFile:imageName];
        UIImageView *nextImage = [[UIImageView alloc] initWithImage:image];
        nextImage.backgroundColor = [UIColor clearColor];
        nextImage.contentMode = UIViewContentModeScaleAspectFit;

        /////////////////////////////////
        // calculate size based on interface
        float iWidth = screenWidth * 0.8;
        float iHeight = screenHeight * 0.8;
        float sX = (screenWidth -iWidth)/2.0;
        float sY = (screenHeight - iHeight)/2.0 - adjustImagePositionY;
        nextImage.frame = CGRectMake(sX, sY, iWidth, iHeight- adjustImageFrameHeightFactor);
        
        [self.view addSubview:nextImage];
        [nextImage release];
    }
    
    [self addToolBarToView];
    
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
