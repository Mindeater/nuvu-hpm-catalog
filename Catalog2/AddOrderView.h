//
//  AddOrderView.h
//  Catalog2
//
//  Created by Ashley McCoy on 29/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddOrderView : UIViewController <UITextFieldDelegate>{ 
    NSManagedObjectContext *context;
    UITextField *suppliedName;
}

@property(nonatomic,retain)NSManagedObjectContext *context;
@property(nonatomic,retain)UITextField *suppliedName;


-(void)confirm:(id)sender;
-(void)cancel:(id)sender;

@end