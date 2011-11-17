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
    
}

@property(nonatomic,retain)NSString *parentProduct;
@property(nonatomic)BOOL selected;

-(void)drawWithItems:(NSArray *)items;
-(void)chooseMe;

@end
