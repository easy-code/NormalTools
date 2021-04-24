//
//  ZMPlayerController.h
//  chengfeng
//
//  Created by chengfeng on 2019/9/10.
//  Copyright © 2019 chengfeng. All rights reserved.
//

#import "ZMPlayerController.h"
#import "ZMPlayerHeadView.h"
#import "ZMPlayerBottomView.h"
#import <AFNetworking/AFNetworking.h>
#import "UIColor+AddColor.h"
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width

typedef NS_ENUM(NSInteger, PlayerStatu){
    None,
    End,
    Play,
    Pause
};
@interface ZMPlayerController ()<NSURLSessionDelegate>
{
    BOOL controlIsHidden;
    BOOL badNetworkToPause;
    BOOL isDownLoad;
}
@property(nonatomic,strong)ZMPlayerHeadView *headView;
@property(nonatomic,strong)ZMPlayerBottomView *bottomView;
@property(nonatomic,strong)UIButton *playButton;
@property(nonatomic,strong)UIButton *unlockButton;

@property (nonatomic) id playerObserve;
@property (nonatomic,assign) PlayerStatu playerStatu;
@property (nonatomic,assign) BOOL isSliding;
@property (nonatomic,assign) CGFloat duration;
@property (nonatomic,assign) CGFloat fps;
@property (nonatomic,strong)UITapGestureRecognizer *sliderTap;
@property (nonatomic)UIDeviceOrientation orientation;

@property (nonatomic,strong)UIAlertController *alertControl;

@property(nonatomic,strong)NSURLSessionDownloadTask *downloadTask;

@property(nonatomic,assign)AFNetworkReachabilityStatus networkStatus;

@end

@implementation ZMPlayerController

- (void)dealloc {
    [JXProgressHUD dismiss];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player removeTimeObserver:self.playerObserve];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarHidden = YES;
    [self monitorControlNetworkEnvironment];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self.downloadTask cancel];
    [JXProgressHUD dismiss];
    [self.alertControl removeFromParentViewController];
    [self.alertControl dismissViewControllerAnimated:false completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.headView.hidden = NO;
    self.unlockButton.hidden = YES;
    
    self.orientation = UIDeviceOrientationPortrait;
    
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    [self initAVPlayerWithVideoURL:self.videoUrl];
    self.bottomView.fullScreenImageView.hidden = false;
    self.bottomView.slider.value = 0.0;
    self.bottomView.allTime.text = [NSString stringWithFormat:@"%@",[self convert:self.duration]];
}

#pragma mark ---------- 网络状态监控 ------------
/**
 网络监控
 */
