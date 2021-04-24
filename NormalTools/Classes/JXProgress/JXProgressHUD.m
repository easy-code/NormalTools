//
//  JXProgressHUD.m
//  chengfeng
//
//  Created by chengfeng on 2019/9/10.
//  Copyright © 2019 chengfeng. All rights reserved.
//

#import "JXProgressHUD.h"
#import "UIImage+GIFImage.h"

@implementation JXProgressHUD

+ (void)config {
    [SVProgressHUD setMinimumDismissTimeInterval:2];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:13]];
//    [SVProgressHUD setInfoImage:[UIImage imageWithGIFNamed:@"loading"]];
}
//+ (void)showWithStatus:(NSString *)status {
//    [super showWithStatus:status];
//    SVProgressHUD *view =  (SVProgressHUD*)[SVProgressHUD performSelector:@selector(sharedView)];
//    NSArray *subs = [[UIApplication sharedApplication].keyWindow subviews];
//    if (subs.count>0) {
//        [[UIApplication sharedApplication].keyWindow bringSubviewToFront:subs.firstObject];
//    }
//    
//}
//+ (void)show {
//    [SVProgressHUD setImageViewSize:CGSizeMake(62, 62)];
//    [super showInfoWithStatus:@""];
//}
//
//+ (void)dismiss {
//    
//}
//
//+ (void)showWithStatus:(NSString *)status {
//    [SVProgressHUD setImageViewSize:CGSizeMake(62, 62)];
//    [super showInfoWithStatus:status];
//}
//
+ (void)showErrorWithStatus:(NSString*)status {
    if (status && status.length > 0) {
        [super showErrorWithStatus: status];
    }
//    [SVProgressHUD setImageViewSize:CGSizeMake(20, 20)];
////    [self showImage:[UIImage imageWithGIFNamed:@"loading"] status:status];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self dismiss];
//    });
}
//
//+ (void)showSuccessWithStatus:(NSString*)status {
//    [super showSuccessWithStatus: status];
//    [SVProgressHUD setImageViewSize:CGSizeMake(20, 20)];
//    //    [self showImage:[UIImage imageWithGIFNamed:@"loading"] status:status];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self dismiss];
//    });
//}

@end
