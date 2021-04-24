//
//  UIImage+GIFImage.h
//  chengfeng
//
//  Created by chengfeng on 2019/9/10.
//  Copyright © 2019 chengfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^GIFimageBlock)(UIImage *GIFImage);

@interface UIImage (GIFImage)


/** 根据本地GIF图片名 获得GIF image对象 */

+ (UIImage *)imageWithGIFNamed:(NSString *)name;



/** 根据一个GIF图片的data数据 获得GIF image对象 */

+ (UIImage *)imageWithGIFData:(NSData *)data;



/** 根据一个GIF图片的URL 获得GIF image对象 */

+ (void)imageWithGIFUrl:(NSString *)url and:(GIFimageBlock)gifImageBlock;

@end
