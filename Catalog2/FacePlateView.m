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
    [parentProduct release];
    [controlsView release];
    [super dealloc];
}

-(void)drawWithItems:(NSArray *)items
{
    // remove any views that already exist
    NSLog(@" - - draw Faceplate");
    for (UIView *view in [self subviews]) { [view removeFromSuperview]; }
    NSLog(@" - - - stripped existing views");
    // the Control View is going to hold the non-image elements
    controlsView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self addSubview:self.controlsView];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //Product Name
    UILabel *myLabel = [[UILabel alloc] 
                        initWithFrame:CGRectMake(20,screenHeight - 150, screenWidth - 40, 100)];      
    myLabel.text = self.parentProduct;
    myLabel.textColor = [UIColor redColor];
    [self.controlsView addSubview:myLabel];
    [myLabel release];
    
    // button to choose this one
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 100, 100, 60);
    [button setTitle: @"OK" forState: UIControlStateNormal];
    [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
    [button addTarget:self action:@selector(chooseMe) forControlEvents:UIControlEventTouchUpInside];
    [self.controlsView addSubview: button];
    
    // FacePlate Picture
    NSLog(@" \n\n Passed Image \n\n%@\n\n",items );
    NSString *img = [[items lastObject] valueForKey:@"id"];
    
    NSString *dir = [NSString stringWithFormat:@"%@/Faceplate",
           [self.brandName stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    NSString *imgCleaned = [NSString stringWithFormat:@"%@%@",
                            self.orientationPrefix,
                            [img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
    
    NSLog(@"  - File NAme %@",imgCleaned);
    // Grab the image off disk and load it up
    NSString *imageName = [[NSBundle mainBundle] 
                           pathForResource:imgCleaned
                           ofType:@"png" 
                           inDirectory:dir];
    NSLog(@" - - - Path\n %@\n",imageName);
    
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
    nextImage.frame = CGRectMake(10, 10, screenWidth-20, screenHeight-120);
    
    [self addSubview:nextImage];
    [nextImage release];

    

}
-(void)chooseMe
{
    NSLog(@"Choose this FACEPLATE");
    self.selected =YES;
}

#pragma mark - View lifecycle
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

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    
    //self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
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
