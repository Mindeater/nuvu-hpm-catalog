//
//  CollectInfoAlertView.m
//  Catalog2
//
//  Created by Ashley McCoy on 21/11/13.
//  Copyright (c) 2013 Mindeater Web Services. All rights reserved.
//

#import "CollectInfoAlertView.h"

@interface CollectInfoAlertView ()

@end


@implementation CollectInfoAlertView

@synthesize heading;
@synthesize subheading;
@synthesize entry_txt;
@synthesize qty_txt;
@synthesize buttonIndex;
@synthesize numberEntry;

- (void)dealloc
{
    [heading release];
    [subheading release];
    
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

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.buttonIndex =-1;
        self.numberEntry = NO;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
      okButtonTitle:(NSString *)okayButtonTitle
{
    if(self = [self init])
    {
        self.heading = [[[UILabel alloc] init] autorelease];
        [self.heading setText:title];
        [self.heading setFont:[UIFont boldSystemFontOfSize:23.0]];
        self.heading.textAlignment = UITextAlignmentCenter;
        self.subheading = [[[UILabel alloc] init] autorelease];
        [self.subheading setText:message];
        self.entry_txt = [[[UITextField alloc] initWithFrame:CGRectMake(0,self.subheading.frame.size.height,400,30)]autorelease];
        self.cancel_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.cancel_btn setTitle:cancelButtonTitle forState:UIControlStateNormal];
        self.cancel_btn.tag = 0;
        [self.cancel_btn addTarget:self action:@selector(buttonHit:) forControlEvents:UIControlEventTouchUpInside];
        self.ok_btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.ok_btn setTitle:okayButtonTitle forState:UIControlStateNormal];
        self.ok_btn.tag = 1;
        [self.ok_btn addTarget:self action:@selector(buttonHit:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    return self;
}

-(void)buttonHit:(id)sender
{
    UIButton *from = (UIButton *)sender;
    self.buttonIndex = from.tag;
}

-(void)setTextFieldStyle:(UIKeyboardType)type
{
    entry_txt.keyboardType = type;
}
- (void)show
{
    [entry_txt becomeFirstResponder];
    // NSLog(@"Presenting Alert Prompt");
}
- (NSString *)enteredText
{
    return entry_txt.text;
}
- (NSString *)enteredCount
{
    return qty_txt.text;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{

    NSCharacterSet* numberCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    for (int i = 0; i < [string length]; ++i)
    {
        unichar c = [string characterAtIndex:i];
        if (![numberCharSet characterIsMember:c])
        {
            return NO;
        }
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor whiteColor];
	// Do any additional setup after loading the view.
    CGFloat height = 5;
    self.heading.frame =CGRectMake(5, height, 290, 40);
    [self.view addSubview:self.heading];
    height += self.heading.frame.size.height;
    
    self.subheading.frame = CGRectMake(5, height, 290, 40);
    [self.view addSubview:self.subheading];
    height += self.subheading.frame.size.height;
    
    self.entry_txt.frame = CGRectMake(5, height, 290, 40);
    self.entry_txt.backgroundColor = [UIColor lightGrayColor];
    height += self.entry_txt.frame.size.height;
    
    if(self.numberEntry){
        UILabel *q_label = [[UILabel alloc] initWithFrame:CGRectMake(5, height, 140, 40)];
        [q_label setText:@"Quantity:"];
        [self.view addSubview:q_label];
        self.qty_txt = [[[UITextField alloc] initWithFrame:CGRectMake(150, height+5, 145, 30)] autorelease];
        self.qty_txt.delegate = self;
        self.qty_txt.backgroundColor = [UIColor lightGrayColor];
        [self.qty_txt setText:@"1"];
        [self.view addSubview:self.qty_txt];
        height += q_label.frame.size.height;
        [q_label release];
    }

    [self.view addSubview:self.entry_txt];
    
    self.cancel_btn.frame = CGRectMake(5, height, 140, 40);
    [self.view addSubview:self.cancel_btn];

    self.ok_btn.frame = CGRectMake(150, height, 140, 40);
    [self.view addSubview:self.ok_btn];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.entry_txt becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
