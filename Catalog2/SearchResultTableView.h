//
//  SearchResultTableView.h
//  Catalog2
//
//  Created by Ashley McCoy on 19/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchPage;
@interface SearchResultTableView : UITableViewController <NSFetchedResultsControllerDelegate,UISearchDisplayDelegate, UISearchBarDelegate>{
    
    NSManagedObjectContext *context;
    NSFetchedResultsController *fetchedResultsController;
    
    NSArray *filteredListContents;
    SearchPage *LINK;
}

@property(nonatomic,retain)NSManagedObjectContext *context;
@property(nonatomic,retain)NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,retain)NSArray *filteredListContents;
@property(nonatomic,retain)SearchPage *LINK;

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope;


@end
