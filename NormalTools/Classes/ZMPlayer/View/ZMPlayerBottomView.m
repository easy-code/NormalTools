//
//  ZMPlayerBottomView.m
//  chengfeng
//
//  Created by chengfeng on 2019/9/10.
//  Copyright © 2019 chengfeng. All rights reserved.
//

#import "ZMPlayerBottomView.h"
#import <Masonry/Masonry.h>
#import "NormalTools-umbrella.h"
@implementation ZMPlayerBottomView

- (UILabel *)currentTime {
    if (!_currentTime) {
        _currentTime = [[UILabel alloc]init];
        _currentTime.textColor = [UIColor whiteColor];
        _currentTime.textAlignment = NSTextAlignmentLeft;
        _currentTime.font = [UIFont systemFontOfSize:12*adjustRatio weight:UIFontWeightRegular];
        [self addSubview:_currentTime];
        [_currentTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.mas_equalTo(14*adjustRatio);
            make.width.mas_equalTo(35*adjustRatio);
            make.height.mas_equalTo(17*adjustRatio);
        }];
    }
    return _currentTime;
}

- (ZMSlider *)slider {
    if (!_slider) {
        _slider = [[ZMSlider alloc]init];
        _slider.maximumTrackTintColor = [UIColor colorWithWhite:1.0 alpha:0.37];
        _slider.minimumTrackTintColor = [UIColor colorWithHexString:@"#ECC98E"];
        _slider.maximumValue = 1;
//        UIImage *imagea=[self OriginImage:[UIImage imageNamed:@"icon_slider"] scaleToSize:CGSizeMake(12*adjustRatio, 12*adjustRatio)];
        [_slider setThumbImage:[UIImage imageNamed:@"icon_slider"] forState:UIControlStateNormal];
        
        [self addSubview:_slider];
        __weak typeof(self)weakself = self;
        [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.currentTime.mas_right).offset(12*adjustRatio);
            make.right.equalTo(weakself.allTime.mas_left).offset(-12*adjustRatio);
            make.centerY.equalTo(self);
            make.height.mas_equalTo(30*adjustRatio);
        }];
    }
    return _slider;
}

/*
 对原来的图片的大小进行处理
 @param image 要处理的图片
 @param size  处理过图片的大小
 */
-(UIImage *)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0,0, size.width, size.height)];
    UIImage *scaleImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaleImage;
}

- (UILabel *)allTime {
    if (!_allTime) {
        _allTime = [[UILabel alloc]init];
        _allTime.textColor = [UIColor whiteColor];
        _allTime.textAlignment = NSTextAlignmentLeft;
        _allTime.font = [UIFont systemFontOfSize:12*adjustRatio weight:UIFontWeightRegular];
        [self addSubview:_allTime];
        [_allTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.right.equalTo(self.fullScreenImageView.mas_left).offset(-12*adjustRatio);
            make.width.mas_lessThanOrEqualTo(45*adjustRatio);
            make.height.mas_equalTo(17*adjustRatio);
        }];
    }
    return _allTime;
}

- (UIImageView *)fullScreenImageView {
    if (!_fullScreenImageView) {
        _fullScreenImageView = [[UIImageView alloc]init];
        _fullScreenImageView.image = [UIImage imageNamed:@"icon_full_screen"];
        _fullScreenImageView.userInteractionEnabled = true;
        [self addSubview:_fullScreenImageView];
        __weak typeof(self)weakself = self;
        [_fullScreenImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(weakself.mas_right).offset(-14*adjustRatio);
            make.centerY.equalTo(weakself.mas_centerY);
        }];
    }
    return _fullScreenImageView;
}
@end
