//
//  OrdersTableView.h
//  Catalog2
//
//  Created by Ashley McCoy on 19/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrdersTableView : UITableViewController <NSFetchedResultsControllerDelegate, UITextFieldDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_context;    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *context;

-(void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;

-(void)addNewOrder;
@end
