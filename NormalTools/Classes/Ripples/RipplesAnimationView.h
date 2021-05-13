//
//  SearchAnimationView.h
//  MKSmartHome
//
//  Created by MKTech01 on 2021/3/18.
//  Copyright © 2021 MKTECH. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^StartEventHandle)(BOOL selected);

@interface RipplesAnimationView : UIView

@property (copy, nonatomic)StartEventHandle startEventHandle;

- (void)startAnimation;

- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
