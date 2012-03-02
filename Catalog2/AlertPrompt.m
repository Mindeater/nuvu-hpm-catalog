//
//  AlertPrompt.m
//  Catalog2
//
//  Created by Ashley McCoy on 20/12/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

//
//  AlertPrompt.m
//  Prompt
//
//  Created by Jeff LaMarche on 2/26/09.

#import "AlertPrompt.h"

@implementation AlertPrompt

@synthesize textField;
@synthesize enteredText;
@synthesize tag;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okayButtonTitle
{
    
    if (self = [super initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:okayButtonTitle, nil])
    {
        UITextField *theTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)]; 
        [theTextField setBackgroundColor:[UIColor whiteColor]]; 
        
        [self addSubview:theTextField];
        self.textField = theTextField;
        [theTextField release];
        // this moves the box up a bit - nice on the iPAd but clips the dialog on the iphone
        
        CGAffineTransform translate = CGAffineTransformMakeTranslation(0.0, 10.0); 
        [self setTransform:translate];
    }
    return self;
}
-(void)setTextFieldStyle:(UIKeyboardType)type
{
    textField.keyboardType = type;
}
- (void)show
{
    [textField becomeFirstResponder];
   // NSLog(@"Presenting Alert Prompt");
    [super show];
}
- (NSString *)enteredText
{
    return textField.text;
}
- (void)dealloc
{
    [textField release];
    [super dealloc];
}
@end
