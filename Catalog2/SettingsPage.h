//
//  SettingsPage.h
//  Catalog2
//
//  Created by Ashley McCoy on 18/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SettingsPage : UIViewController{
    NSString *infomationString;
    UIImage *logoImage;
}

@property(nonatomic,retain)NSString *infomationString;
@property(nonatomic,retain)UIImage *logoImage;

@end
