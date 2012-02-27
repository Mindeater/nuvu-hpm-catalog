//
//  MechanismView.m
//  Catalog2
//
//  Created by Ashley McCoy on 13/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "MechanismView.h"

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
    // self.view.backgroundColor = [UIColor whiteColor];

    ////////////////////////////////////////////////////////////
    // the Control View is going to hold the non-image elements
    if(!controlsView){
        controlsView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    }
   // controlsView.backgroundColor = [UIColor yellowColor];      
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
  
    controlsView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.view addSubview:self.controlsView]; 
   
    ///////////////////////
    // Mechanism Picture/s
    
    float cost = 0;
    NSMutableString *tmpParts = [NSMutableString stringWithString:@""];
    // note:
    //arteor 770 has AR in front of the part name which doesn't match the image
    for(NSManagedObject *mech in items){
        /*
        NSLog(@"\n+Mech Add+ \n%@\n name: %@\nid:%@ count:%@ name: %@\n\n",
              self.categoryName,
              self.productName,
              [mech valueForKey:@"id"],
              [mech valueForKey:@"count"],
              [mech valueForKey:@"name"] );
         */
        
        NSString *img;
        
        if([[mech valueForKey:@"count"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            // load the image based on the id screen the Arteor 770 fields
            if([[mech valueForKey:@"name"] isEqualToString:@"Mech 2 Part #"] && [self.brandName isEqualToString:@"Arteor 770"]){
                img = [[mech valueForKey:@"id"] 
                   stringByReplacingOccurrencesOfString:@"AR" withString:@""];
            }else{
                img = [mech valueForKey:@"id"];
            }
            
            cost += [[mech valueForKey:@"price"] floatValue];
        }else{
            // mechanism with more than one part
            img = [NSString stringWithFormat:@"%@-x-%@",
                             [mech valueForKey:@"count"],
                             [[mech valueForKey:@"id"]
                              stringByReplacingOccurrencesOfString:@"AR" withString:@""]];
            cost += [[mech valueForKey:@"price"] floatValue] * [[mech valueForKey:@"count"]intValue];
        }
        
        self.price = [NSString stringWithFormat:@"%f",cost];
        
        [tmpParts appendFormat:@"%@\n",img];
        
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
        
        NSString *imgCleaned = [NSString stringWithFormat:@"%@%@",
                                prefix,
                                [img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
        
        
                
        // Grab the image off disk and load it up
        NSString *imageName = [[NSBundle mainBundle] 
                          pathForResource:imgCleaned
                          ofType:@"png" 
                          inDirectory:dir];
        
        UIImage *image = [UIImage imageWithContentsOfFile:imageName];
        UIImageView *nextImage = [[UIImageView alloc] initWithImage:image];
        nextImage.backgroundColor = [UIColor clearColor];
        nextImage.contentMode = UIViewContentModeScaleAspectFit;
        
        //nextImage.frame = CGRectMake(40, 40, screenWidth-80, screenHeight-180);
        float iWidth = screenWidth * 0.8;
        float iHeight = screenHeight * 0.8;
        float sX = (screenWidth -iWidth)/2.0;
        float sY = (screenHeight - iHeight)/2.0 - 60;
        
        //nextImage.frame = CGRectMake(80, 80, screenWidth-160, screenHeight-260);
        nextImage.frame = CGRectMake(sX, sY, iWidth, iHeight- 100.0);
        /*
        nextImage.layer.borderColor = [[UIColor whiteColor] CGColor];
        nextImage.layer.borderWidth = 4.0;
         */
        [self.view addSubview:nextImage];
        [nextImage release];
    }
    self.parts = tmpParts;
    [self addToolBarToView];
    
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
