//
//  RSFileStorage.h
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSFileStorage : NSObject

+ (NSString*)perferenceSavePath:(NSString *)filename;
+ (NSDictionary *) readFromFile:(NSString *)filepath;
+ (void) removeFile:(NSString *)filename;
+(void) saveToFile:(NSString *)filename withDic:(NSDictionary *) dict;
@end

@protocol RSFileStorageProtocol
-(void) save; //保存至文件
-(void) clear; //删除
@end