//
//  ZMPlayerController.h
//  chengfeng
//
//  Created by chengfeng on 2019/9/10.
//  Copyright © 2019 chengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "JXProgressHUD.h"
NS_ASSUME_NONNULL_BEGIN
#define adjustRatio ([[UIScreen mainScreen] bounds].size.width/375.0)
@interface ZMPlayerController : UIViewController

@property(nonatomic,strong)AVPlayer *player;
@property(nonatomic,strong)AVPlayerItem *playerItem;
@property(nonatomic,strong)AVPlayerLayer *playerLayer;
@property(nonatomic,strong)NSString *videoUrl;
@end

NS_ASSUME_NONNULL_END
