//
//  OrderLineViewCell.h
//  Catalog2
//
//  Created by Ashley McCoy on 28/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderLineViewCell : UITableViewCell{

    UIColor *lineColor;
	BOOL topCell;
	
	UILabel *cell1;//code
	UILabel *cell2;//desc
	UILabel *cell3;//comments
    UILabel *cell4;//qty
    UILabel *cell5;//price
    
    CGFloat cell1Width;
    CGFloat cell2Width;
    CGFloat cell3Width;
    CGFloat cell4Width;
    CGFloat cell5Width;
    CGFloat cellHeight;
    
}

@property (nonatomic, retain) UIColor* lineColor;
@property (nonatomic) BOOL topCell;
@property (readonly) UILabel* cell1;
@property (readonly) UILabel* cell2;
@property (readonly) UILabel* cell3;
@property (readonly) UILabel* cell4;
@property (readonly) UILabel* cell5;

@property(nonatomic)CGFloat cell1Width;
@property(nonatomic)CGFloat cell2Width;
@property(nonatomic)CGFloat cell3Width;
@property(nonatomic)CGFloat cell4Width;
@property(nonatomic)CGFloat cell5Width;
@property(nonatomic)CGFloat cellHeight;

@end
