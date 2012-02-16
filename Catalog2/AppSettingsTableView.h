//
//  AppSettingsTableView.h
//  Catalog2
//
//  Created by Ashley McCoy on 21/12/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppSettingsTableView : UITableViewController <UITextFieldDelegate>{
    NSArray *tableData;
    NSArray *tableHeadings;
    NSArray *infoStrings;
}

@property(nonatomic,retain)NSArray *tableData;
@property(nonatomic,retain)NSArray *tableHeadings;
@property(nonatomic,retain)NSArray *infoStrings;


-(void)setPricingPercentage;

@end
