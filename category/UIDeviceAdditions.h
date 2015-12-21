//
//  UIDeviceAdditions.h
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIDevice(HardWare)
/* 返回网络状态[None, WiFi, GPRS]
 */
+ (NSString *)networkStatus;
+ (NSString *) utm_campaign;
+ (NSString *) utm_source;
+ (NSString *) utm_content;
+ (BOOL)isPad;
+ (CGFloat)scale;
+ (BOOL)isRetina;
+ (BOOL)isSingleTask;
+ (NSString *)modelName; // 机器类型，iphone或ipad
+ (NSString *)clientVersion;//客户端版本号
@end
