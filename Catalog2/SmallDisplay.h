//
//  SmallDisplay.h
//  Catalog2
//
//  Created by Ashley McCoy on 30/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SmallDisplay : UIViewController <UIActionSheetDelegate, UITextFieldDelegate> {
    
    UITextField *TextField;
    
}

-(void) CreateSlideOut;
-(void) removePopUp;
-(void) slidePopup;
@end
