//
//  NSString+RSHttp.m
//  RedScarf
//
//  Created by lishipeng on 15/12/7.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "NSString+RSHttp.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(RSHttp)
- (NSString *)append:(NSString *)string {
    return [NSString stringWithFormat:@"%@%@",self,string];
}

-(NSString *) sha1
{
    const char *cstr = [self UTF8String];
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

-(NSString *) urlWithHost:(NSString *)host
{
    if(!host) {
        host = REDSCARF_BASE_URL;
    }
    NSString *urlstr;
    //如果当前url以http://或https开头，则跳过
    if([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"]) {
        urlstr = self;
    } else {
        urlstr = [NSString stringWithFormat:@"%@%@", host, self];
    }
    //解析url
    NSString *urlPrefix = [urlstr parseHostFromURLString];
    NSMutableDictionary *urlParams = [[[urlstr parseParamsFromURLString] parseURLParams] mutableCopy];
    //添加token
    if([urlPrefix hasPrefix:REDSCARF_PAY_URL]) {
        NSString *token = [NSString URLencode:[NSUserDefaults getValue:@"withdrawToken"] stringEncoding:NSUTF8StringEncoding];
        if(token) {
            [urlParams setObject:token forKey:@"token"];
        }
    } else if([urlPrefix hasPrefix:REDSCARF_BASE_URL]) {
        NSString *token = [NSString URLencode:[NSUserDefaults getValue:@"token"] stringEncoding:NSUTF8StringEncoding];
        if(token) {
            [urlParams setObject:token forKey:@"token"];
        }
    }
    [urlParams setObject:[NSString URLencode:[UIDevice utm_content] stringEncoding:NSUTF8StringEncoding]  forKey:@"utm_content"];
    [urlParams setObject:[NSString URLencode:[UIDevice utm_campaign] stringEncoding:NSUTF8StringEncoding] forKey:@"utm_campaign"];
    [urlParams setObject:[NSString URLencode:[UIDevice utm_source] stringEncoding:NSUTF8StringEncoding]  forKey:@"utm_source"];
    [urlParams setObject:[NSString URLencode:[UIDevice modelName] stringEncoding:NSUTF8StringEncoding]   forKey:@"utm_media"];
    [urlParams setObject:[UIDevice clientVersion] forKey:@"utm_term"];
    return [[urlPrefix append:@"?"] append:[NSString urlParameterWithDictionary:urlParams]];
}


+ (NSString*)URLencode:(NSString*)originalString stringEncoding:(NSStringEncoding)stringEncoding
{
    if (originalString == nil) {
        return nil;
    }
    NSArray *escapeChars = [NSArray arrayWithObjects:@";", @"/" , @"?" , @":",@"@" , @"&" , @"=" , @"+" ,@"$", @",",@"!", @"'", @"(", @")", @"*", nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F", @"%3F" , @"%3A" , @"%40" , @"%26" , @"%3D" , @"%2B" , @"%24" , @"%2C" ,@"%21", @"%27", @"%28", @"%29", @"%2A", nil];
    
    NSUInteger len =[escapeChars count];
    NSMutableString *temp = [[originalString stringByAddingPercentEscapesUsingEncoding:stringEncoding] mutableCopy];
    for(NSUInteger i = 0; i < len; i++)
    {
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i] withString:[replaceChars objectAtIndex:i] options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    }
    NSString *outStr = [NSString stringWithString:temp];
    return outStr;
}


+ (NSString *)urlParameterWithDictionary:(NSDictionary *)params {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    NSArray *keysArray = [params allKeys];
    for (int index = 0; index < [keysArray count]; index ++) {
        NSString *key = [keysArray objectAtIndex:index];
        NSString *keyValue = [params objectForKey:key];
        if (key && keyValue) {
            NSString *component = [NSString stringWithFormat:@"%@=%@",key,keyValue];
            [mutableQueryStringComponents addObject:component];
        }
    }
    NSString *urlParameter = [mutableQueryStringComponents componentsJoinedByString:@"&"];
    return urlParameter;
}

+ (NSDictionary *)parseInfoFromURLString:(NSString *)pagramsInfoString {
    
    NSMutableDictionary *paragrmsDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *pagramArray = [pagramsInfoString componentsSeparatedByString:@"&"];
    for (NSString *pagramString in pagramArray) {
        NSArray *pagramValueAndName = [pagramString componentsSeparatedByString:@"="];
        if ([pagramValueAndName count] >= 2) {
            NSString *name = [pagramValueAndName objectAtIndex:0];
            NSString *value = [pagramValueAndName objectAtIndex:1];
            
            if (name && value) {
                [paragrmsDict setObject:value forKey:name];
            }
        }
    }
    
    return paragrmsDict;
}

-(NSDictionary *) parseUrl
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"", @"protocol",
                                 @"", @"path", [NSDictionary dictionary], @"params", nil];
    NSArray *pagramArray = [self componentsSeparatedByString:@"://"];
    NSString *tempStr;
    if([pagramArray count] > 1) {
        [dict setObject:pagramArray[0] forKey:@"protocol"];
        tempStr = pagramArray[1];
    } else {
        tempStr = pagramArray[0];
    }
    [dict setObject:[tempStr parseHostFromURLString] forKey:@"path"];
    [dict setObject:[tempStr parseURLParams] forKey:@"params"];
    return [dict copy];
}

-(NSString *) parseHostFromURLString
{
    NSArray *pagramArray = [self componentsSeparatedByString:@"?"];
    if([pagramArray count] > 0) {
        return pagramArray[0];
    }
    return nil;
}

-(NSString *) parseParamsFromURLString
{
    NSArray *pagramArray = [self componentsSeparatedByString:@"?"];
    if([pagramArray count] > 1) {
        return pagramArray[1];
    }
    return @"";
}

