//
//  OrderLineViewCell.m
//  Catalog2
//
//  Created by Ashley McCoy on 28/11/11.
//  Copyright (c) 2011 Mindeater Web Services. All rights reserved.
//

#import "OrderLineViewCell.h"
/*
#define cell1Width 80
#define cell2Width 80
#define cellHeight 44
*/
@implementation OrderLineViewCell

@synthesize lineColor, topCell, bottomCell, cell1, cell2, cell3, cell4, cell5;
@synthesize editingMode;

@synthesize commentField,quantField;

@synthesize cell1Width,cell2Width,cell3Width,cell4Width,cell5Width,cellHeight;

@synthesize padding;
@synthesize indexRow;


- (void)dealloc
{
	[cell1 release];
	[cell2 release];
	//[cell3 release];
    [cell4 release];
    [cell5 release];
    [commentField release];
    [quantField release];
    [super dealloc];
}

-(void)calculateCellWidths
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
        screenWidth = screenRect.size.height;
    }
    //CGFloat screenHeight = screenRect.size.height;
    // iphone 640 px
    //@TODO : define constants here to speed up table render
    cell1Width = screenWidth * .30;//desc .18;    //128.0;//code    20%
    cell2Width = screenWidth * .18;//code .30;    //160.0;//desc    25%
    cell3Width = screenWidth * .08;//.06;//quant .30;   //192.0;//comment 30%
    cell4Width = screenWidth * .28;//.30;//comment .06;  //64.0;//quant   10%
    cell5Width = screenWidth * .16;//96.0;//price   15%
    cellHeight = 140; //screenHeight/12;
    
    padding = 10.0;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    editingMode = NO;
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
        cell2.textAlignment = UITextAlignmentLeft;
        cell2.lineBreakMode = UILineBreakModeWordWrap;
        cell2.numberOfLines = 0;
		cell2.backgroundColor = [UIColor clearColor]; // Important to set or lines will not appear
        
        
        // quant
        quantField = [[UITextField alloc] init];
        quantField.backgroundColor = [UIColor clearColor]; 
        //[quantField setKeyboardType:UIKeyboardTypeNumberPad];
        quantField.contentVerticalAlignment = UIControlContentVerticalAlignmentBottom;
        quantField.textAlignment = UITextAlignmentCenter;
        quantField.contentVerticalAlignment = UIControlContentVerticalAlignmentTop;
        
        
        commentField = [[UITextView alloc]init];
        commentField.backgroundColor = [UIColor clearColor];//yellowColor];
       // commentField.textAlignment = UITextAlignmentLeft;
        commentField.font = cell1.font;//[UIFont fontWithName:@"Helvetica" size:12.0];
        
        
        /*
        commentField = [[UITextView alloc]init];
        commentField.backgroundColor = [UIColor whiteColor];
        commentField.opaque = YES;
        commentField.scrollEnabled = NO;
        commentField.showsVerticalScrollIndicator = NO;
        commentField.showsHorizontalScrollIndicator = NO;
        commentField.contentInset = UIEdgeInsetsZero;
         */
        
        
        
        
        // price
        cell5 = [[UILabel alloc]init];
        cell5.textAlignment = UITextAlignmentRight;
		cell5.backgroundColor = [UIColor clearColor]; // Important to set or lines will not appear
        
        cell1.frame = CGRectMake(0+padding, 0,
                                 cell1Width-padding, cellHeight);
        cell2.frame = CGRectMake(cell1Width+padding, 0,
                                 cell2Width-padding, cellHeight);
        quantField.frame = CGRectMake(cell1Width+cell2Width, 0,
                                      cell3Width, 30);
        commentField.frame = CGRectMake(cell1Width+cell2Width+cell3Width+padding, 0,
                                        cell4Width, cellHeight);
        cell5.frame = CGRectMake(cell1Width+cell2Width+cell3Width+cell4Width, 0,
                                 cell5Width-padding, 40);
        
        [self addSubview:cell1];
        [self addSubview:cell2];
        [self addSubview:quantField];
        [self addSubview:commentField];
        [self addSubview:cell5];
       
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
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if(!topCell && !bottomCell){
        [super setEditing:editing animated:animated];
        //@TODO: does this need to call setNeedsLayout ?? -no
        editingMode = YES;
        //[self setNeedsDisplay];
        //[self setNeedsLayout];
    }
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

-(void)setCellAsHeader
{
    cellHeight = 60;
    cell1.frame = CGRectMake(0, 0,
                             cell1Width, cellHeight);
    cell2.frame = CGRectMake(cell1Width, 0,
                             cell2Width, cellHeight);
    quantField.frame = CGRectMake(cell1Width+cell2Width, 0,
                                  cell3Width, cellHeight);
    commentField.frame = CGRectMake(cell1Width+cell2Width+cell3Width, 0,
                                    cell4Width, cellHeight);
    cell5.frame = CGRectMake(cell1Width+cell2Width+cell3Width+cell4Width, 0,
                             cell5Width, cellHeight);
}


@end
