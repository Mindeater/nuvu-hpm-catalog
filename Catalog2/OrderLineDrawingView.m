//
//  OrderLineDrawingView.m
//  Catalog2
//
//  Created by Ashley McCoy on 6/12/13.
//  Copyright (c) 2013 Mindeater Web Services. All rights reserved.
//

#import "OrderLineDrawingView.h"
#import "OrderLineViewCell.h"

@implementation OrderLineDrawingView
@synthesize parent;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{

    CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
	// CGContextSetLineWidth: The default line width is 1 unit. When stroked, the line straddles the path, with half of the total width on either side.
	// Therefore, a 1 pixel vertical line will not draw crisply unless it is offest by 0.5. This problem does not seem to affect horizontal lines.
	CGContextSetLineWidth(context, 1.0);
    
	// Add the vertical lines
    if(! parent.bottomCell)
    {
        CGContextMoveToPoint(context, parent.cell1Width+0.5, 0);
        CGContextAddLineToPoint(context, parent.cell1Width+0.5, rect.size.height);
        
        CGContextMoveToPoint(context, parent.cell1Width + parent.cell2Width+0.5, 0);
        CGContextAddLineToPoint(context, parent.cell1Width + parent.cell2Width+0.5, rect.size.height);
    }
    
    CGContextMoveToPoint(context, parent.cell1Width + parent.cell2Width + parent.cell3Width+0.5, 0);
    CGContextAddLineToPoint(context, parent.cell1Width + parent.cell2Width + parent.cell3Width+0.5, rect.size.height);
    
    CGContextMoveToPoint(context, parent.cell1Width+ parent.cell2Width+ parent.cell3Width + parent.cell4Width+0.5, 0);
	CGContextAddLineToPoint(context, parent.cell1Width + parent.cell2Width + parent.cell3Width + parent.cell4Width+0.5, rect.size.height);
    
    //////////////////
	// Add bottom line
	CGContextMoveToPoint(context, 0, rect.size.height);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height-0.5);
	
	// If this is the topmost cell in the table, draw the line bottom
	if (parent.topCell)
	{
		// bottom line
        CGContextMoveToPoint(context, 0, rect.size.height);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height-0.5);
        
	}
    
    if(parent.bottomCell){
        // top
        //CGContextMoveToPoint(context, 0, 0);
		//CGContextAddLineToPoint(context, rect.size.width, 0);
    }
	
	// Draw the lines
	CGContextStrokePath(context);
}

@end
