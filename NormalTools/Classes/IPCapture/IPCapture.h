//
//  IPCapture.h
//  cheng
//
//  Created by chengfeng on 04/09/2021.
//  Copyright (c) 2021 chengfeng. All rights reserved.

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IPCapture : NSObject

///获取链接的路由器的IP
+ (NSString *)getGatewayIPAddress;

///获取设备当前网络IP地址（是获取IPv4 还是 IPv6）
+ (NSString *)getIPAddress:(BOOL)preferIPv4;

@end

NS_ASSUME_NONNULL_END
