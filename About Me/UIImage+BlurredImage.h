//
//  UIImage+BlurredImage.h
//
//  Created by Shabbir Vijapura on 4/28/13.
//

#import <UIKit/UIKit.h>
#import <Accelerate/Accelerate.h>
#import <QuartzCore/QuartzCore.h>

@interface UIImage (BlurredImage)

-(UIImage *)blurImageWithAmount:(CGFloat)blur;

@end
