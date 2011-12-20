//
//  BackgroundLibrary.m
//  Catalog2
//
//  Created by Ashley McCoy on 18/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "BackgroundLibrary.h"

@implementation BackgroundLibrary

@synthesize button1,button2,button3,button4,button5,button6,button7,button8,button9;
@synthesize button10,button11,button12,button13,button14,button15,button16,button17;

@synthesize selected;
@synthesize buttonImages;
@synthesize selectedImage;
@synthesize bgList;

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
    self.bgList = [NSArray arrayWithObjects:
                                @"Paint_Sample_Chelsea_Green",
                                @"Paint_Sample_Foxdale",
                                @"Paint_Sample_Hog_Bristle_Half",
                                @"Paint_Sample_Pollywaffle",
                                @"Paint_Sample_Rapid_Fire",
                                @"Paint_Sample_Waterworks",
                                @"Paint_Sample_whitewall",
                                @"Paint_Sample_Woodland_Grey",
                                @"Wallpaper_blacktiles",
                                @"Wallpaper_charcoalemblem",
                                @"Wallpaper_curvedstone",
                                @"Wallpaper_graphitecaesar",
                                @"Wallpaper_lightcaesar",
                                @"Wallpaper_royalbrown",
                                @"Wallpaper_stripes",
                                @"Wallpaper_whitecaesar",
                                @"Wallpaper_whitetiles", nil];
    
    UIImage *img1 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:0]] ofType:@"jpg"]];
    UIImage *img2 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:1]] ofType:@"jpg"]]; 
    UIImage *img3 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:2]] ofType:@"jpg"]]; 
    UIImage *img4 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:3]] ofType:@"jpg"]]; 
    UIImage *img5 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:4]] ofType:@"jpg"]]; 
    UIImage *img6 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:5]] ofType:@"jpg"]]; 
    UIImage *img7 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:6]] ofType:@"jpg"]]; 
    UIImage *img8 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:7]] ofType:@"jpg"]]; 
    UIImage *img9 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:8]] ofType:@"jpg"]]; 
    UIImage *img10 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:9]] ofType:@"jpg"]]; 
    UIImage *img11 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:10]] ofType:@"jpg"]]; 
    UIImage *img12 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:11]] ofType:@"jpg"]]; 
    UIImage *img13 = [UIImage imageWithContentsOfFile:
                      [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:12]] ofType:@"jpg"]]; 
    UIImage *img14 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:13]] ofType:@"jpg"]]; 
    UIImage *img15 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:14]] ofType:@"jpg"]]; 
    UIImage *img16 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:15]] ofType:@"jpg"]]; 
    UIImage *img17 = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"%@_tmb",[bgList objectAtIndex:16]] ofType:@"jpg"]]; 
    
       
    button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    button6 = [UIButton buttonWithType:UIButtonTypeCustom];
    button7 = [UIButton buttonWithType:UIButtonTypeCustom];
    button8 = [UIButton buttonWithType:UIButtonTypeCustom];
    button9 = [UIButton buttonWithType:UIButtonTypeCustom];
    button10 = [UIButton buttonWithType:UIButtonTypeCustom];
    button11 = [UIButton buttonWithType:UIButtonTypeCustom];
    button12 = [UIButton buttonWithType:UIButtonTypeCustom];
    button13 = [UIButton buttonWithType:UIButtonTypeCustom];
    button14 = [UIButton buttonWithType:UIButtonTypeCustom];
    button15 = [UIButton buttonWithType:UIButtonTypeCustom];
    button16 = [UIButton buttonWithType:UIButtonTypeCustom];
    button17 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button1.tag =0;
    button2.tag =1;
    button3.tag =2;
    button4.tag =3;
    button5.tag =4;
    button6.tag =5;
    button7.tag =6;
    button8.tag =7;
    button9.tag =8;
    button10.tag =9;
    button11.tag =10;
    button12.tag =11;
    button13.tag =12;
    button14.tag =13;
    button15.tag =14;
    button16.tag =15;
    button17.tag =16;

    
    [button1 setImage:img1 forState:UIControlStateNormal];
    [button2 setImage:img2 forState:UIControlStateNormal];
    [button3 setImage:img3 forState:UIControlStateNormal];
    [button4 setImage:img4 forState:UIControlStateNormal];
    [button5 setImage:img5 forState:UIControlStateNormal];
    [button6 setImage:img6 forState:UIControlStateNormal];
    [button7 setImage:img7 forState:UIControlStateNormal];
    [button8 setImage:img8 forState:UIControlStateNormal];
    [button9 setImage:img9 forState:UIControlStateNormal];
    [button10 setImage:img10 forState:UIControlStateNormal];
    [button11 setImage:img11 forState:UIControlStateNormal];
    [button12 setImage:img12 forState:UIControlStateNormal];
    [button13 setImage:img13 forState:UIControlStateNormal];
    [button14 setImage:img14 forState:UIControlStateNormal];
    [button15 setImage:img15 forState:UIControlStateNormal];
    [button16 setImage:img16 forState:UIControlStateNormal];
    [button17 setImage:img17 forState:UIControlStateNormal];
    
    [button1 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button3 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button4 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button5 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button6 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button7 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button8 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button9 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button10 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button11 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button12 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button13 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button14 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button15 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button16 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];
    [button17 addTarget:self action:@selector(chooseImage:) forControlEvents:UIControlEventTouchUpInside];

    
    self.buttonImages = [NSArray arrayWithObjects:img1,img2,img3,img4,img5,img6,img7,img8,img9,
                         img10,img11,img12,img13,img14,img15,img16,img17, nil];
    
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
    [self.view addSubview:button13];
    [self.view addSubview:button14];
    [self.view addSubview:button15];
    [self.view addSubview:button16];
    [self.view addSubview:button17];
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
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        pad = 10;
        //buttonWidth = 80;
        //buttonHeight = 80;
    }
    float buttonWidth = screenWidth / 4 - pad*3;
    float buttonHeight = buttonWidth; //screenHeight / 3 - pad*2;
    float startX = (screenWidth - (4 * buttonWidth + pad * 2))/2;
    float startY = (screenHeight -(3 * buttonHeight+pad))/8;
    
    // row 1
    button1.frame =  CGRectMake(startX,                               startY,
                                buttonWidth, buttonHeight);
    button2.frame =  CGRectMake(startX + buttonWidth+pad,             startY,
                                buttonWidth, buttonHeight);
    button3.frame =  CGRectMake((startX + (buttonWidth * 2.0))+2*pad, startY,
                                buttonWidth, buttonHeight);
    button4.frame =  CGRectMake((startX + (buttonWidth * 3.0))+3*pad, startY,
                                buttonWidth, buttonHeight);
    // row 2
    button5.frame =  CGRectMake(startX,                        startY + buttonHeight+pad,
                                buttonWidth, buttonHeight);
    button6.frame =  CGRectMake(startX+ buttonWidth +pad,      startY + buttonHeight+pad,
                                buttonWidth, buttonHeight);
    button7.frame =  CGRectMake(startX + buttonHeight*2+2*pad, startY + buttonHeight+pad,
                                buttonWidth, buttonHeight);
    button8.frame =  CGRectMake(startX + buttonHeight*3+3*pad, startY + buttonHeight+pad,
                                buttonWidth, buttonHeight);
    //row 3
    button9.frame =  CGRectMake(startX,                         startY + buttonHeight*2+2*pad,
                                buttonWidth, buttonHeight);
    button10.frame =  CGRectMake(startX+ buttonWidth +pad,      startY + buttonHeight*2+2*pad,
                                buttonWidth, buttonHeight);
    button11.frame =  CGRectMake(startX + buttonHeight*2+2*pad, startY + buttonHeight*2+2*pad,
                                buttonWidth, buttonHeight);
    button12.frame =  CGRectMake(startX + buttonHeight*3+3*pad, startY + buttonHeight*2+2*pad,
                                buttonWidth, buttonHeight);
    //row 4
    button13.frame =  CGRectMake(startX,                         startY + buttonHeight*3+3*pad,
                                buttonWidth, buttonHeight);
    button14.frame =  CGRectMake(startX+ buttonWidth +pad,      startY + buttonHeight*3+3*pad,
                                 buttonWidth, buttonHeight);
    button15.frame =  CGRectMake(startX + buttonHeight*2+2*pad, startY + buttonHeight*3+3*pad,
                                 buttonWidth, buttonHeight);
    button16.frame =  CGRectMake(startX + buttonHeight*3+3*pad, startY + buttonHeight*3+3*pad,
                                 buttonWidth, buttonHeight);
    //row 5
    button17.frame =  CGRectMake(startX,                         startY + buttonHeight*4+4*pad,
                                buttonWidth, buttonHeight);
    
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self layoutButtons:toInterfaceOrientation];
    
}

-(void)chooseImage:(id)sender
{
    UIButton *resultButton = (UIButton *)sender;
     self.selectedImage = [UIImage imageWithContentsOfFile:
                           [[NSBundle mainBundle] pathForResource:[self.bgList objectAtIndex:resultButton.tag] ofType:@"jpg"]];
                           
    self.selected = YES;
    
    NSLog(@"Hi The Button %i",resultButton.tag);
    /*
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
    */
    
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
    self.button1  = nil;
    self.button2  = nil;
    self.button3  = nil;
    self.button4  = nil;
    self.button5  = nil;
    self.button6  = nil;
    self.button7  = nil;
    self.button8  = nil;
    self.button9  = nil;
    self.button10 = nil;
    self.button11 = nil;
    self.button12 = nil;
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;// for supported orientations
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
