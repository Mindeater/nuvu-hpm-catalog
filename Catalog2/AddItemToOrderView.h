//
//  AddItemToOrderView.h
//  Catalog2
//
//  Created by Ashley McCoy on 27/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface AddItemToOrderView : UIViewController <NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *context;
    NSArray *mechanism;
    NSManagedObject *faceplate;
    NSString *productToAdd;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,retain)NSManagedObjectContext *context;
@property(nonatomic,retain)NSArray *mechanism;
@property(nonatomic,retain)NSManagedObject *faceplate;
@property(nonatomic,retain)NSString *productToAdd;


-(void)cancelSelection:(id)sender;
-(void)acceptSelection:(id)sender;

@end
