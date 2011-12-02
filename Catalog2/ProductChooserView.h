//
//  ProductChooserView.h
//  Catalog2
//
//  Created by Ashley McCoy on 2/12/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductChooserView : UIViewController <NSFetchedResultsControllerDelegate> {
    
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_context; 
    
    NSString *currentBrand;
    NSString *currentCategory;
    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *context;

@property(nonatomic,retain)NSString *currentBrand;
@property(nonatomic,retain)NSString *currentCategory;

@end
