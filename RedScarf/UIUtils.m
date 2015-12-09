//
//  UIUtils.m
//  RedScarf
//
//  Created by zhangb on 15/8/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "UIUtils.h"
#import <CommonCrypto/CommonDigest.h>


@implementation UIUtils

+ (BOOL)checkPhoneNumInput:(NSString *)text{
//    NSString *regex =@"(13[0-9]|0[1-9]|0[1-9][0-9]|0[1-9][0-9][0-9]|15[0-9]|18[02356789]|17[02356789])\\d{8}";
//    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    return [mobileTest evaluateWithObject:text];
    
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(14[0,0-9])|(17[0,0-9])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:text];
}

+ (NSString *)getSha1String:(NSString *)srcString{
    const char *cstr = [srcString UTF8String];
    //使用对应的CC_SHA1,CC_SHA256,CC_SHA384,CC_SHA512的长度分别是20,32,48,64
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    //使用对应的CC_SHA256,CC_SHA384,CC_SHA512
    CC_SHA1(cstr,  (CC_LONG)strlen(cstr), digest);
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return result;
}

+ (NSString *)replaceAdd:(NSString *)string
{
    if ([string rangeOfString:@"+"].location != NSNotFound) {
       string = [string stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"];
    }
    return string;
}

//验证数字
+ (BOOL)isNumber:(NSString *)str {
    NSString *regex = @"[0-9]{1,25}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [mobileTest evaluateWithObject:str];
}
//验证邮箱
+ (BOOL)isValidateEmail:(NSString *)email {
    
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

//验证姓名  是 4- 12个汉字 或 字母
+ (BOOL)isValidateCharacter:(NSString *)str {
    
    NSString *regex = @"[\u4e00-\u9fa5]{2,14}|[A-Z,a-z]{2,14}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [mobileTest evaluateWithObject:str];
    
}



@end