- (void)monitorControlNetworkEnvironment {
    // 1.获得网络监控的管理者
    AFNetworkReachabilityManager *netmanager = [AFNetworkReachabilityManager sharedManager];
    
    // 2.设置网络状态改变后的处理
    [netmanager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 当网络状态改变了, 就会调用这个block
        self.networkStatus = status;
        switch (status) {
            case AFNetworkReachabilityStatusUnknown: // 未知网络
            {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 通知主线程刷新
                    [JXProgressHUD showInfoWithStatus:@"未知网络!"];
//                    CGFloat degree = [self getTransformWithOriention:self.orientation];
//                    [self changeHubWithDegree:degree];
                });

                self->badNetworkToPause = YES;
                if (self.playerStatu == Play) {
                    self.playerStatu = Pause;
                }
            }
                break;
                
            case AFNetworkReachabilityStatusNotReachable: // 没有网络(断网)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    // 通知主线程刷新
                    [JXProgressHUD showInfoWithStatus:@"网络中断!"];
//                    CGFloat degree = [self getTransformWithOriention:self.orientation];
//                    [self changeHubWithDegree:degree];
                });
                
                self->badNetworkToPause = YES;
                if (self.playerStatu == Play) {
                    self.playerStatu = Pause;
                }
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN: // 手机自带网络
            {
                if (self.playerStatu == Play) {
                    self.playerStatu = Pause;
                }
                
                NSInteger keepPlay = [[NSUserDefaults standardUserDefaults] integerForKey:@"KeepsPlay"];
                if (keepPlay!=2) {
                    [self.alertControl removeFromParentViewController];
                    [self.alertControl dismissViewControllerAnimated:false completion:nil];
                    self.alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前处于移动网络状态，是否需要继续播放" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"取消播放" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    UIAlertAction *playAction = [UIAlertAction actionWithTitle:@"继续播放" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        if (self.playerStatu == Pause) {
                            self.playerStatu = Play;
                        }
                    }];
                    [self.alertControl addAction:openAction];
                    [self.alertControl addAction:playAction];
                    
                    [self presentViewController:self.alertControl animated:true completion:^{
                        CGFloat degree = [self getTransformWithOriention:self.orientation];
                        self.alertControl.view.transform = CGAffineTransformMakeRotation(degree);
                    }];
                }else {
                    if (self.playerStatu == Pause) {
                        self.playerStatu = Play;
                    }
                }
                
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi: // WIFI
            {
                if (self->badNetworkToPause) {
                    [self.alertControl removeFromParentViewController];
                    [self.alertControl dismissViewControllerAnimated:false completion:nil];
                    
                    [JXProgressHUD dismiss];
                    [JXProgressHUD showSuccessWithStatus:@"已连接WiFi!"];
                    
                    self.playerStatu = Play;
                }
            }
                break;
        }
    }];
    
    // 3.开始监控
    [netmanager startMonitoring];
}

#pragma mark ---------- 翻转屏幕 ----------
//是否允许自动切换
-(BOOL)shouldAutorotate{
    
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskAll;
}

////横屏
- (void)deviceOrientationDidChange
{
    
    if (self.unlockButton.isSelected) {
        return;
    }
    
    UIDeviceOrientation currentOrientation = [UIDevice currentDevice].orientation;
    if (currentOrientation == UIDeviceOrientationFaceUp || currentOrientation == UIDeviceOrientationFaceDown || currentOrientation == UIDeviceOrientationUnknown) {
    }else {
        self.orientation = currentOrientation;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        // 通知主线程刷新
        [UIView animateWithDuration:0.1f animations:^{
            CGFloat degree = [self getTransformWithOriention:self.orientation];
            
            self.alertControl.view.transform = CGAffineTransformMakeRotation(degree);
            
            if (UIDeviceOrientationIsLandscape(self.orientation)) {
                self.unlockButton.hidden = NO;
                [self setSubviewFrameForLandscape];
            }
            if (UIDeviceOrientationIsPortrait(self.orientation)) {
                self.unlockButton.hidden = YES;
                [self setSubviewFrameForPortrait];
            }
            
            self.view.transform = CGAffineTransformMakeRotation(degree);
            [self recoveryHideSelector];

            if (self->isDownLoad) {
                [self changeHubWithDegree:degree];
            }
        }];
    });
}

- (CGFloat)getTransformWithOriention:(UIDeviceOrientation)oriention {
    if (oriention == UIDeviceOrientationPortrait) {
        return 0;
    }else if (oriention == UIDeviceOrientationPortraitUpsideDown) {
        return M_PI;
    }else if (oriention == UIDeviceOrientationLandscapeLeft) {
        return M_PI_2;
    }else if (oriention == UIDeviceOrientationLandscapeRight) {
        return -M_PI_2;
    }else {
        return 0;
    }
}

- (void)changeHubWithDegree:(CGFloat)degree {
    if ([SVProgressHUD respondsToSelector:@selector(sharedView)] && [SVProgressHUD isVisible]) {
        SVProgressHUD *hub = [SVProgressHUD performSelector:@selector(sharedView)];
        hub.transform = CGAffineTransformMakeRotation(degree);
        [hub mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.height.mas_equalTo(150*adjustRatio);
        }];
    }
}

/**
 竖屏
 */
