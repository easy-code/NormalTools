//
//  QRCode.h
//  cheng
//
//  Created by chengfeng on 04/09/2021.
//  Copyright (c) 2021 chengfeng. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface QRCode : NSObject
+ (UIImage *)generatorImageWithData:(NSString *)qrContentString;
@end

NS_ASSUME_NONNULL_END
