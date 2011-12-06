//
//  SmallDisplay.m
//  Catalog2
//
//  Created by Ashley McCoy on 30/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "SmallDisplay.h"

@implementation SmallDisplay

CGRect backToOriginal;
UIView *popup;


- (void)dealloc {
    [super dealloc];
}

- (void)viewDidLoad {
    
    [self CreateSlideOut];
    [self slidePopup];
    [super viewDidLoad];
}


-(void) CreateSlideOut
{
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat startX = (screenWidth - 280)/2;
    CGFloat startY = (screenHeight - 420)/2;
    
    //CGRect frame=CGRectMake(0, CGRectGetMaxY(self.view.bounds), 280, 480);
    CGRect frame=CGRectMake(startX, startY, 280, 420);
    
    backToOriginal=frame;
    
    popup=[[UIView alloc]initWithFrame:frame];
    
    popup.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:popup];
    
}


-(void) slidePopup
{
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(60, 190, 200,40);
    button.backgroundColor=[UIColor clearColor];
    
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button setTitle:@"Dismiss" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(DismissClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    TextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 28, 240, 20)];
    TextField.delegate=self;
    TextField.autocorrectionType = UITextAutocorrectionTypeNo;
    [TextField setBackgroundColor:[UIColor clearColor]];
    [TextField setBorderStyle:UITextBorderStyleRoundedRect];
    
    [popup addSubview:TextField];
    [popup addSubview:button];
    
    //CGRect frame=CGRectMake(0, 0, 320, 480);
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    CGFloat startX = (screenWidth - 280)/2;
    CGFloat startY = (screenHeight - 420)/2;
    
    //CGRect frame=CGRectMake(0, CGRectGetMaxY(self.view.bounds), 280, 480);
    CGRect frame=CGRectMake(startX, startY, 280, 420);
    
    [UIView beginAnimations:nil context:nil];
    
    [popup setFrame:frame];
    
    [UIView commitAnimations];  
    
    
}

-(void) removePopUp

{   
    [UIView beginAnimations:nil context:nil];
    
    [popup setFrame:backToOriginal];
    
    [UIView commitAnimations];
    
    [TextField resignFirstResponder];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(IBAction) DismissClicked : (id) sender
{
    
    [self removePopUp];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    NSLog(@"in textFieldShouldReturn");
    [TextField resignFirstResponder];
    return YES;
}


@end
