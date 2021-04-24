//
//  ZMPlayerHeadView.m
//  chengfeng
//
//  Created by chengfeng on 2019/9/10.
//  Copyright © 2019 chengfeng. All rights reserved.
//

#import "ZMPlayerHeadView.h"
#define adjustRatio ([[UIScreen mainScreen] bounds].size.width/375.0)
@implementation ZMPlayerHeadView

- (instancetype)init {
    if (self = [super init]) {
        self.backBtn.hidden = NO;
        self.downloadBtn.hidden = NO;
    }
    return self;
}

- (UIButton *)backBtn {
    if (!_backBtn) {
        _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBtn setImage:[UIImage imageNamed:@"icon_back_white"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backupSuperView:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_backBtn];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(14*adjustRatio);
            make.top.mas_equalTo(59*adjustRatio);
            make.width.mas_equalTo(36*adjustRatio);
        }];
    }
    return _backBtn;
}

- (void)backupSuperView:(UIButton *)sender {
    self.backupBlock(sender);
}

- (UIButton *)downloadBtn {
    if (!_downloadBtn) {
        _downloadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_downloadBtn setTitle:@"下载视频" forState:UIControlStateNormal];
        [_downloadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _downloadBtn.layer.borderColor = [UIColor whiteColor].CGColor;
        _downloadBtn.layer.borderWidth = 1.0;
        _downloadBtn.layer.cornerRadius = 4;
        _downloadBtn.titleLabel.font = [UIFont systemFontOfSize:14*adjustRatio weight:UIFontWeightRegular];
        [_downloadBtn addTarget:self action:@selector(downLoadAction:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_downloadBtn];
        [_downloadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.mas_right).offset(-14*adjustRatio);
            make.centerY.equalTo(self.backBtn);
            make.width.mas_equalTo(85*adjustRatio);
            make.height.mas_equalTo(30*adjustRatio);
        }];
    }
    return _downloadBtn;
}

- (void)downLoadAction:(UIButton *)sender{
    self.downloadBlock(sender);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
