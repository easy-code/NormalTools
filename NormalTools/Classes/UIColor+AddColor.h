//
//  UIColor+AddColor.h
//
//
//  Created by Fengzee on 05/27/2020.
//  Copyright (c) 2020 Fengzee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (AddColor)
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;
+ (UIColor *) randomColor;
@end
