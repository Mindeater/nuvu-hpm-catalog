//
//  BackgroundLibrary.h
//  Catalog2
//
//  Created by Ashley McCoy on 18/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundLibrary : UIViewController{
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *button5;
    UIButton *button6;
    UIButton *button7;
    UIButton *button8;
    UIButton *button9;
    UIButton *button10;
    UIButton *button11;
    UIButton *button12;
    
    BOOL selected;
    UIImage *selectedImage;
    NSArray *buttonImages;
}

@property(nonatomic,retain)UIButton *button1;
@property(nonatomic,retain)UIButton *button2;
@property(nonatomic,retain)UIButton *button3;
@property(nonatomic,retain)UIButton *button4;
@property(nonatomic,retain)UIButton *button5;
@property(nonatomic,retain)UIButton *button6;
@property(nonatomic,retain)UIButton *button7;
@property(nonatomic,retain)UIButton *button8;
@property(nonatomic,retain)UIButton *button9;
@property(nonatomic,retain)UIButton *button10;
@property(nonatomic,retain)UIButton *button11;
@property(nonatomic,retain)UIButton *button12;

@property(nonatomic)BOOL selected;
@property(nonatomic,retain)NSArray *buttonImages;
@property(nonatomic,retain)UIImage *selectedImage;

-(void)layoutButtons:(UIInterfaceOrientation)toInterfaceOrientation;
-(void)chooseImage:(id)sender;

-(void)nextView:(id)sender;
@end
