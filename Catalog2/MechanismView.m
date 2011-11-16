//
//  MechanismView.m
//  Catalog2
//
//  Created by Ashley McCoy on 13/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "MechanismView.h"

@implementation MechanismView

@synthesize parentProduct;


-(void)drawWithMechanisms:(NSArray *)mechanisms
{
    // remove any views that already exist
    for (UIView *view in [self subviews]) { [view removeFromSuperview]; }
    
    self.backgroundColor = [UIColor clearColor];
    NSLog(@"Mechanism  Loaded %@",mechanisms);
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    //Product Name
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(20,screenHeight - 150, screenWidth - 40, 100)];      
    myLabel.text = self.parentProduct;
    myLabel.textColor = [UIColor redColor];
    [self addSubview:myLabel];
    [myLabel release];
    
    //Picture/s
    NSLog(@"****  \n\n\n\n\n");
    
    // note:
    //arteor 770 has AR in front of the part name which doesn't match the image
    for(NSManagedObject *mech in mechanisms){
        
        NSLog(@"%@\n\n ++ id:%@ count:%@ name: %@",self.parentProduct,[mech valueForKey:@"id"],[mech valueForKey:@"count"],[mech valueForKey:@"name"] );
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
            // build the image name
            
            
            img = [NSString stringWithFormat:@"%@-x-%@",
                             [mech valueForKey:@"count"],
                             [[mech valueForKey:@"id"]
                              stringByReplacingOccurrencesOfString:@"AR" withString:@""]];
        }
        //
        NSLog(@"  - image name is %@",[img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]);
        NSString *imageName = [[NSBundle mainBundle] 
                               pathForResource:[img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]
                               ofType:@"png"];
        
        UIImage *image = [UIImage imageWithContentsOfFile:imageName];
        UIImageView *nextImage = [[UIImageView alloc] initWithImage:image];
        nextImage.backgroundColor = [UIColor clearColor];
        // calculate it's size
        nextImage.contentMode = UIViewContentModeScaleAspectFit;
        //int width = image.size.width 
        nextImage.frame = CGRectMake(20, 20, screenWidth -20, screenHeight - 20);
        //NSLog(@" mechanism picture added %@ =\n\n\n",imageName);
        [self addSubview:nextImage];
        [nextImage release];
        
        
    }
    /*
    NSString *imageName = [[NSBundle mainBundle] pathForResource:pListName ofType:@"png"];
    UIImage *image = [UIImage imageWithContentsOfFile:imageName];
     */
}



#pragma mark - View lifecycle
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