- (void)setSubviewFrameForPortrait {
    self.view.bounds = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.headView.backgroundColor = [UIColor blackColor];
    __weak typeof(self)weakself = self;
    [_headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(weakself.view);
        make.height.mas_equalTo(116*adjustRatio);
    }];
    [self.headView.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14*adjustRatio);
        make.top.mas_equalTo(59*adjustRatio);
        make.width.mas_offset(36*adjustRatio);
    }];
    
    self.bottomView.backgroundColor = [UIColor blackColor];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(weakself.view);
        make.height.mas_equalTo(88*adjustRatio);
    }];
    [self.bottomView.fullScreenImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomView.mas_right).offset(-14*adjustRatio);
        make.centerY.equalTo(weakself.bottomView.mas_centerY);
    }];
    
    self.playerLayer.frame =CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
}

/**
 横屏
 */
- (void)setSubviewFrameForLandscape {
    self.view.bounds = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    
    self.headView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.62];
    __weak typeof(self)weakself = self;
    [self.headView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(24*adjustRatio);
        make.left.mas_equalTo(52*adjustRatio);
        make.right.mas_equalTo(weakself.view.mas_right).offset(-52*adjustRatio);
        make.height.mas_equalTo(44*adjustRatio);
    }];
    [self.headView.backBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(14*adjustRatio);
        make.centerY.equalTo(weakself.headView.mas_centerY);
        make.width.mas_offset(36*adjustRatio);
    }];
    
    
    self.bottomView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.62];
    [self.bottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-24*adjustRatio);
        make.left.mas_equalTo(52*adjustRatio);
        make.right.mas_equalTo(weakself.view.mas_right).offset(-52*adjustRatio);
        make.height.mas_equalTo(40*adjustRatio);
    }];
    [self.bottomView.fullScreenImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakself.bottomView.mas_right).offset(-14*adjustRatio);
        make.width.mas_equalTo(0);
    }];
    
    self.playerLayer.frame =CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
}

- (NSString *)convert:(CGFloat)time{
    int minute = time / 60;
    int second = time - minute * 60;
    NSString *minuteString;
    NSString *secondString;
    if(minute < 10){
        minuteString = [NSString stringWithFormat:@"0%d", minute];
    }else{
        minuteString = [NSString stringWithFormat:@"%d", minute];
    }
    if(second < 10){
        secondString = [NSString stringWithFormat:@"0%d", second];
    }else{
        secondString = [NSString stringWithFormat:@"%d", second];
    }
    return [NSString stringWithFormat:@"%@:%@", minuteString, secondString];
}

#pragma mark ---------- PlaybackFinished -----------
// 视频循环播放
- (void)moviePlayDidEnd:(NSNotification*)notification{
    AVPlayerItem*item = [notification object];
    [item seekToTime:kCMTimeZero];
    self.playerStatu = Play;
}

#pragma mark ---------- 下载视频 -----------
//先判断网络，不是Wi-Fi需要先提醒
- (void)checkNetworkEnvironment {
    self.playerStatu = Pause;
    if (![[AFNetworkReachabilityManager sharedManager] isReachableViaWiFi]) {
        [self.alertControl removeFromParentViewController];
        self.alertControl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"当前处于移动网络状态，下载视频需要消耗流量" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *openAction = [UIAlertAction actionWithTitle:@"取消下载" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        }];
        UIAlertAction *playAction = [UIAlertAction actionWithTitle:@"保存视频" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self downLoadAction];
        }];
        [self.alertControl addAction:openAction];
        [self.alertControl addAction:playAction];

        [self presentViewController:self.alertControl animated:true completion:^{
            CGFloat degree = [self getTransformWithOriention:self.orientation];
            self.alertControl.view.transform = CGAffineTransformMakeRotation(degree);
        }];
    }else {
        [self downLoadAction];
    }
}

- (void)downLoadAction {
    __weak typeof(self)weakself = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.videoUrl.length > 0) {
            [self startDownLoadVedioWithModel:weakself.videoUrl];
        }
    });
}

