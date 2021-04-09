//
//  UIView+WhenTappedBlocks.h
//  cheng
//
//  Created by chengfeng on 04/09/2021.
//  Copyright (c) 2021 chengfeng. All rights reserved.

#if NS_BLOCKS_AVAILABLE

#import <UIKit/UIKit.h>

typedef void (^WhenTappedBlock)(void);

/**
 可在 UIView 中为指定的区域处理触摸操作
 */
@interface UIView (WhenTappedBlocks) <UIGestureRecognizerDelegate>

/*!
 @method
 @abstract 单击
 @param block 代码块
 */
- (void)whenTapped:(WhenTappedBlock)block;

/*!
 @method
 @abstract 双击
 @param block 代码块
 */
- (void)whenDoubleTapped:(WhenTappedBlock)block;

/*!
 @method
 @abstract 两根手指手势
 @param block 代码块
 */
- (void)whenTwoFingerTapped:(WhenTappedBlock)block;

/*!
 @method
 @abstract 向下点击
 @param block 代码块
 */
- (void)whenTouchedDown:(WhenTappedBlock)block;

/*!
 @method
 @abstract 向上点击
 @param block 代码块
 */
- (void)whenTouchedUp:(WhenTappedBlock)block;

@end

#endif
