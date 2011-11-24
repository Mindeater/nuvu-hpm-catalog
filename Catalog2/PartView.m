//
//  PartView.m
//  Catalog2
//
//  Created by Ashley McCoy on 17/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "PartView.h"

@implementation PartView

@synthesize parentProduct;
@synthesize selected;
@synthesize controlsView;
@synthesize orientationPrefix;
@synthesize brandName;

-(void)dealloc
{
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void)setOrientationPrefix:(NSString *)newValue
{
    // retain the passed value
    if([newValue isEqualToString:@"Horizontal"]){
        orientationPrefix = [[NSString stringWithString:@"h-"] retain];
    }else if([newValue isEqualToString:@"Vertical"]){
        orientationPrefix = [[NSString stringWithString:@"v-"] retain];
    }else{
        orientationPrefix = [[NSString stringWithString:@""] retain];
    }
    //NSLog(@" Now is %@\n\n",orientationPrefix);
}
-(void)drawWithItems:(NSArray *)items
{
    
}
-(void)chooseMe
{
    
}
-(UIImage *)getMechanismImage
{
    return [[[UIImage alloc] init ] autorelease];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
