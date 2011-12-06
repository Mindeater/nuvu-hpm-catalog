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
    NSString *orientationPrefix;
    NSString *brandName;
    NSString *productName;
    
    ProductChooserView *_parent; 
    UIToolbar *toolBar;
    
    NSString *currentAction;
    
}

@property(nonatomic,retain)NSString *categoryName;
@property(nonatomic)BOOL selected;
@property(nonatomic,retain)UIView *controlsView;
@property(nonatomic,retain)NSString *orientationPrefix;
@property(nonatomic,retain)NSString *brandName;
@property(nonatomic,retain)NSString *productName;

@property(nonatomic,retain)ProductChooserView *_parent;
@property(nonatomic,retain)UIToolbar *toolBar;

@property(nonatomic,retain)NSString *currentAction;

-(void)drawWithItems:(NSArray *)items;
-(void)chooseMe;
-(UIImage *)getMechanismImage;

-(void)addNavigationBar;
-(void)addToolBarToView;

// scrolling methods
-(void)nextItem:(id)sender;
-(void)previousItem:(id)sender;

// toolbar selectors
-(void)showMenuSheet;
-(void)addItemToCart;

-(void)addToDefaultActiveOrder;
-(void)returnToMainMenu;
-(void)returnToCatalogMenu;
@end
