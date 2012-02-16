//
//  OrderDetailTableView.h
//  Catalog2
//
//  Created by Ashley McCoy on 28/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>
// sending mail
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface OrderDetailTableView : UITableViewController <
                                    NSFetchedResultsControllerDelegate,
                                    UITextViewDelegate,
                                    UITextFieldDelegate,
                                    MFMailComposeViewControllerDelegate,
                                    UIActionSheetDelegate,
                                    UIAlertViewDelegate> 
{
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_context;
    
    NSString *orderId;
    NSString *orderName;
    float orderTotal;
    int quantityCount;
    
    NSString *backString;
    
    NSMutableString *emailOrderBody;
    NSMutableString *emailOrderBodyNoPrice;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *context;

@property(nonatomic,retain)NSString *orderId;
@property(nonatomic,retain)NSString *orderName;
@property(nonatomic)float orderTotal;
@property(nonatomic)int quantityCount;

@property(nonatomic,retain)NSString *backString;

@property(nonatomic,retain)NSMutableString *emailOrderBody;
@property(nonatomic,retain)NSMutableString *emailOrderBodyNoPrice;

-(NSArray *)getPartsFromOrderLine:(NSManagedObject *)orderLine;
-(void)updateComment:(NSString *)comment atIndexRow:(NSInteger)indexRow;

-(void)sendCurrentOrder:(id)sender;
-(void)emailOrder:(id)sender;

-(void)addLeftNavigationButton;

@end