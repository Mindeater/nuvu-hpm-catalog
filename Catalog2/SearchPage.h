//
//  SearchPage.h
//  Catalog2
//
//  Created by Ashley McCoy on 19/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchResultTableView;
@interface SearchPage : UIViewController{
    UISearchBar *searchBar;
    SearchResultTableView *resultTable;
    UISearchDisplayController *searchController;
    NSManagedObjectContext *context;
}

@property(nonatomic,retain)UISearchBar *searchBar;
@property(nonatomic,retain)SearchResultTableView *resultTable;
@property(nonatomic,retain)UISearchDisplayController *searchController;

@property(nonatomic,retain)NSManagedObjectContext *context;

@end
