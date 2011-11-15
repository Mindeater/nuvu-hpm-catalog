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

}

@property(nonatomic,retain)NSString *parentProduct;

-(void)drawWithMechanisms:(NSArray *)mechanisms;
@end
