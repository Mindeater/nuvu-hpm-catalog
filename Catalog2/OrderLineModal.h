//
//  OrderLineModal.h
//  Catalog2
//
//  Created by Ashley McCoy on 2/02/12.
//  Copyright (c) 2012 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderLineModal : UIViewController <UIGestureRecognizerDelegate> {
    NSManagedObjectContext *_context;
    NSManagedObject *orderLineManagedObject;
    
    CGRect sizeRect;
}

@property (nonatomic, retain) NSManagedObjectContext *context;
@property(nonatomic,retain)NSManagedObject *orderLineManagedObject;
@property(nonatomic)CGRect sizeRect;

-(UIImage *)getFacePlateImage:(NSManagedObject *)item;
-(UIImage *)getMechanismImage:(NSManagedObject *)item;
@end
