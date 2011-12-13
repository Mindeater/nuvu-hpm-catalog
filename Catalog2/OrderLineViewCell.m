//
//  OrderLineViewCell.m
//  Catalog2
//
//  Created by Ashley McCoy on 28/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "OrderLineViewCell.h"
#import "OrderDetailTableView.h"
/*
#define cell1Width 80
#define cell2Width 80
#define cellHeight 44
*/
@implementation OrderLineViewCell

@synthesize lineColor, topCell, bottomCell, cell1, cell2, cell3, cell4, cell5;

@synthesize commentField;

@synthesize cell1Width,cell2Width,cell3Width,cell4Width,cell5Width,cellHeight;

@synthesize indexRow;


- (void)dealloc
{
	[cell1 release];
	[cell2 release];
	//[cell3 release];
    [cell4 release];
    [cell5 release];
    [commentField release];
    [super dealloc];
}

-(void)calculateCellWidths
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat screenHeight = screenRect.size.height;
    // iphone 640 px
    //@TODO : define constants here to speed up table render
    cell1Width = screenWidth * .30;//desc .18;    //128.0;//code    20%
    cell2Width = screenWidth * .18;//code .30;    //160.0;//desc    25%
    cell3Width = screenWidth * .06;//quant .30;   //192.0;//comment 30%
    cell4Width = screenWidth * .30;//comment .06;  //64.0;//quant   10%
    cell5Width = screenWidth * .16;//96.0;//price   15%
    cellHeight = screenHeight/12;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self calculateCellWidths];
		topCell = NO;
		bottomCell = NO;
        indexRow = [NSNumber numberWithInt:0];
        
        // desc
        cell1 = [[UILabel alloc]init];
        cell1.textAlignment = UITextAlignmentLeft;
        cell1.lineBreakMode = UILineBreakModeWordWrap;
        cell1.numberOfLines = 0;
		cell1.backgroundColor = [UIColor clearColor]; // Important to set or lines will not appear
        
        // code
        cell2 = [[UILabel alloc]init];
        cell2.lineBreakMode = UILineBreakModeWordWrap;
        cell2.numberOfLines = 0;
        cell2.textAlignment = UITextAlignmentCenter;
		cell2.backgroundColor = [UIColor clearColor]; // Important to set or lines will not appear
        
        
        // quant
        cell3 = [[UILabel alloc]init];
        cell3.lineBreakMode = UILineBreakModeWordWrap;
        cell3.numberOfLines = 0;
        cell3.textAlignment = UITextAlignmentCenter;
        cell3.backgroundColor = [UIColor clearColor]; // Important to set or lines will not appear
        
        
        
        commentField = [[UITextView alloc]init];
        commentField.textAlignment = UITextAlignmentCenter;
        commentField.backgroundColor = [UIColor clearColor];//yellowColor];
        //commentField.delegate = self;
        commentField.frame = CGRectMake(cell1Width+cell2Width+cell3Width, 0,
                                        cell4Width, cellHeight);
        /*
        commentField = [[UITextView alloc]init];
        commentField.backgroundColor = [UIColor whiteColor];
        commentField.opaque = YES;
        commentField.scrollEnabled = NO;
        commentField.showsVerticalScrollIndicator = NO;
        commentField.showsHorizontalScrollIndicator = NO;
        commentField.contentInset = UIEdgeInsetsZero;
         */
        [self addSubview:commentField];
        
        /*
        // quantity
        cell4 = [[UILabel alloc]init];
        cell4.textAlignment = UITextAlignmentCenter;
        cell4.lineBreakMode = UILineBreakModeWordWrap;
        cell4.numberOfLines = 0;
		cell4.backgroundColor = [UIColor clearColor]; // Important to set or lines will not appear
        */
        
        // price
        cell5 = [[UILabel alloc]init];
        cell5.textAlignment = UITextAlignmentRight;
		cell5.backgroundColor = [UIColor clearColor]; // Important to set or lines will not appear
        
        cell1.frame = CGRectMake(0, 0,
                                 cell1Width, cellHeight);
        cell2.frame = CGRectMake(cell1Width, 0,
                                 cell2Width, cellHeight);
        cell3.frame = CGRectMake(cell1Width+cell2Width, 0,
                                 cell3Width, cellHeight);
        //cell4.frame = CGRectMake(cell1Width+cell2Width+cell3Width, 0,
         //                        cell4Width, cellHeight);
        cell5.frame = CGRectMake(cell1Width+cell2Width+cell3Width+cell4Width, 0,
                                 cell5Width, cellHeight);
        
        [self addSubview:cell1];
        [self addSubview:cell2];
        [self addSubview:cell3];
        //[self addSubview:cell4];
        [self addSubview:cell5];
        /*
		// Add labels for the three cells
		cell1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cell1Width, cellHeight)];
		cell1.textAlignment = UITextAlignmentCenter;
		cell1.backgroundColor = [UIColor clearColor]; // Important to set or lines will not appear
		[self addSubview:cell1];
		
		cell2 = [[UILabel alloc] initWithFrame:CGRectMake(cell1Width, 0, cell2Width, cellHeight)];
		cell2.textAlignment = UITextAlignmentCenter;
		cell2.backgroundColor = [UIColor clearColor]; // Important to set or lines will not appear
		[self addSubview:cell2];
        
		cell3 = [[UILabel alloc] initWithFrame:CGRectMake(cell1Width+cell2Width, 0, 320-(cell1Width+cell2Width), cellHeight)]; // Note - hardcoded 320 is not ideal; this can be done better
		cell3.textAlignment = UITextAlignmentCenter;
		cell3.backgroundColor = [UIColor clearColor]; // Important to set or lines will not appear
		[self addSubview:cell3];
         */
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    
    if(!topCell && !bottomCell){
        [super setSelected:selected animated:animated];
    }

    
    // Configure the view for the selected state
}


