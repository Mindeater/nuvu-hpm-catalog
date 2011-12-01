//
//  BrandTableView.h
//  DataCatalogue
//
//  Created by Ashley McCoy on 7/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandTableView : UITableViewController <NSFetchedResultsControllerDelegate> {
        NSFetchedResultsController *_fetchedResultsController;
        NSManagedObjectContext *_context;    
}
    
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *context;

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end
