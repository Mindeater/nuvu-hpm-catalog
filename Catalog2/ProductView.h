//
//  ProductView.h
//  Catalog2
//
//  Created by Ashley McCoy on 13/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PartView;
@interface ProductView : UIViewController<NSFetchedResultsControllerDelegate,UIScrollViewDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_context; 
    
    NSString *currentBrand;
    NSString *currentCategory;
    
    //scrollable iVArs
    IBOutlet UIScrollView *scrollView;
	
	NSMutableArray *documentTitles;
//	UILabel *pageOneDoc;
//	UILabel *pageTwoDoc;
//	UILabel *pageThreeDoc;
    PartView *pageOneDoc;
	PartView *pageTwoDoc;
	PartView *pageThreeDoc;
	int prevIndex;
	int currIndex;
	int nextIndex;
    
    NSString * activeEntity;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *context;

@property(nonatomic,retain)NSString *currentBrand;
@property(nonatomic,retain)NSString *currentCategory;


// scrollable iVars
@property (nonatomic, retain) UIScrollView *scrollView;

@property (nonatomic, retain) NSMutableArray *documentTitles;
//@property (nonatomic, retain) UILabel *pageOneDoc;
//@property (nonatomic, retain) UILabel *pageTwoDoc;
//@property (nonatomic, retain) UILabel *pageThreeDoc;
@property (nonatomic, retain)PartView *pageOneDoc;
@property (nonatomic, retain)PartView *pageTwoDoc;
@property (nonatomic, retain)PartView *pageThreeDoc;
@property (nonatomic) int prevIndex;
@property (nonatomic) int currIndex;
@property (nonatomic) int nextIndex;

@property(nonatomic,retain)NSString * activeEntity;

//- (void)loadPageWithId:(int)index onPage:(int)page;
- (void)loadPageWithId:(int)index onPage:(int)page withEntity:(NSString *)entityName;

-(NSArray *)getObjToScroll:(int)index forEntityName:(NSString *)name;
-(void)addMechanismsToScrollView;
-(void)addFacePlatesToScrollView;



@end