/** 下载视频 */
- (void)startDownLoadVedioWithModel:(NSString *)videoUrl {
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    
    self.downloadTask = [session downloadTaskWithURL:[NSURL URLWithString:videoUrl]];
    [self.downloadTask resume];
}

#pragma mark ---------- NSSessionUrlDelegate ----------
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    //下载进度
    CGFloat progress = totalBytesWritten / (double)totalBytesExpectedToWrite;
    dispatch_async(dispatch_get_main_queue(), ^{
        //进行UI操作  设置进度条
        NSString *progressString = [NSString stringWithFormat:@"%.0f%%",progress *100];
        [JXProgressHUD showProgress:progress status:progressString];
        self->isDownLoad = YES;
        if (progress == 1.0) {
            [JXProgressHUD dismiss];
            [JXProgressHUD showSuccessWithStatus:@"下载成功，请到本地相册查看!"];
            self->isDownLoad = NO;
        }
        CGFloat degree = [self getTransformWithOriention:self.orientation];
        [self changeHubWithDegree:degree];
    });
}
//下载完成 保存到本地相册
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location
{
    //1.拿到cache文件夹的路径
    NSString *cache=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)lastObject];
    //2,拿到cache文件夹和文件名
    NSString *file=[cache stringByAppendingPathComponent:downloadTask.response.suggestedFilename];
    
    [[NSFileManager defaultManager] moveItemAtURL:location toURL:[NSURL fileURLWithPath:file] error:nil];
    //3，保存视频到相册
    if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(file)) {
        //保存相册核心代码
        UISaveVideoAtPathToSavedPhotosAlbum(file, self, nil, nil);
    }
}

#pragma mark ---------- 隐藏默认导航 ----------
- (BOOL)isNavigationBarHidden {
    return true;
}

#pragma mark ---------- Action ----------
- (void)handleTouchDown:(UISlider *)slider{
    NSLog(@"TouchDown");
    _sliderTap.enabled = NO;
    [self cancelHideSelector];
    _isSliding = YES;
    if(_playerStatu == Play){
        _playerStatu = Pause;
    }
}

- (void)handleTouchUp:(UISlider *)slider{
    NSLog(@"TouchUp");
    _sliderTap.enabled = YES;
    _isSliding = NO;
    if(_playerStatu == Pause){
       _playerStatu = Play;
    }
}

- (void)handleSlide:(UISlider *)slider{
    [self cancelHideSelector];
    CMTime time = CMTimeMakeWithSeconds(_duration * slider.value, _fps);
    
    NSString *timeText = [NSString stringWithFormat:@"%@", [self convert:_duration * slider.value]];
    _bottomView.currentTime.text = timeText;
    
    [_player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

- (void)handleTap:(UITapGestureRecognizer *)recognizer{
    CGPoint touchPoint = [recognizer locationInView:_bottomView.slider];
    CGFloat value = touchPoint.x / CGRectGetWidth(_bottomView.slider.frame);
    [_bottomView.slider setValue:value animated:YES];
    
    if(_playerStatu == Play){
        _playerStatu = Pause;
    }
    CMTime time = CMTimeMakeWithSeconds(_duration * value, _fps);
    __weak typeof(self) weakSelf = self;
    [_player seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
        if(self.playerStatu == Pause){
            weakSelf.playerStatu = Play;
        }
    }];
}

- (void)playOrPauseAction:(UIButton *)sender {
    if (sender.isSelected) {
        //播放
        self.playerStatu = Play;
    }else {
        //暂停
        self.playerStatu = Pause;
    }
}

- (void)unlockAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.isSelected) {
        //锁定
        [self hideControllView];
    }else {
        //解锁
        [self showControllView];
    }
}

#pragma mark ----------- setter -----------
//-(void)setVideoUrl:(NSString *)videoUrl {
//    _videoUrl = videoUrl;
//    [self initAVPlayerWithVideoURL:videoUrl];
//}

