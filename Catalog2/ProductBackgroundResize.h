//
//  ProductBackgroundResize.h
//  Catalog2
//
//  Created by Ashley McCoy on 5/12/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface ProductBackgroundResize : UIViewController <UIGestureRecognizerDelegate>{
    UIImage *backgroundImage;
    UIImage *resizingImage;
    
    
    CGFloat _lastScale;
	CGFloat _lastRotation;  
	CGFloat _firstX;
	CGFloat _firstY;
    
    UIImageView *photoImage;
    UIView *canvas;
    
    CAShapeLayer *_marque;
}

@property (nonatomic, retain)UIView *canvas;


@property(nonatomic,retain)UIImage *backgroundImage;
@property(nonatomic,retain)UIImage *resizingImage;


-(void)cancelResize:(id)sender;
-(void)saveResized:(id)sender;
-(void)resetSize:(id)sender;

//-(CGContextRef)createCGContextFromCGImage:(CGImageRef)img;
-(UIImage *)cleanTransparentPixelsFromImage:(UIImage *)anImage;
@end
