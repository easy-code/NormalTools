//
//  ZMPlayerHeadView.h
//  chengfeng
//
//  Created by chengfeng on 2019/9/10.
//  Copyright © 2019 chengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Masonry/Masonry.h>
NS_ASSUME_NONNULL_BEGIN
typedef void(^BackupBlock)(UIButton *sender);
typedef void(^DownloadBlock)(UIButton *sender);
@interface ZMPlayerHeadView : UIView
@property(nonatomic,strong)UIButton *backBtn;
@property(nonatomic,strong)UIButton *downloadBtn;
@property(nonatomic,copy)BackupBlock backupBlock;
@property(nonatomic,copy)DownloadBlock downloadBlock;
@end

NS_ASSUME_NONNULL_END
