//
//  RipplesView.h
//
//  Created by ichengfeng on 2021/05/13.
//  Copyright © 2021 ichengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^StartEventHandle)(BOOL selected);

@interface RipplesView : UIView

@property (copy, nonatomic)StartEventHandle startEventHandle;

- (void)startAnimation;

- (void)stopAnimation;

@end

NS_ASSUME_NONNULL_END
