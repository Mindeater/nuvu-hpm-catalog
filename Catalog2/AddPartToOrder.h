//
//  AddPartToOrder.h
//  Catalog2
//
//  Created by Ashley McCoy on 6/12/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddPartToOrder : NSObject <NSFetchedResultsControllerDelegate>{
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *context;
    
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property(nonatomic,retain)NSManagedObjectContext *context;

@property(nonatomic,retain)NSManagedObject *currentOrderLine;

-(void)setUpFetchedResultsController;
-(void)setActiveOrderLine:(NSString *)productName;

-(NSString *)getActiveOrderId;

-(void)addMechanismsToDefaultOrder:(NSArray *)mechanisms withProductName:(NSString *)productName;
-(void)addCommentToActiveOrderLine:(NSString *)comment;
-(void)addFaceplateToDefaultOrder:(NSArray *)faceplate withProductName:(NSString *)productName;

-(void)addNewOrder;
-(void)setProductCount:(int)count;
@end
