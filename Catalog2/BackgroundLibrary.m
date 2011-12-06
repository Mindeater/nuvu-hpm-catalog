//
//  BackgroundLibrary.m
//  Catalog2
//
//  Created by Ashley McCoy on 18/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "BackgroundLibrary.h"

@implementation BackgroundLibrary

@synthesize button1,button2,button3,button4,button5,button6,button7,button8,button9,button10,button11,button12;

@synthesize selected;
@synthesize buttonImages;
@synthesize selectedImage;

-(void)dealloc
{
    //self.view = nil;
    [buttonImages release];
    [super dealloc];
}

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

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]]autorelease];
    self.view.backgroundColor = [UIColor blackColor];
    [self.navigationController setNavigationBarHidden:NO animated:YES];

    self.title = @"Backgrounds";
    
    //create 12 buttons and use the background images
    
    
    UIImage *img1 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"Arteor_caesarstone_metallic" ofType:@"png"]]; 
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setImage:img1 forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img2 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"Arteor_caesarstone_white" ofType:@"png"]]; 
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setImage:img2 forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img3 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"Arteor_renderedwall_blue" ofType:@"png"]]; 
    button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button3 setImage:img3 forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img4 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"Arteor_renderedwall_brown" ofType:@"png"]]; 
    button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button4 setImage:img4 forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img5 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"Arteor_renderedwall_cream" ofType:@"png"]]; 
    button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button5 setImage:img5 forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img6 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"Arteor_renderedwall_green" ofType:@"png"]]; 
    button6 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button6 setImage:img6 forState:UIControlStateNormal];
    [button6 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img7 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"Arteor_renderedwall_grey" ofType:@"png"]]; 
    button7 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button7 setImage:img7 forState:UIControlStateNormal];
    [button7 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img8 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"Arteor_renderedwall_red" ofType:@"png"]]; 
    button8 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button8 setImage:img8 forState:UIControlStateNormal];
    [button8 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img9 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"Arteor_renderedwall_white" ofType:@"png"]]; 
    button9 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button9 setImage:img9 forState:UIControlStateNormal];
    [button9 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img10 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"Arteor_tiles_black" ofType:@"png"]]; 
    button10 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button10 setImage:img10 forState:UIControlStateNormal];
    [button10 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img11 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"Arteor_wallpaper_ancient" ofType:@"png"]]; 
    button11 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button11 setImage:img11 forState:UIControlStateNormal];
    [button11 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImage *img12 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:@"Arteor_wallpaper_floral" ofType:@"png"]]; 
    button12 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button12 setImage:img12 forState:UIControlStateNormal];
    [button12 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    self.buttonImages = [NSArray arrayWithObjects:img1,img2,img3,img4,img5,img6,img7,img8,img9,img10,img11,img12, nil];
    
    [self layoutButtons: [[UIApplication sharedApplication] statusBarOrientation]];
    
    [self.view addSubview:button1];
    [self.view addSubview:button2];
    [self.view addSubview:button3];
    [self.view addSubview:button4];
    [self.view addSubview:button5];
    [self.view addSubview:button6];
    [self.view addSubview:button7];
    [self.view addSubview:button8];
    [self.view addSubview:button9];
    [self.view addSubview:button10];
    [self.view addSubview:button11];
    [self.view addSubview:button12];
    
}


-(void)layoutButtons:(UIInterfaceOrientation)toInterfaceOrientation
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        screenWidth = screenRect.size.height;
        screenHeight = screenRect.size.width;
    }
    
    float pad = 20;
    float buttonWidth = screenWidth / 4 - pad*3;
    float buttonHeight = buttonWidth; //screenHeight / 3 - pad*2;
    float startX = (screenWidth - (4 * buttonWidth + pad * 2))/2;
    float startY = (screenHeight -(3 * buttonHeight+pad))/8;
    
    button1.frame =  CGRectMake(startX,                               startY,
                                buttonWidth, buttonHeight);
    button2.frame =  CGRectMake(startX + buttonWidth+pad,             startY,
                                buttonWidth, buttonHeight);
    button3.frame =  CGRectMake((startX + (buttonWidth * 2.0))+2*pad, startY,
                                buttonWidth, buttonHeight);
    button4.frame =  CGRectMake((startX + (buttonWidth * 3.0))+3*pad, startY,
                                buttonWidth, buttonHeight);
    
    button5.frame =  CGRectMake(startX,                        startY + buttonHeight+pad,
                                buttonWidth, buttonHeight);
    button6.frame =  CGRectMake(startX+ buttonWidth +pad,      startY + buttonHeight+pad,
                                buttonWidth, buttonHeight);
    button7.frame =  CGRectMake(startX + buttonHeight*2+2*pad, startY + buttonHeight+pad,
                                buttonWidth, buttonHeight);
    button8.frame =  CGRectMake(startX + buttonHeight*3+3*pad, startY + buttonHeight+pad,
                                buttonWidth, buttonHeight);
    
    button9.frame =  CGRectMake(startX,                         startY + buttonHeight*2+2*pad,
                                buttonWidth, buttonHeight);
    button10.frame =  CGRectMake(startX+ buttonWidth +pad,      startY + buttonHeight*2+2*pad,
                                buttonWidth, buttonHeight);
    button11.frame =  CGRectMake(startX + buttonHeight*2+2*pad, startY + buttonHeight*2+2*pad,
                                buttonWidth, buttonHeight);
    button12.frame =  CGRectMake(startX + buttonHeight*3+3*pad, startY + buttonHeight*2+2*pad,
                                buttonWidth, buttonHeight);
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutButtons:toInterfaceOrientation];
    
}

-(void)chooseImage:(id)sender
{
    NSLog(@"Hi The Button %@",sender);
     
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    
    [self.view bringSubviewToFront:sender];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1];
    //theButton.alpha = 0;
    UIButton * button = (UIButton *)sender;
    button.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    [UIView commitAnimations];
    
    [self performSelector:@selector(nextView:) withObject:sender afterDelay:2.0];
    
    
}

-(void)nextView:(id)sender
{
    NSLog(@"OK");
    
    UIButton *resultButton = (UIButton *)sender;
    self.selectedImage = resultButton.currentImage;
    self.selected = YES;
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
    self.button1 =nil;
    self.button2 =nil;
    self.button3 =nil;
    self.button4 =nil;
    self.button5 =nil;
    self.button6 =nil;
    self.button7 =nil;
    self.button8 =nil;
    self.button9 =nil;
    self.button10 =nil;
    self.button11 =nil;
    self.button12 =nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;// for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
