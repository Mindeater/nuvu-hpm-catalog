//
//  MechanismView.m
//  Catalog2
//
//  Created by Ashley McCoy on 13/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "MechanismView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MechanismView


-(void)dealloc
{
    [parentProduct release];
    controlsView = nil;
    [super dealloc];
}

-(void)drawWithItems:(NSArray *)items
{
    // remove any views that already exist
    for (UIView *view in [self subviews]) { [view removeFromSuperview]; }
    
    // the Control View is going to hold the non-image elements
    controlsView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    //controlsView.layer.borderColor = [UIColor redColor].CGColor;
    [self addSubview:self.controlsView];
    //self.backgroundColor = [UIColor clearColor];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //Product Name
    UILabel *myLabel = [[UILabel alloc] 
                        initWithFrame:CGRectMake(20,screenHeight - 250, screenWidth - 40, 100)];      
    myLabel.text = self.parentProduct;
    myLabel.textColor = [UIColor whiteColor];
    myLabel.backgroundColor = [UIColor clearColor];
    [self.controlsView addSubview:myLabel];
    [myLabel release];
    
    // button to choose this one
    //CGRect buttonFrame = CGRectMake( 10, 80, 100, 30 );
    //UIButton *button = [[UIButton alloc] initWithFrame: buttonFrame];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 100, 100, 60);
    [button setTitle: @"OK" forState: UIControlStateNormal];
    [button setTitleColor: [UIColor redColor] forState: UIControlStateNormal];
    [button addTarget:self action:@selector(chooseMe) forControlEvents:UIControlEventTouchUpInside];
    [self.controlsView addSubview: button];
    
    // Mechanism Picture/s
    
    // note:
    //arteor 770 has AR in front of the part name which doesn't match the image
    for(NSManagedObject *mech in items){
        NSLog(@"%@\n\n ++ id:%@ count:%@ name: %@",
              self.parentProduct,[mech valueForKey:@"id"],
              [mech valueForKey:@"count"],
              [mech valueForKey:@"name"] );
        
        NSString *img;
        
        if([[mech valueForKey:@"count"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            // load the image based on the id screen the Arteor 770 fields
            if([[mech valueForKey:@"name"] isEqualToString:@"Mech 2 Part #"]){
                img = [[mech valueForKey:@"id"] 
                   stringByReplacingOccurrencesOfString:@"AR" withString:@""];
            }else{
                img = [mech valueForKey:@"id"];
            }
            
        }else{
            // mechanism with more than one part
            img = [NSString stringWithFormat:@"%@-x-%@",
                             [mech valueForKey:@"count"],
                             [[mech valueForKey:@"id"]
                              stringByReplacingOccurrencesOfString:@"AR" withString:@""]];
        }
        
        // Is is a frame ?
        NSString *dir;
        if([[mech valueForKey:@"name"] isEqualToString:@"Frame"]){
            dir = @"Frame";
        }else{
            dir = [NSString stringWithFormat:@"%@/Mechanism",
                                      [self.brandName stringByReplacingOccurrencesOfString:@" " withString:@""]];
        }
        
        NSLog(@" Directory %@",dir);
        NSString *imgCleaned = [NSString stringWithFormat:@"%@%@",
                                self.orientationPrefix,
                                [img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
        
        NSLog(@"  - File NAme %@",imgCleaned);
        // Grab the image off disk and load it up
        NSString *imageName = [[NSBundle mainBundle] 
                          pathForResource:imgCleaned
                          ofType:@"png" 
                          inDirectory:dir];
        /*
        NSString *imageName = [[NSBundle mainBundle] 
                               pathForResource:imgWithSubFolder
                               ofType:@"png"];
         */
        NSLog(@" FuLL image NAme:  %@",imageName);
        
        UIImage *image = [UIImage imageWithContentsOfFile:imageName];
        UIImageView *nextImage = [[UIImageView alloc] initWithImage:image];
        nextImage.backgroundColor = [UIColor clearColor];
        nextImage.contentMode = UIViewContentModeScaleAspectFit;
        nextImage.frame = CGRectMake(10, 10, screenWidth-20, screenHeight-120);
        nextImage.layer.borderColor = [[UIColor whiteColor] CGColor];
        nextImage.layer.borderWidth = 4.0;
        [self addSubview:nextImage];
        [nextImage release];
    }
   
    
    
}

-(void)chooseMe
{
    self.selected =YES;
}

// don't forget Quartz.Core with this method
-(UIImage *)getMechanismImage
{
    [self.controlsView removeFromSuperview];
    UIGraphicsBeginImageContext(self.bounds.size);
   // CALayer *myLayer = self.layer;
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
    return screenshot;
}

#pragma mark - View lifecycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    self.selected = NO;
    controlsView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    [self addSubview:self.controlsView];
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
