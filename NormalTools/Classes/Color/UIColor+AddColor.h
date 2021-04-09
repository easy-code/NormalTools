//
//  UIColor+AddColor.h
//  cheng
//
//  Created by chengfeng on 04/09/2021.
//  Copyright (c) 2021 chengfeng. All rights reserved.

#import <UIKit/UIKit.h>

@interface UIColor (AddColor)
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *) randomColor;
@end
