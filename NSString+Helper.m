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

#import "NSString+Helper.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Helper)

+ (NSString *)stringWithDateNow
{
    NSDate *date = [[NSDate alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}

+ (NSString *)requestStringWithString:(NSString *)pathStr { //前后各加上一些字符串
	return [self stringWithFormat:@"%@.htm",pathStr];
}

+ (UIColor *)colorFromHexString:(NSString *)colorStr {
    unsigned int r, g, b, al;
    al = 10;
    NSMutableString *cStr = [NSMutableString stringWithString:colorStr];
    [cStr replaceOccurrencesOfString:@"#" withString:@"" options:0 range:NSMakeRange(0, [cStr length])]; //去掉#号
    [[NSScanner scannerWithString:[cStr substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&r];
    [[NSScanner scannerWithString:[cStr substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&g];
    [[NSScanner scannerWithString:[cStr substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&b];
    if ([cStr length] == 8) {
        [[NSScanner scannerWithString:[cStr substringWithRange:NSMakeRange(6, 2)]] scanHexInt:&al];
    }
    return [UIColor colorWithRed:r/255.0 green:g/255.f blue:b/255.f alpha:(float)al/10];
}

+ (NSString *)dateDistanceFromTimestampe:(NSTimeInterval)time {
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval space = ((int)now - time/1000); //间隔的毫秒数
//    HHDPRINT(@"now = %f",now*1000);
    
    int month  = ((int)space)/(3600*24*30);
    int days   = ((int)space)/(3600*24);
    int hours  = ((int)space)%(3600*24)/3600;
    int minute = ((int)space)%(3600*24)/60;
    NSString *dateContent;
    if (month != 0) {
        dateContent = [NSString stringWithFormat:@"1%@", @"个月之前"];
    } else if (days != 0) {
        dateContent = [NSString stringWithFormat:@"%i%@", days, @"天前"];
    } else if (hours != 0) {
        dateContent = [NSString stringWithFormat:@"%i%@", hours, @"小时前"];
    } else {
        dateContent = [NSString stringWithFormat:@"%i%@", minute, @"分钟前"];
    }
    return dateContent;
}

+ (NSString *)md5:(NSString *)str
{
    const char *cStr = [str UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned int)strlen(cStr), result); // This is the md5 call
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ]; 
}

+ (NSString *)yearMonthDayFromTimestampe:(NSTimeInterval)time
{
    NSDate  *date = [NSDate dateWithTimeIntervalSince1970:time];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];

    NSDateFormatter *dateMatter = [[NSDateFormatter alloc] init];
    [dateMatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateMatter stringFromDate:localeDate];
    
    return dateStr;
}

+ (NSString *)yearMonthDay:(NSString *)str
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:str];
    
    NSDateFormatter *dateMatter = [[NSDateFormatter alloc] init];
    [dateMatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateMatter stringFromDate:date];
    
    return dateStr;
}

+ (NSString *)stringForZeroSuppression:(NSString *)numTemp
{
    while ([[numTemp substringFromIndex:numTemp.length - 1] isEqualToString:@"0"] || [[numTemp substringFromIndex:numTemp.length - 1] isEqualToString:@"."]) {
        numTemp = [numTemp substringToIndex:numTemp.length - 1];
    }
    return numTemp;
}

+ (NSString *)stringTimeIntervalFromTimestampe:(NSTimeInterval)fromTime to:(NSTimeInterval)toTime
{
    int space = toTime - fromTime;
    int days   = ((int)space)/(3600*24);
    
    return [NSString stringWithFormat:@"%i", days];
}

+ (NSString *)firstLetterCapital:(NSString *)str
{
    if (str.length == 0)
    {
        return str;
    }
    NSString *tempStr = [str substringToIndex:1];
    NSString *tempStr2 = [str substringFromIndex:1];
    
    tempStr = [tempStr capitalizedString];
    return [tempStr stringByAppendingString:tempStr2];
}

- (CGSize)sizeWithFont:(UIFont *)font byWidth:(CGFloat)width
{
    NSDictionary *dict = @{NSFontAttributeName :font};
    return [self boundingRectWithSize:CGSizeMake(width, 999999.0f) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

- (CGSize)sizeWithFont:(UIFont *)font byHeight:(CGFloat)height
{
    NSDictionary *dict = @{NSFontAttributeName :font};
    return [self boundingRectWithSize:CGSizeMake(999999.0f, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

//判断字符串是否为浮点数
- (BOOL)isPureFloat{
    NSScanner* scan = [NSScanner scannerWithString:self];
    float val;
    return[scan scanFloat:&val] && [scan isAtEnd];
}
//判断是否为整形：
- (BOOL)isPureInt{
    NSScanner* scan = [NSScanner scannerWithString:self];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

- (Boolean)isAliyImageUrlStr {
    NSString *str1 = @"img-cn";
    NSString *str2 = @"aliyuncs.com";
    NSRange range1 = [self rangeOfString:str1];
    NSRange range2 = [self rangeOfString:str2];
    
    if (range1.location!= NSNotFound && range2.location!=NSNotFound ) {
        return YES;
    }else{
        return NO;
    }
}

@end