- (void)drawRect:(CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetStrokeColorWithColor(context, lineColor.CGColor);       
    
	// CGContextSetLineWidth: The default line width is 1 unit. When stroked, the line straddles the path, with half of the total width on either side.
	// Therefore, a 1 pixel vertical line will not draw crisply unless it is offest by 0.5. This problem does not seem to affect horizontal lines.
	CGContextSetLineWidth(context, 1.0);
    
	// Add the vertical lines
    if(!bottomCell){
        CGContextMoveToPoint(context, cell1Width+0.5, 0);
        CGContextAddLineToPoint(context, cell1Width+0.5, rect.size.height);
        
        CGContextMoveToPoint(context, cell1Width+cell2Width+0.5, 0);
        CGContextAddLineToPoint(context, cell1Width+cell2Width+0.5, rect.size.height);
    }

    CGContextMoveToPoint(context, cell1Width+cell2Width+cell3Width+0.5, 0);
    CGContextAddLineToPoint(context, cell1Width+cell2Width+cell3Width+0.5, rect.size.height);

    CGContextMoveToPoint(context, cell1Width+cell2Width+cell3Width+cell4Width+0.5, 0);
	CGContextAddLineToPoint(context, cell1Width+cell2Width+cell3Width+cell4Width+0.5, rect.size.height);
    
    //////////////////
	// Add bottom line
	CGContextMoveToPoint(context, 0, rect.size.height);
	CGContextAddLineToPoint(context, rect.size.width, rect.size.height-0.5);
	
	// If this is the topmost cell in the table, draw the line bottom
	if (topCell)
	{
		// bottom
        CGContextMoveToPoint(context, 0, rect.size.height);
        CGContextAddLineToPoint(context, rect.size.width, rect.size.height-0.5);
        
	}
    
    if(bottomCell){
        // top
        //CGContextMoveToPoint(context, 0, 0);
		//CGContextAddLineToPoint(context, rect.size.width, 0);
    }
	
	// Draw the lines
	CGContextStrokePath(context); 
}

- (void)setTopCell:(BOOL)newTopCell
{
	topCell = newTopCell;
	[self setNeedsDisplay];
}



@end