- (void)setPlayerStatu:(PlayerStatu)playerStatu {
    _playerStatu = playerStatu;
    if (playerStatu == Play) {
        [self.player play];
        self.bottomView.slider.userInteractionEnabled = YES;
        self.playButton.selected = NO;
        badNetworkToPause = NO;
    }else {
        [self.player pause];
        self.bottomView.slider.userInteractionEnabled = NO;
        self.playButton.selected = YES;
    }
    [self recoveryHideSelector];
}

#pragma mark--恢复隐藏控制器--
-(void)recoveryHideSelector{
    
    [self performSelector:@selector(hideControllView) withObject:nil afterDelay:5];
    
}

#pragma mark---取消隐藏控制器
-(void)cancelHideSelector{
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideControllView) object:nil];
}

- (void)showControllView {
    if (!self.unlockButton.isSelected) {
        self.headView.hidden = NO;
        self.bottomView.hidden = NO;
        self.playButton.hidden = NO;
        controlIsHidden = NO;
        if (UIDeviceOrientationIsLandscape(self.orientation)) {
            self.unlockButton.hidden = NO;
            self.unlockButton.selected = NO;
        }
    }else {
        self.unlockButton.hidden = NO;
        [self cancelHideSelector];
    }
    [self recoveryHideSelector];
}

- (void)hideControllView {
    
    self.headView.hidden = YES;
    self.bottomView.hidden = YES;
    if (self.playerStatu == Pause) {
        self.playButton.hidden = NO;
    }else {
        self.playButton.hidden = YES;
    }
    controlIsHidden = YES;
    if (!self.unlockButton.hidden) {
        [self performSelector:@selector(hideUnlockButton) withObject:nil afterDelay:5];
    }
}

- (void)hideUnlockButton {
    self.unlockButton.hidden = YES;
}

#pragma mark ----------- UI -----------
- (ZMPlayerHeadView *)headView {
    if (!_headView) {
        _headView = [[ZMPlayerHeadView alloc]init];
        _headView.backgroundColor = [UIColor colorWithHexString:@"#000000"];
        [self.view addSubview:_headView];
        __weak typeof(self)weakself = self;
        [_headView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.equalTo(weakself.view);
            make.height.mas_equalTo(116*adjustRatio);
        }];
        
        _headView.backupBlock = ^(UIButton * _Nonnull sender) {
            [weakself backupSuperView];
        };
        
        _headView.downloadBlock = ^(UIButton * _Nonnull sender) {
            [weakself checkNetworkEnvironment];
        };
    }
    return _headView;
}

- (void)backupSuperView {
    if (UIDeviceOrientationIsLandscape(self.orientation)) {
        [UIView animateWithDuration:0.1f animations:^{
            self.view.transform = CGAffineTransformMakeRotation(0);
            [self setSubviewFrameForPortrait];
            self.orientation = UIDeviceOrientationPortrait;
            self.unlockButton.hidden = YES;
        }];
    }else {
        self.playerStatu = Pause;
        // 1.获得网络监控的管理者
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager stopMonitoring];
        [self dismissViewControllerAnimated:true completion:nil];
    }
}

- (ZMPlayerBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[ZMPlayerBottomView alloc]init];
        _bottomView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:_bottomView];
        __weak typeof(self)weakself = self;
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(weakself.view);
            make.height.mas_equalTo(88*adjustRatio);
        }];
        
        UITapGestureRecognizer *fullScreenGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedAction)];
        [_bottomView.fullScreenImageView addGestureRecognizer:fullScreenGes];
        
        
        [_bottomView.slider addTarget:self action:@selector(handleTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_bottomView.slider addTarget:self action:@selector(handleSlide:) forControlEvents:UIControlEventValueChanged];
        [_bottomView.slider addTarget:self action:@selector(handleTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        [_bottomView.slider addTarget:self action:@selector(handleTouchUp:) forControlEvents:UIControlEventTouchUpOutside];
        
        _sliderTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
        [_sliderTap setNumberOfTouchesRequired:1];
        [_bottomView.slider addGestureRecognizer:_sliderTap];
        
    }
    return _bottomView;
}

- (void)tappedAction {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        // NSLog(@"全屏播放");
        [UIView animateWithDuration:0.1f animations:^{
            self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
            [self setSubviewFrameForLandscape];
            self.orientation = UIDeviceOrientationLandscapeLeft;
            self.unlockButton.hidden = NO;
        }];
    }
}

