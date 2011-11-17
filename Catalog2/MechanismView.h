//
//  MechanismView.h
//  Catalog2
//
//  Created by Ashley McCoy on 13/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MechanismView : UIView{
    NSString *parentProduct;
    BOOL selected;

}

@property(nonatomic,retain)NSString *parentProduct;
@property(nonatomic)BOOL selected;

-(void)drawWithMechanisms:(NSArray *)mechanisms;
-(void)chooseMe;

@end
