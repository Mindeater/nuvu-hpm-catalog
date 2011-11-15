//
//  RootView.h
//  Catalog2
//
//  Created by Ashley McCoy on 12/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootView : UIViewController{
    NSManagedObjectContext *context;
}

@property(nonatomic,retain)NSManagedObjectContext *context;

-(void)showAlert:(id)sender;
-(void)showCatalog;

@end