- (void)initAVPlayerWithVideoURL:(NSString *)videoUrl {

    NSURL *pathUrl = [NSURL URLWithString:videoUrl];
    
    self.playerItem = [[AVPlayerItem alloc] initWithURL:pathUrl];
    _duration = CMTimeGetSeconds(self.playerItem.asset.duration);
    NSArray *tracksArray = [self.playerItem.asset tracksWithMediaType:AVMediaTypeVideo];
    _fps = tracksArray.count > 0 ? [[tracksArray objectAtIndex:0] nominalFrameRate] : 1;
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    self.playerLayer.backgroundColor = [UIColor colorWithHexString:@"#000000"].CGColor;
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:self.playerLayer atIndex:0];
    //播放暂停按钮
    [self.view addSubview:self.playButton];
    [self.playButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    
    //用弱引用避免互相引用
    __weak typeof(self) weakSelf = self;
    //对于1分钟以内的视频就每1/30秒刷新一次页面，大于1分钟的每秒一次就行
    CMTime interval = _duration > 60 ? CMTimeMake(1, 1) : CMTimeMake(1, 30);
    //这个方法就是每隔多久调用一次block，函数返回的id类型的对象在不使用时用-removeTimeObserver:释放，官方api是这样说的
    _playerObserve = [_player addPeriodicTimeObserverForInterval:interval queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if(!weakSelf.isSliding){
            CGFloat currentTime = CMTimeGetSeconds(time);
            weakSelf.bottomView.currentTime.text = [NSString stringWithFormat:@"%@", [weakSelf convert:currentTime]];
            
            weakSelf.bottomView.slider.value = currentTime / weakSelf.duration;
        }
    }];
    self.playerStatu = Play;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showAction:)];
    [self.view addGestureRecognizer:tapGes];
    
}

- (void)showAction:(id)sender {
    UITapGestureRecognizer *gestureRecognizer = (UITapGestureRecognizer *)sender;
    CGPoint point = [gestureRecognizer locationInView:self.bottomView];
    CALayer *layer1=[[self.playerLayer presentationLayer] hitTest:point];
    if (layer1==nil) {
        if (self->controlIsHidden) {
            [self showControllView];
        }else {
            [self hideControllView];
        }
    }
}

- (UIButton *)playButton {
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:@"icon_pause_white"] forState:UIControlStateNormal];
        [_playButton setImage:[UIImage imageNamed:@"icon_play_white"] forState:UIControlStateSelected];
        [_playButton addTarget:self action:@selector(playOrPauseAction:) forControlEvents:UIControlEventTouchUpInside];
        _playButton.selected = YES;
    }
    return _playButton;
}

- (UIButton *)unlockButton {
    if (!_unlockButton) {
        _unlockButton = [[UIButton alloc]init];
        [_unlockButton setImage:[UIImage imageNamed:@"icon_unlock_gray"] forState:UIControlStateNormal];
        [_unlockButton setImage:[UIImage imageNamed:@"icon_lock_gray"] forState:UIControlStateSelected];
        [_unlockButton addTarget:self action:@selector(unlockAction:) forControlEvents:UIControlEventTouchUpInside];
        _unlockButton.selected = NO;
        [self.view addSubview:_unlockButton];
        [_unlockButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.view);
            make.right.equalTo(self.view.mas_right).offset(-52*adjustRatio);
        }];
    }
    return _unlockButton;
}

@end
