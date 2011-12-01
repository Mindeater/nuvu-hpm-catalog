//
//  ProductView.h
//  Catalog2
//
//  Created by Ashley McCoy on 13/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PartView;
@interface ProductView : UIViewController <NSFetchedResultsControllerDelegate,UIScrollViewDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_context; 
    
    NSString *currentBrand;
    NSString *currentCategory;
    
    //scrollable iVArs
    IBOutlet UIScrollView *scrollView;
	
	NSMutableArray *documentTitles;

    PartView *pageOneDoc;
	PartView *pageTwoDoc;
	PartView *pageThreeDoc;
    
	int prevIndex;
	int currIndex;
	int nextIndex;
    
    NSString * activeEntity;
    
    UIView *mechBg;
    UIView *wallBg;
    UIView *scrollHolder;
    
    //NSManagedObject *selectedMechanism;
    NSArray *selectedMechanism;
    NSManagedObject *selectedFacePlate;
    NSString *selectedProductName;
    NSArray *currentFacePlates;
    
    BOOL manipulationMethodsShouldReturn;
    
    UIToolbar *toolBar;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *context;

@property(nonatomic,retain)NSString *currentBrand;
@property(nonatomic,retain)NSString *currentCategory;


// scrollable iVars
@property (nonatomic, retain) UIScrollView *scrollView;


@property (nonatomic, retain)PartView *pageOneDoc;
@property (nonatomic, retain)PartView *pageTwoDoc;
@property (nonatomic, retain)PartView *pageThreeDoc;

@property (nonatomic) int prevIndex;
@property (nonatomic) int currIndex;
@property (nonatomic) int nextIndex;

@property(nonatomic,retain)NSString * activeEntity;

@property(nonatomic,retain)UIView *mechBg;
@property(nonatomic,retain)UIView *wallBg;
@property(nonatomic,retain)UIView *scrollHolder;

@property(nonatomic,retain)NSArray *selectedMechanism;
@property(nonatomic,retain)NSManagedObject *selectedFacePlate;
@property(nonatomic,retain)NSString *selectedProductName;
@property(nonatomic,retain)NSArray *currentFacePlates;

@property(nonatomic)BOOL manipulationMethodsShouldReturn;

@property(nonatomic,retain)UIToolbar *toolBar;

- (void)loadPageWithId:(int)index onPage:(int)page withEntity:(NSString *)entityName;

-(NSArray *)getObjToScroll:(int)index forEntityName:(NSString *)name;
-(void)addMechanismsToScrollView;
-(void)addFacePlatesToScrollView;

-(void)showManipulationControls;

-(void)addToOrder;
-(void)newOrder;



@end
