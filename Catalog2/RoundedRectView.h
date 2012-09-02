//
//  RoundedRectView.h
//  ImageManipulator
//
//  Created by Ashley McCoy on 20/10/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//
//
//  RoundedRectView.h
//
//  Created by Jeff LaMarche on 11/13/08.
// http://iphonedevelopment.blogspot.com/2008/11/creating-transparent-uiviews-rounded.html

#import <UIKit/UIKit.h>

#define kDefaultStrokeColor         [UIColor blackColor]
#define kDefaultRectColor           [UIColor blackColor]
#define kDefaultStrokeWidth         1.0
#define kDefaultCornerRadius        30.0

@interface RoundedRectView : UIView {
    UIColor     *strokeColor;
    UIColor     *rectColor;
    CGFloat     strokeWidth;
    CGFloat     cornerRadius;
}
@property (nonatomic, retain) UIColor *strokeColor;
@property (nonatomic, retain) UIColor *rectColor;
@property CGFloat strokeWidth;
@property CGFloat cornerRadius;
@end
