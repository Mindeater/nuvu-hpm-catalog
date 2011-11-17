//
//  FacePlateView.m
//  Catalog2
//
//  Created by Ashley McCoy on 13/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "FacePlateView.h"

@implementation FacePlateView

@synthesize parentProduct;
@synthesize selected;

-(void)dealloc
{
    [parentProduct release];
    [super dealloc];
}

-(void)drawWithFacePlates:(NSArray *)faceplates
{
    // remove any views that already exist
    for (UIView *view in [self subviews]) { [view removeFromSuperview]; }
    
    //self.backgroundColor = [UIColor clearColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //Product Name
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,screenHeight - 150, screenWidth - 40, 100)];      
    myLabel.text = self.parentProduct;
    myLabel.textColor = [UIColor redColor];
    [self addSubview:myLabel];
    [myLabel release];
    
    // button to choose this one
    //CGRect buttonFrame = CGRectMake( 10, 80, 100, 30 );
    //UIButton *button = [[UIButton alloc] initWithFrame: buttonFrame];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 100, 100, 60);
    [button setTitle: @"OK" forState: UIControlStateNormal];
    [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
    [button addTarget:self action:@selector(chooseMe) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview: button];
    
    // FacePlate Picture
    
    NSManagedObject *currentFacePlate = [faceplates lastObject];
    
    NSString *img = [currentFacePlate valueForKey:@"id"];
    // Grab the image off disk and load it up
    NSString *imageName = [[NSBundle mainBundle] 
                           pathForResource:[img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]
                           ofType:@"png"];
    
    UIImage *image = [UIImage imageWithContentsOfFile:imageName];
    UIImageView *nextImage = [[UIImageView alloc] initWithImage:image];
    nextImage.backgroundColor = [UIColor clearColor];
    nextImage.contentMode = UIViewContentModeScaleAspectFit;
    nextImage.frame = CGRectMake(20, 20, screenWidth -20, screenHeight - 20);
    
    [self addSubview:nextImage];
    [nextImage release];

    

}
-(void)chooseMe
{
    NSLog(@"Choose this");
    self.selected =YES;
}

#pragma mark - View lifecycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.selected = NO;
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
