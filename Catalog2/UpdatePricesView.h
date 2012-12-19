//
//  UpdatePricesView.h
//  Catalog2
//
//  Created by Ashley McCoy on 10/12/12.
//  Copyright (c) 2012 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdatePricesView : UIViewController <NSFetchedResultsControllerDelegate>{
    BOOL verbose;
    UITextField *output;
    UILabel *status;
    NSArray *pLists;
    
    CGFloat fileCount;
    CGFloat fileIndex;
    
    NSManagedObjectContext *_context;
}

@property(nonatomic)BOOL verbose;
@property(nonatomic, retain)UITextField *output;
@property(nonatomic,retain)UILabel *status;
@property(nonatomic,retain)NSArray *pLists;

@property(nonatomic,retain)NSManagedObjectContext *context;


-(void) updateStatuswithMessage:(NSString *)message;
-(void) startUpdate;

-(void) updateEntity:(NSString *)entityName
       withNameField:(NSString *)entityNameField
      andProductName:(NSString *)productName
            andPrice:(float)value;
    
@end
