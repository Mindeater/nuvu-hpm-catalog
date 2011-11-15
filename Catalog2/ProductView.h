//
//  ProductView.h
//  Catalog2
//
//  Created by Ashley McCoy on 13/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MechanismView;
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
    MechanismView *pageOneDoc;
	MechanismView *pageTwoDoc;
	MechanismView *pageThreeDoc;
	int prevIndex;
	int currIndex;
	int nextIndex;
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
@property (nonatomic, retain)MechanismView *pageOneDoc;
@property (nonatomic, retain)MechanismView *pageTwoDoc;
@property (nonatomic, retain)MechanismView *pageThreeDoc;
@property (nonatomic) int prevIndex;
@property (nonatomic) int currIndex;
@property (nonatomic) int nextIndex;

- (void)loadPageWithId:(int)index onPage:(int)page;

-(NSArray *)getObjToScroll:(int)index;



@end
