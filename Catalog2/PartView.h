//
//  PartView.h
//  Catalog2
//
//  Created by Ashley McCoy on 17/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PartView : UIView{
    NSString *parentProduct;
    BOOL selected;
    UIView *controlsView;
    NSString *orientationPrefix;
    NSString *brandName;
    
}

@property(nonatomic,retain)NSString *parentProduct;
@property(nonatomic)BOOL selected;
@property(nonatomic,retain)UIView *controlsView;
@property(nonatomic,retain)NSString *orientationPrefix;
@property(nonatomic,retain)NSString *brandName;

-(void)drawWithItems:(NSArray *)items;
-(void)chooseMe;
-(UIImage *)getMechanismImage;

@end
