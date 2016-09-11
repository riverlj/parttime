/************************************************************
 *  * EaseMob CONFIDENTIAL
 * __________________
 * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved.
 *
 * NOTICE: All information contained herein is, and remains
 * the property of EaseMob Technologies.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from EaseMob Technologies.
 */

#import <Foundation/Foundation.h>

@interface NSString (Helper)

+ (NSString *)stringWithDateNow;
+ (NSString *)requestStringWithString:(NSString *)pathStr;      //转换请求地址
+ (UIColor *)colorFromHexString:(NSString *)colorStr;           //从16进制转换来的颜色
/**
 *  把时间戳转化成 距离现在的时间间隔
 *
 *  @param time 时间戳
 *
 *  @return 时间间隔字符串
 */
+ (NSString *)dateDistanceFromTimestampe:(NSTimeInterval)time;  //时间间距

+ (NSString *)yearMonthDayFromTimestampe:(NSTimeInterval)time;

+ (NSString *)md5:(NSString *)str;  //MD5加密

+ (NSString *)yearMonthDay:(NSString *)str; //年月日

+ (NSString *)stringForZeroSuppression:(NSString *)numTep; //去零

+ (NSString *)stringTimeIntervalFromTimestampe:(NSTimeInterval)fromTime to:(NSTimeInterval)toTime; //间隔天数
+ (NSString *)firstLetterCapital:(NSString *)str;

- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width;

- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height;

- (BOOL)isPureFloat;
- (BOOL)isPureInt;

//判断image Url 是否在阿里云服务器上
- (Boolean)isAliyImageUrlStr;
@end
