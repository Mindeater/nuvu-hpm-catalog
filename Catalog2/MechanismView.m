//
//  MechanismView.m
//  Catalog2
//
//  Created by Ashley McCoy on 13/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "MechanismView.h"

@implementation MechanismView

// Deal with the NZ part name Mappings
#ifdef NZVERSION
@synthesize nz_map;
#endif

-(void)dealloc
{
    [categoryName release];
    controlsView = nil;
    [super dealloc];
}

-(void)drawWithItems:(NSArray *)items
{
    // the frame gets shortened somewhere so this makes sure it's the right size
    self.view.frame = [[UIScreen mainScreen] applicationFrame];
    //self.view.backgroundColor = [UIColor redColor];
    
    // remove any views that already exist
    for (UIView *view in [self.view subviews]) { [view removeFromSuperview]; }
    // self.view.backgroundColor = [UIColor whiteColor];

    ////////////////////////////////////////////////////////////
    // the Control View is going to hold the non-image elements
    if(!controlsView){
        controlsView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        controlsView.backgroundColor = [UIColor greenColor];

    }
   // controlsView.backgroundColor = [UIColor yellowColor];      
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;

    controlsView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [self.view addSubview:self.controlsView];
    
    /*
    NSLog(@" x: %f, y: %f, w: %f, y: %f \n END\n",
          controlsView.frame.origin.x,
          controlsView.frame.origin.y,
          controlsView.frame.size.width,
          controlsView.frame.size.height);
    */
    
   
    ///////////////////////
    // Mechanism Picture/s
    
    float cost = 0;
    NSMutableString *tmpParts = [NSMutableString stringWithString:@""];
    // note:
    //arteor 770 has AR in front of the part name which doesn't match the image
    for(NSManagedObject *mech in items){
        /*
        NSLog(@"\n+Mech Add+ \nCategory Name: %@\n Product NAme: %@\nMech id:%@\nMech count:%@\nMech name: %@\n\n",
              self.categoryName,
              self.productName,
              [mech valueForKey:@"id"],
              [mech valueForKey:@"count"],
              [mech valueForKey:@"name"] );
         */
        
        NSString *img;
        
        if([[mech valueForKey:@"count"] isEqualToNumber:[NSNumber numberWithInt:1]]){
            // load the image based on the id
            // screen the Arteor 770 fields
            if([[mech valueForKey:@"name"] isEqualToString:@"Mech 2 Part #"] && [self.brandName isEqualToString:@"Arteor 770"]){
                img = [[mech valueForKey:@"id"] 
                   stringByReplacingOccurrencesOfString:@"AR" withString:@""];
            }else{
                img = [mech valueForKey:@"id"];
                
            }
            
            cost += [[mech valueForKey:@"price"] floatValue];
        }else{
            // mechanism with more than one part
            
            // catch the Dedicated Plate mechanisms which have different images
           /* NSLog(@"[[[[[[ - %u v %u",
                  [[mech valueForKey:@"name"] rangeOfString:@"EXCEL LIFE DEDICATED PLATE"].location,
                  NSNotFound);
            */
            if([self.productName rangeOfString:@"EXCEL LIFE DEDICATED PLATE"].location == NSNotFound){
                img = [NSString stringWithFormat:@"%@-x-%@",
                       [mech valueForKey:@"count"],
                       [[mech valueForKey:@"id"]
                        stringByReplacingOccurrencesOfString:@"AR" withString:@""]];
                
            }else{
                img = [NSString stringWithFormat:@"%@-x-%@_ded",
                       [mech valueForKey:@"count"],
                       [[mech valueForKey:@"id"]
                        stringByReplacingOccurrencesOfString:@"AR" withString:@""]];
                //NSLog(@"CAUGHT DEdicateed item\n***\n");
            }
            
            cost += [[mech valueForKey:@"price"] floatValue] * [[mech valueForKey:@"count"]intValue];
        }
        
        self.price = [NSString stringWithFormat:@"%f",cost];
        
        // Deal with the NZ part name Mappings
#ifdef NZVERSION
        NSString *mapped_name = [self.nz_map objectForKey:img];
        if([mapped_name length] > 0)
        {
            [tmpParts appendFormat:@"%@\n",mapped_name];
        }else{
            [tmpParts appendFormat:@"%@\n",img];
        }
#else
        [tmpParts appendFormat:@"%@\n",img];
#endif
        
        
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
        float sY = (screenHeight - iHeight)/2.0 - adjustImagePositionY;
        
        //nextImage.frame = CGRectMake(80, 80, screenWidth-160, screenHeight-260);
        nextImage.frame = CGRectMake(sX, sY, iWidth, iHeight - adjustImageFrameHeightFactor);
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
    
// Deal with the NZ part name Mappings
#ifdef NZVERSION
    self.nz_map = [NSDictionary dictionaryWithContentsOfFile:
                   [[NSBundle mainBundle] pathForResource:@"nz_map" ofType:@"plist"] ];
    
#endif
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
