//
//  RSFileStorage.m
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSFileStorage.h"


@implementation RSFileStorage

+ (NSString*)perferenceSavePath:(NSString *)filename {
    // 从文件中获取账户信息
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *savePath = [paths objectAtIndex:0];
    savePath = [savePath stringByAppendingPathComponent:@"Preferences"];
    if(!filename) {
        filename = @"com.RedScarf.preferences.plist";
    }
    savePath = [savePath stringByAppendingPathComponent:filename];
    return savePath;
}

//从文件中读取数据并且存储
+(NSDictionary *) readFromFile:(NSString *)filename
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *filepath = [self perferenceSavePath:filename];
    if([fm fileExistsAtPath:filepath]) {
        NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filepath];
        return dic;
    }
    return nil;
}

+(void) removeFile:(NSString *)filename
{
    NSString *filepath = [self perferenceSavePath:filename];
    NSFileManager *fm = [NSFileManager defaultManager];
    if([fm fileExistsAtPath:filepath]) {
        [fm removeItemAtPath:filepath error:nil];
    }
}

+(void) saveToFile:(NSString *)filename withDic:(NSDictionary *) dict
{
    NSString *filepath = [self perferenceSavePath:filename];
    [dict writeToFile:filepath atomically:YES];
}
@end
