//
//  AccessoryTableCell.h
//
//  Created by Shabbir Vijapura on 10/21/12.
//
//

#import <UIKit/UIKit.h>

@interface AccessoryTableCell : UIControl
{
	UIColor *_accessoryColor;
	UIColor *_highlightedColor;
}

@property (nonatomic, retain) UIColor *accessoryColor;
@property (nonatomic, retain) UIColor *highlightedColor;

+ (AccessoryTableCell *)accessoryWithColor:(UIColor *)color;
@property (nonatomic, assign) BOOL showArrow;

@end
