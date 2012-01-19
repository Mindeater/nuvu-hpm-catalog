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
    UIButton *button13;
    UIButton *button14;
    UIButton *button15;
    UIButton *button16;
    UIButton *button17;
    UIButton *button18;
    UIButton *button19;
    UIButton *button20;
    
    BOOL selected;
    UIImage *selectedImage;
    NSArray *buttonImages;
    NSArray *bgList;
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
@property(nonatomic,retain)UIButton *button13;
@property(nonatomic,retain)UIButton *button14;
@property(nonatomic,retain)UIButton *button15;
@property(nonatomic,retain)UIButton *button16;
@property(nonatomic,retain)UIButton *button17;
@property(nonatomic,retain)UIButton *button18;
@property(nonatomic,retain)UIButton *button19;
@property(nonatomic,retain)UIButton *button20;

@property(nonatomic)BOOL selected;
@property(nonatomic,retain)NSArray *buttonImages;
@property(nonatomic,retain)UIImage *selectedImage;
@property(nonatomic,retain)NSArray *bgList;

-(void)layoutButtons:(UIInterfaceOrientation)toInterfaceOrientation;
-(void)chooseImage:(id)sender;

-(void)nextView:(id)sender;
@end
