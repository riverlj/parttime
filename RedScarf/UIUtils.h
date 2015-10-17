//
//  UIUtils.h
//  RedScarf
//
//  Created by zhangb on 15/8/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIUtils : NSObject

+ (BOOL)checkPhoneNumInput:(NSString *)text;
+ (NSString *)getSha1String:(NSString *)srcString;
+ (NSString *)replaceAdd:(NSString *)string;
+ (BOOL)isNumber:(NSString *)str;
+ (BOOL)isValidateEmail:(NSString *)email;
+ (BOOL)isValidateCharacter:(NSString *)str;
@end
