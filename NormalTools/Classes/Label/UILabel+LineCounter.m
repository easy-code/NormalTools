//
//  UILabel+LineCounter.m
//  cheng
//
//  Created by chengfeng on 04/09/2021.
//  Copyright (c) 2021 chengfeng. All rights reserved.

#import "UILabel+LineCounter.h"

@implementation UILabel (LineCounter)

- (NSInteger)needLinesWithWidth:(CGFloat)width {
    UILabel *label = [[UILabel alloc]init];
    label.font = self.font;
    NSString *text = self.text;
    NSInteger sum = 0;
    NSArray *rowType = [text componentsSeparatedByString:@"\n"];
    for (NSString *currentText in rowType) {
        label.text = currentText;
        //获取需要大size
        CGSize textSize = [label systemLayoutSizeFittingSize:CGSizeZero];
        NSInteger lines = ceilf(textSize.width/width);
        lines = lines == 0 ? 1:lines;
        sum += lines;
    }
    return sum;
}

@end
