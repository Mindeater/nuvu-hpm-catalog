//
//  AlertPrompt.h
//  Catalog2
//
//  Created by Ashley McCoy on 20/12/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

//
//  AlertPrompt.h
//  Prompt
//
//  Created by Jeff LaMarche on 2/26/09.

#import <Foundation/Foundation.h>

@interface AlertPrompt : UIAlertView 
{
    UITextField *textField;
    
    NSInteger tag;
    
}
@property (nonatomic, retain) UITextField *textField;
@property (readonly) NSString *enteredText;
@property(nonatomic)NSInteger tag;

- (id)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle okButtonTitle:(NSString *)okButtonTitle;
-(void)setTextFieldStyle:(UIKeyboardType)type;
@end
