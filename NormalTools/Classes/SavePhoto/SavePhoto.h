//
//  SavePhoto.h
//  cheng
//
//  Created by chengfeng on 04/09/2021.
//  Copyright (c) 2021 chengfeng. All rights reserved.


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SavePhoto : NSObject<UIImagePickerControllerDelegate>

//将view转换成image，然后保存到本地相册
+ (void)savePhotoWith:(UIView *)view;
//保存图片到本地相册
+ (void)saveImageToAlbum:(UIImage*)image;
//将view转换成image
+ (UIImage *)convertViewToImage:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
