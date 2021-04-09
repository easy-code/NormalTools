//
//  SavePhoto.m
//
//  Created by chengfeng on 04/09/2021.
//  Copyright (c) 2021 chengfeng. All rights reserved.

#import "SavePhoto.h"

@implementation SavePhoto

+ (void)savePhotoWith:(UIView *)view {
    [SavePhoto saveImageToAlbum:[SavePhoto convertViewToImage:view]];
}

//使用该方法不会模糊，根据屏幕密度计算
+ (UIImage *)convertViewToImage:(UIView *)view {
    
    UIImage *imageRet = [[UIImage alloc]init];
    //UIGraphicsBeginImageContextWithOptions(区域大小, 是否是非透明的, 屏幕密度);
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return imageRet;
}

+ (void)saveImageToAlbum:(UIImage*)image {
    if(image){
        UIImageWriteToSavedPhotosAlbum(image,self,@selector(savedPhotoImage:didFinishSavingWithError:contextInfo:),nil);
    }
}

//保存完成后调用的方法
+ (void) savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError*)error contextInfo: (void*)contextInfo {
    if(error) {
//        [XCProgressHUD showErrorWithStatus:@"图片保存失败，请重试！"];
    }else{
//        [XCProgressHUD showSuccessWithStatus:@"已保存到相册"];
    }
}
@end
