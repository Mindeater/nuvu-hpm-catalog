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

    //self.currentObject = obj;
    // NSLog(@"Mechanism  Loaded %@",self.parentProduct);
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    //CGFloat screenHeight = screenRect.size.height;
    
    //Product Name
    UILabel *myLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, screenWidth - 40, 100)];      
    myLabel.text = self.parentProduct;
    myLabel.textColor = [UIColor redColor];
    [self addSubview:myLabel];
    [myLabel release];
    
    //Picture/s
    
    for(NSManagedObject *mech in mechanisms){
        
        NSLog(@" ++ id:%@ count:%@",[mech valueForKey:@"id"],[mech valueForKey:@"count"] );
        NSString *img;
        if([[mech valueForKey:@"count"] intValue] == 1){
            // load the image based on the id
            img = [mech valueForKey:@"id"];
        }else{
            // build the image name
            img = [NSString stringWithFormat:@"%d-x-%@",
                             [mech valueForKey:@"count"],
                             [mech valueForKey:@"id"]];
        }
        //
        NSString *imageName = [[NSBundle mainBundle] pathForResource:img ofType:@"png"];
        
        UIImage *image = [UIImage imageWithContentsOfFile:imageName];
        UIImageView *nextImage = [[UIImageView alloc] initWithImage:image];
        NSLog(@" mechanism added %@ =\n%@",imageName,nextImage);
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
