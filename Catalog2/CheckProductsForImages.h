//
//  CheckProductsForImages.h
//  Catalog2
//
//  Created by Ashley McCoy on 24/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CheckProductsForImages : UIView <NSFetchedResultsControllerDelegate> {
    NSFetchedResultsController *_fetchedResultsController;
    NSManagedObjectContext *_context;
    
    NSMutableString *outputLog;
    int mechCount;
    int facePlateCount;
    int productCount;
    int missingMech;
    int missingFaceplates;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *context;
@property(nonatomic,retain)NSMutableString *outputLog;

@property(nonatomic)int mechCount;
@property(nonatomic)int facePlateCount;
@property(nonatomic)int productCount;
@property(nonatomic)int missingMech;
@property(nonatomic)int missingFaceplates;

-(void)runCheck;
-(void)checkMechanismImages;
-(void)checkFaceplateImages;
-(void)getMechanismImagePaths:(NSArray *)mechanisms:(NSString *)brand:(NSString *)category:(NSString *)orientation;
-(void)getFacePlateImagePaths:(NSArray *)faceplates:(NSString *)brand:(NSString *)category:(NSString *)orientation;
-(void)logPathCheck:(NSDictionary *)pathMap;
-(NSString *)getOrientationPrefix:(NSString *)value;
@end
