//
//  NSString+RSHttp.h
//  RedScarf
//
//  Created by lishipeng on 15/12/7.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(RSHttp)
//append string
- (NSString *)append:(NSString *)string;
//获取url
-(NSString *) urlWithHost:(NSString *)host;
//对比版本号
- (NSComparisonResult)versionStringCompare:(NSString *)other;
- (NSString *)addString:(NSString *)string every:(NSInteger)charCount;
- (NSDictionary *)parseURLParams;//把url中的参数转成NSDictionary
- (BOOL)isCardNum;
- (BOOL)isEmail;
- (BOOL)isCharacter;
- (BOOL)isValidName;
- (BOOL)isMobile;

-(NSString *) sha1;

//URLencode
+ (NSString*)URLencode:(NSString*)originalString stringEncoding:(NSStringEncoding)stringEncoding;
//http_build_query
+ (NSString *)urlParameterWithDictionary:(NSDictionary *)params;

+ (NSArray *)phoneNumberFromString:(NSString*)orginalStr;
+ (NSString *)stringFromNumber:(NSNumber *)number;// 此函数作用在于确保number转为string ,只保留两位小数
+ (NSString *)moneyStringWithNumber:(NSNumber *)floatNumber;// 将价格变成字符串，前面加人民币符号
+ (NSString *)stringWithFloat:(float)number;
+ (NSString *)moneyStringWithFloat:(float)number;


@end
