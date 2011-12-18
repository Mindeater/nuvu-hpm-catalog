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

@interface OrderDetailTableView : UITableViewController<NSFetchedResultsControllerDelegate, UITextViewDelegate,UITextFieldDelegate,MFMailComposeViewControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_context;
    
    NSString *orderId;
    float orderTotal;
    int quantityCount;
    
    NSMutableString *emailOrderBody;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *context;

@property(nonatomic,retain)NSString *orderId;
@property(nonatomic)float orderTotal;
@property(nonatomic)int quantityCount;

@property(nonatomic,retain)NSMutableString *emailOrderBody;

-(NSArray *)getPartsFromOrderLine:(NSManagedObject *)orderLine;
-(void)updateComment:(NSString *)comment atIndexRow:(NSInteger)indexRow;

-(void)emailOrder:(id)sender;

@end