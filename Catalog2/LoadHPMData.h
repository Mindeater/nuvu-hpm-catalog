//
//  LoadHPMData.h
//  Catalog2
//
//  Created by Ashley McCoy on 11/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadHPMData : NSObject{
    NSManagedObjectContext *context;
    NSArray *pListFiles;

}

@property(nonatomic,retain)NSManagedObjectContext *context;
@property(nonatomic,retain)NSArray *pListFiles;




-(void)processFiles;
-(NSDictionary *)readPlist:(NSString *)pListName;


-(NSManagedObject *)addEntity:(NSString*)entity withValues:(NSDictionary *)keyValues;
@end