- (NSDictionary *)parseURLParams {
    NSMutableDictionary *paragrmsDict = [NSMutableDictionary dictionaryWithCapacity:0];
    NSArray *pagramArray = [self componentsSeparatedByString:@"&"];
    for (NSString *pagramString in pagramArray) {
        NSArray *pagramValueAndName = [pagramString componentsSeparatedByString:@"="];
        if ([pagramValueAndName count] >= 2) {
            NSString *name = [pagramValueAndName objectAtIndex:0];
            NSString *value = [pagramValueAndName objectAtIndex:1];
            
            if (name && value) {
                [paragrmsDict setObject:value forKey:name];
            }
        }
    }
    
    return paragrmsDict;
}

+ (NSArray *)phoneNumberFromString:(NSString*)orginalStr {
    
    NSMutableArray *phonesArray = [NSMutableArray array];
    // 取第一个phonenumber
    NSMutableString *phoneNumber = [NSMutableString string];
    NSString *phoneNumberSet = @"1234567890-—";
    BOOL numberStart = NO;
    for (int index = 0; index < orginalStr.length; index ++) {
        NSString *subString = [orginalStr substringWithRange:NSMakeRange(index, 1)];
        if ([phoneNumberSet rangeOfString:subString].length > 0) {
            if ([subString isEqualToString:@"-"] || [subString isEqualToString:@"—"]) {
                continue;
            }
            numberStart = YES;
            [phoneNumber appendString:subString];
        }
        else if(!numberStart) {
            continue;
        }
        else {
            [phonesArray addObject:[NSString stringWithFormat:@"呼叫%@", phoneNumber]];
            phoneNumber = [NSMutableString string];
            numberStart = NO;
        }
        
        if (index == orginalStr.length - 1 && phoneNumber.length > 0) {
            [phonesArray addObject:[NSString stringWithFormat:@"呼叫%@", phoneNumber]];
        }
    }
    
    
    return phonesArray;
}


// 此函数作用在于确保number转为string ,只保留两位小数
+ (NSString *)stringFromNumber:(NSNumber *)number {
    
    CGFloat floatValue = [number floatValue];
    NSString *result = [number stringValue];
    NSRange pointRange = [result rangeOfString:@"."];
    if (pointRange.length > 0 && pointRange.location < result.length -2) {
        result = [NSString stringWithFormat:@"%.2f",floatValue];
    }
    
    return result;
}

+ (NSString *)moneyStringWithNumber:(NSNumber *)floatNumber {// 将价格变成字符串，前面加人民币符号
    return [@"￥" append:[NSString stringFromNumber:floatNumber]];
}

+ (NSString *)stringWithFloat:(float)number {
    NSNumber *floatNumber = [NSNumber numberWithFloat:number];
    return [NSString stringFromNumber:floatNumber];
}

+ (NSString *)moneyStringWithFloat:(float)number{
    NSNumber *floatNumber = [NSNumber numberWithFloat:number];
    return [NSString moneyStringWithNumber:floatNumber];
}


- (NSString *)addString:(NSString *)string every:(NSInteger)charCount {
    NSMutableString *newString = [NSMutableString string];
    int i;
    for (i=1; i< 1.0*self.length/charCount; i++) {
        [newString appendString:[self substringWithRange:NSMakeRange(charCount*(i-1), charCount)]];
        [newString appendString:string];
    }
    [newString appendString:[self substringFromIndex:charCount*(i-1)]];
    return newString;
}


- (NSComparisonResult)versionStringCompare:(NSString *)other {
    NSArray *oneComponents = [self componentsSeparatedByString:@"."];
    NSArray *twoComponents = [other componentsSeparatedByString:@"."];
    
    //比较主版本号
    int one = [[oneComponents objectAtIndex:0] intValue];
    int two = [[twoComponents objectAtIndex:0] intValue];
    if (one < two) {
        return NSOrderedAscending;
    }else if (one > two) {
        return NSOrderedDescending;
    }
    
    //比较次版本号
    one = [[oneComponents objectAtIndex:1] intValue];
    two = [[twoComponents objectAtIndex:1] intValue];
    if (one < two) {
        return NSOrderedAscending;
    }else if (one > two) {
        return NSOrderedDescending;
    }
    
    //比较长度
    if ([oneComponents count] < [twoComponents count]) {
        return NSOrderedAscending;
    } else if ([oneComponents count] > [twoComponents count]) {
        return NSOrderedDescending;
    }
    
    if (oneComponents.count == 2) {//版本号只有两位
        return NSOrderedSame;
    }else {//版本号有三位，比较第三位
        one = [[oneComponents objectAtIndex:2] intValue];
        two = [[twoComponents objectAtIndex:2] intValue];
        if (one < two) {
            return NSOrderedAscending;
        }else if (one > two) {
            return NSOrderedDescending;
        }
    }
    return NSOrderedSame;
}



//验证数字
-(BOOL)isCardNum {
    NSString *regex = @"[0-9]{1,100}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [mobileTest evaluateWithObject:self];
}
//验证邮箱
-(BOOL)isEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

//验证姓名  是 4- 12个汉字 或 字母
-(BOOL)isCharacter {
    NSString *regex = @"[\u4e00-\u9fa5]{2,14}|[A-Z,a-z]{2,14}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [mobileTest evaluateWithObject:self];
}

-(BOOL)isValidName {
    NSString *regex = @"[\u4e00-\u9fa5,·]{2,14}|[A-Z,a-z]{2,14}";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [mobileTest evaluateWithObject:self];
}

-(BOOL)isMobile{
    NSString *regex =  @"1[0-9]{10}$";
    NSPredicate *mobileTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [mobileTest evaluateWithObject:self];
}
@end
