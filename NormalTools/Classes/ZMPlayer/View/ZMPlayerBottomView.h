//
//  ZMPlayerBottomView.h
//  chengfeng
//
//  Created by chengfeng on 2019/9/10.
//  Copyright © 2019 chengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZMSlider.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZMPlayerBottomView : UIView
@property(nonatomic,strong)UILabel *currentTime;
@property(nonatomic,strong)UILabel *allTime;
@property(nonatomic,strong)ZMSlider *slider;
@property(nonatomic,strong)UIImageView *fullScreenImageView;

@end

NS_ASSUME_NONNULL_END
