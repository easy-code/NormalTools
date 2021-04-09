//
//  UILabel+LineCounter.h
//  cheng
//
//  Created by chengfeng on 04/09/2021.
//  Copyright (c) 2021 chengfeng. All rights reserved.

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UILabel (LineCounter)
- (NSInteger)needLinesWithWidth:(CGFloat)width;
@end

NS_ASSUME_NONNULL_END
