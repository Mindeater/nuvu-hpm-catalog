//
//  OrderLineModal.m
//  Catalog2
//
//  Created by Ashley McCoy on 2/02/12.
//  Copyright (c) 2012 Mindeater Web Services. All rights reserved.
//

#import "OrderLineModal.h"

@implementation OrderLineModal

@synthesize context = _context;
@synthesize orderLineManagedObject;
@synthesize sizeRect;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

-(void)tapped:(id)sender {
    NSLog(@"TAPPED");
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    //self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]autorelease];
    self.view = [[[UIView alloc] initWithFrame:self.sizeRect] autorelease];
    //self.view.frame = self.view.superview.frame;
    // NSLog(@"Starting View with %@",NSStringFromCGRect(self.view.frame));
    ////////////////////////////////////
    // the gesture recongniser
    UITapGestureRecognizer *tapProfileImageRecognizer = [[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)] autorelease];
    [tapProfileImageRecognizer setNumberOfTapsRequired:1];
    [tapProfileImageRecognizer setDelegate:self];
    [self.view addGestureRecognizer:tapProfileImageRecognizer];
    
    
    //////////////////////////////////////////////////////
    // get the images for the parts and load them onscreen
    
    UIView *finalProduct = [[UIView alloc]initWithFrame:self.sizeRect];
    finalProduct.contentMode = UIViewContentModeScaleAspectFit;
    UIImageView *faceplateView= [[UIImageView alloc] init];
    UIImageView *mechanismView;
    
    NSLog(@"iterating through %@",[self.orderLineManagedObject valueForKey:@"items"]); 
    
    
    for(NSManagedObject *part in [self.orderLineManagedObject valueForKey:@"items"]){
        if([[part valueForKey:@"type"] isEqualToString:@"Mechanism"]){ // mechanisms
            
            UIImage *mechanism = [self getMechanismImage:[part valueForKey:@"mechanism"]];
            
            mechanismView = [[UIImageView alloc]initWithImage:mechanism];
            mechanismView.frame = self.sizeRect;
            mechanismView.backgroundColor = [UIColor clearColor];
            mechanismView.contentMode = UIViewContentModeScaleAspectFit;
            [finalProduct addSubview:mechanismView];
            if([[[part valueForKey:@"mechanism"]valueForKey:@"name"] isEqualToString:@"Frame"]){
                [finalProduct sendSubviewToBack:mechanismView];
            }
            [mechanismView release];
            
        }else{ // faceplate
            
            UIImage *faceplate = [self getFacePlateImage:[part valueForKey:@"faceplate"]];
            //faceplateView = [[UIImageView alloc]initWithImage:faceplate];
            faceplateView.image = faceplate;
            faceplateView.backgroundColor = [UIColor clearColor];
            faceplateView.frame = self.sizeRect;
            faceplateView.contentMode = UIViewContentModeScaleAspectFit;
            
            
        }
        
    }
    
    [finalProduct addSubview:faceplateView];
    [finalProduct bringSubviewToFront:faceplateView];
    [faceplateView release];
    
    [self.view addSubview:finalProduct];
    [finalProduct release];
}

-(UIImage *)getMechanismImage:(NSManagedObject *)item
{
    NSString *img;// = [item valueForKey:@"id"];
    
    //NSLog(@"Mechanism :\n%@\n\n",item);
    
    NSString *brandName = [[[item valueForKey:@"product"] valueForKey:@"brand"] valueForKey:@"name"];
    NSString *orientationPrefix;
    NSString *orientation= [[item valueForKey:@"product"] valueForKey:@"orientation"];
    
    if([orientation isEqualToString:@"Horizontal"]){
        orientationPrefix = @"h-";
    }else if([orientation isEqualToString:@"Vertical"]){
        orientationPrefix = [NSString stringWithString:@"v-"];
    }else{
        orientationPrefix = [NSString stringWithString:@""];
    }
    
   
    if([[item valueForKey:@"count"] intValue] > 1){
        // mechanism with more than one part
        img = [NSString stringWithFormat:@"%@-x-%@",
               [item valueForKey:@"count"],
               [[item valueForKey:@"id"]
                stringByReplacingOccurrencesOfString:@"AR" withString:@""]];
    }else{
        // load the image based on the id screen the Arteor 770 fields
        if([[item valueForKey:@"name"] isEqualToString:@"Mech 2 Part #"] && [brandName isEqualToString:@"Arteor 770"]){
            img = [[item valueForKey:@"id"] 
                   stringByReplacingOccurrencesOfString:@"AR" withString:@""];
        }else{
            img = [item valueForKey:@"id"];
        }

    }
    
    
    // Build the Directory string
    NSString *dir;
    NSString *prefix = orientationPrefix;
    if([[item valueForKey:@"name"] isEqualToString:@"Frame"]){
        dir = @"Frames";
        // remove prefix for frames
        prefix = @"";
    }else{
        dir = [NSString stringWithFormat:@"%@/Mechanism",
               [brandName stringByReplacingOccurrencesOfString:@" " withString:@""]];
    }
    
    //NSLog(@" Directory %@ \nWith Orientation: %@",dir,prefix);
    NSString *imgCleaned = [NSString stringWithFormat:@"%@%@",
                            prefix,
                            [img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
    
    
    // Grab the image off disk and load it up
    NSString *imageName = [[NSBundle mainBundle] 
                           pathForResource:imgCleaned
                           ofType:@"png" 
                           inDirectory:dir];
    UIImage *found = [UIImage imageWithContentsOfFile:imageName];
   
    //UIImage *image = [[[UIImage alloc] init]autorelease];
    return found;
    
}


-(UIImage *)getFacePlateImage:(NSManagedObject *)item
{
    /////////////////////////////////////
    // Build the file path and image name
    NSString *img = [item valueForKey:@"id"];
    
   // NSLog(@"CoverPlate :\n%@\n\nNAme:%@\n\nProduct : %@\n",item,img,[[[item valueForKey:@"product"] valueForKey:@"brand"] valueForKey:@"name"]);
    
    NSString *brandName = [[[item valueForKey:@"product"] valueForKey:@"brand"] valueForKey:@"name"];
    NSString *orientationPrefix;
    NSString *orientation= [[item valueForKey:@"product"] valueForKey:@"orientation"];
    
    if([orientation isEqualToString:@"Horizontal"]){
        orientationPrefix = @"h-";
    }else if([orientation isEqualToString:@"Vertical"]){
        orientationPrefix = [NSString stringWithString:@"v-"];
    }else{
        orientationPrefix = [NSString stringWithString:@""];
    }
    //NSLog(@"\n\nCoverplate has been passed :: \n\n\n %@",items);
    
    NSString *dir = [NSString stringWithFormat:@"%@/Faceplate",
                     [brandName stringByReplacingOccurrencesOfString:@" " withString:@""]];
    
    NSString *imgCleaned = [NSString stringWithFormat:@"%@%@",
                            orientationPrefix,
                            [img stringByReplacingOccurrencesOfString:@"/" withString:@"-"]];
    
    NSString *imageName = [[NSBundle mainBundle] 
                           pathForResource:imgCleaned
                           ofType:@"png" 
                           inDirectory:dir];
    
    /////////////////////////////////////////
    // Grab the image off disk and load it up
    
    UIImage *image = [UIImage imageWithContentsOfFile:imageName];
    //UIImageView *nextImage = [[UIImageView alloc] initWithImage:image];
    //nextImage.backgroundColor = [UIColor clearColor];
    //nextImage.contentMode = UIViewContentModeScaleAspectFit;
    
    //UIImage *image = [[[UIImage alloc] init]autorelease];
    return image;
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
