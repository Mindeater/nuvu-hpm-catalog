//
//  CollectInfoAlertView.h
//  Catalog2
//
//  Created by Ashley McCoy on 21/11/13.
//  Copyright (c) 2013 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectInfoAlertView : UIViewController <UITextFieldDelegate>

@property(nonatomic,retain)UILabel *heading;
@property(nonatomic,retain)UILabel *subheading;
@property(nonatomic, retain)UITextField *entry_txt;
@property(nonatomic, retain)UITextField *qty_txt;
@property(nonatomic)CGFloat buttonIndex;
@property(nonatomic, retain)UIButton *cancel_btn;
@property(nonatomic, retain)UIButton *ok_btn;
@property(nonatomic)CGFloat tag;
@property(nonatomic)BOOL numberEntry;



- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
           delegate:(id)delegate
  cancelButtonTitle:(NSString *)cancelButtonTitle
      okButtonTitle:(NSString *)okayButtonTitle;

-(void)setTextFieldStyle:(UIKeyboardType)type;
- (NSString *)enteredText;
- (NSString *)enteredCount;

-(void)buttonHit:(id)sender;

@end
