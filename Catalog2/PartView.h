//
//  PartView.h
//  Catalog2
//
//  Created by Ashley McCoy on 17/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductChooserView;
@interface PartView : UIViewController <UIActionSheetDelegate> {
    
    NSString *categoryName;
    BOOL      selected;
    UIView   *controlsView;
    UILabel  *partLabel;
    
    NSString *orientationPrefix;
    NSString *brandName;
    NSString *productName;
    NSString *price;
    NSString *parts;
    
    ProductChooserView *_parent; 
    UIToolbar *toolBar;
    
    NSString *currentAction;
    
    UIImage *wallImage;
    
    UILabel *countLabel;
    int countNum;
    int countTotal;
    
    CGFloat adjustImageFrameHeightFactor;
    CGFloat adjustImagePositionY;
    
    UIActionSheet *popupQuery;
    
}

@property(nonatomic,retain)NSString *categoryName;
@property(nonatomic)BOOL selected;
@property(nonatomic,retain)UIView *controlsView;
@property(nonatomic,retain)UILabel *partLabel;

@property(nonatomic,retain)NSString *orientationPrefix;
@property(nonatomic,retain)NSString *brandName;
@property(nonatomic,retain)NSString *productName;
@property(nonatomic,retain)NSString *price;
@property(nonatomic,retain)NSString *parts;

@property(nonatomic,retain)UIImage *wallImage;

@property(nonatomic,retain)UILabel *countLabel;
@property(nonatomic)int countNum;
@property(nonatomic)int countTotal;

@property(nonatomic)CGFloat adjustImageFrameHeightFactor;
@property(nonatomic)CGFloat adjustImagePositionY;

@property(nonatomic,retain)ProductChooserView *_parent;
@property(nonatomic,retain)UIToolbar *toolBar;

@property(nonatomic,retain)NSString *currentAction;

@property(nonatomic,retain)UIActionSheet *popupQuery;

-(void)drawWithItems:(NSArray *)items;
-(void)chooseMe;
-(UIImage *)getMechanismImage;

-(void)addNavigationBar;
-(void)pressThePart:(id)sender;
-(void)addToolBarToView;
-(void)addOrderStatusToView;

-(void)updateSelectedStatus;

// scrolling methods
-(void)nextItem:(id)sender;
-(void)previousItem:(id)sender;

// toolbar selectors
-(void)showMenuSheet:(id)sender;
-(void)addItemToCart:(id)sender;

// toolbar actions
-(void)addToDefaultActiveOrder;
-(void)returnToMainMenu;
-(void)returnToCatalogMenu;
-(void)returnToMechanism;
-(void)gotoCart;
-(void)showOrders;
-(void)addNewOrder;
@end
