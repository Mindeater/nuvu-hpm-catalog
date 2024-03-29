//
//  RootView.h
//  Catalog2
//
//  Created by Ashley McCoy on 12/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MPMoviePlayerController;
@interface RootView : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate>{
    NSManagedObjectContext *context;
    UIButton *button1;
    UIButton *button2;
    UIButton *button3;
    UIButton *button4;
    UIButton *button5;
    UIButton *button6;
    
    UIPopoverController *popOver;
    
    UIImageView *bgImgPort;
    UIImageView *bgImgLand;
    
    UIImage *choosenWall;
    
    MPMoviePlayerController *moviePlayer;
}

@property(nonatomic,retain)NSManagedObjectContext *context;
@property(nonatomic,retain)UIButton *button1;
@property(nonatomic,retain)UIButton *button2;
@property(nonatomic,retain)UIButton *button3;
@property(nonatomic,retain)UIButton *button4;
@property(nonatomic,retain)UIButton *button5;
@property(nonatomic,retain)UIButton *button6;

@property(nonatomic,retain)UIPopoverController *popOver;

@property(nonatomic,retain)UIImageView *bgImgPort;
@property(nonatomic,retain)UIImageView *bgImgLand;
@property(nonatomic,retain)MPMoviePlayerController *moviePlayer;

@property(nonatomic,retain)UIImage *choosenWall;


-(void)showAlert:(id)sender;

-(void)showCatalog;
-(void)showSettings;
-(void)searchPage;
-(void)chooseBackgroundFromLibrary;
-(void)takePicture:(id)sender;
-(void)showOrders;

-(void)layoutButtons:(UIInterfaceOrientation)toInterfaceOrientation;

-(void)setBackgroundImageFromLibrary;

-(void)playMovie;
-(void)moviePlayBackDidFinish:(NSNotification*)notification;

-(void)renderInterface;

-(CGFloat)degreesToRadians:(CGFloat)degrees;
-(UIImage*)imageByRotatingImage:(UIImage*)initImage fromImageOrientation:(UIImageOrientation)orientation;
@end
