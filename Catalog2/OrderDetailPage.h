//
//  OrderDetailPage.h
//  Catalog2
//
//  Created by Ashley McCoy on 19/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailPage : UIViewController{
    NSManagedObjectContext *context;
}

@property(nonatomic,retain)NSManagedObjectContext *context;
@end
