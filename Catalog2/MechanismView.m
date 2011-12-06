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
    [categoryName release];
    controlsView = nil;
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
    
    ///////////////////////////////////
    //Product Label
    UILabel *myLabel = [[UILabel alloc] 
                        initWithFrame:CGRectMake(20,screenHeight - 250, screenWidth - 40, 100)]; 
                       // initWithFrame:CGRectMake(20,20, 400, 100)];      
    myLabel.text = self.productName;
    myLabel.textColor = [UIColor whiteColor];
    myLabel.backgroundColor = [UIColor clearColor];
    [self.controlsView addSubview:myLabel];
    [myLabel release];
    
    ///////////////////////////////
    // button to choose this one
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(10, 0, 50, 30);
    [button setTitle: @"ok" forState: UIControlStateNormal];
    [button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
    [button addTarget:self action:@selector(chooseMe) forControlEvents:UIControlEventTouchUpInside];
    [self.controlsView addSubview: button];
    
    // Mechanism Picture/s
    
    // note:
    //arteor 770 has AR in front of the part name which doesn't match the image
    for(NSManagedObject *mech in items){
        NSLog(@"\n+Mech Add+ \n%@\n name: %@\nid:%@ count:%@ name: %@\n\n",
              self.categoryName,
              self.productName,
              [mech valueForKey:@"id"],
              [mech valueForKey:@"count"],
              [mech valueForKey:@"name"] );
        
        NSString *img;
        
        if([[mech valueForKey:@"count"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            // load the image based on the id screen the Arteor 770 fields
            if([[mech valueForKey:@"name"] isEqualToString:@"Mech 2 Part #"] && [self.brandName isEqualToString:@"Arteor 770"]){
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
        
        // Build the Directory string
        NSString *dir;
        NSString *prefix = self.orientationPrefix;
        if([[mech valueForKey:@"name"] isEqualToString:@"Frame"]){
            dir = @"Frames";
            // remove prefix for frames
            prefix = @"";
        }else{
            dir = [NSString stringWithFormat:@"%@/Mechanism",
                                      [self.brandName stringByReplacingOccurrencesOfString:@" " withString:@""]];
        }
        
        //NSLog(@" Directory %@ \nWith Orientation: %@",dir,prefix);
        NSString *imgCleaned = [NSString stringWithFormat:@"%@%@",
                                prefix,
                                [img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
        
        //NSLog(@"  - File NAme %@",imgCleaned);
        
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
        
        //nextImage.frame = CGRectMake(40, 40, screenWidth-80, screenHeight-180);
        float iWidth = screenWidth * 0.8;
        float iHeight = screenHeight * 0.8;
        float sX = (screenWidth -iWidth)/2.0;
        float sY = (screenHeight - iHeight)/2.0;
        
        //nextImage.frame = CGRectMake(80, 80, screenWidth-160, screenHeight-260);
        nextImage.frame = CGRectMake(sX, sY, iWidth, iHeight- 100.0);
        /*
        nextImage.layer.borderColor = [[UIColor whiteColor] CGColor];
        nextImage.layer.borderWidth = 4.0;
         */
        [self.view addSubview:nextImage];
        [nextImage release];
    }
   
    [self addToolBarToView];
}

-(void)chooseMe
{
    self.selected =YES;
}

// don't forget Quartz.Core with this method
-(UIImage *)getMechanismImage
{
    [self.controlsView removeFromSuperview];
    UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(screenshot, nil, nil, nil);
    return screenshot;
}

#pragma mark - View lifecycle
/*
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
*/
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];

    //controlsView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    /*
     // Add a view cause there ain't no nib
     //self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    [view setAutoresizingMask:UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth];
    [view setBackgroundColor:[UIColor blueColor]];
    self.view = view;
    [view release];
    */    
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
