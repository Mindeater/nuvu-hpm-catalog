//
//  ProductChooserView.h
//  Catalog2
//
//  Created by Ashley McCoy on 2/12/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PartView;
@class AddPartToOrder;
@interface ProductChooserView : UIViewController <NSFetchedResultsControllerDelegate> {
    
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_context; 
    
    NSString *currentBrand;
    NSString *currentCategory;
    NSString *currentEntityName;
    
    // view controller looping
    int prevIndex;
	int currIndex;
	int nextIndex;
        
    int vcIndex;
    
    PartView *vc1;
	PartView *vc2;
	PartView *vc3;
    
    // retaining selections
    NSString *selectedProductName;
    NSArray *currentFacePlates;
    UIImage *selectedMechanismImage;
    NSArray *mechanismObject;
    
    AddPartToOrder *shoppingCart;
    
    UIImage *wallImage;
    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *context;

@property(nonatomic,retain)NSString *currentBrand;
@property(nonatomic,retain)NSString *currentCategory;
@property(nonatomic,retain)NSString *currentEntityName;

@property (nonatomic) int prevIndex;
@property (nonatomic) int currIndex;
@property (nonatomic) int nextIndex;

@property(nonatomic)int vcIndex;

@property(nonatomic,retain)PartView *vc1;
@property(nonatomic,retain)PartView *vc2;
@property(nonatomic,retain)PartView *vc3;


@property(nonatomic,retain)NSString *selectedProductName;
@property(nonatomic,retain)NSArray *currentFacePlates;
@property(nonatomic,retain)UIImage *selectedMechanismImage;
@property(nonatomic,retain)NSArray *mechanismObject;

@property(nonatomic,retain)AddPartToOrder *shoppingCart;

@property(nonatomic,retain)UIImage *wallImage;

-(void)setViewControllerCommonProperties;
-(void)setMechanismsOnViewControllers;
-(void)setFacePlatesOnViewControllers;

-(void)nextItem:(id)sender;
-(void)prevItem:(id)sender;
-(void)resetViewControllers;

-(void)getFaceplatesForCurrentMechanism;

-(NSArray *)getObjToScroll:(int)index forEntityName:(NSString *)name;

-(void)addActivePartToCart;
-(void)returnToMainMenu;
-(void)returnToCatalogMenu;
-(void)returnToMechanism;
-(void)gotoCart;

@end
