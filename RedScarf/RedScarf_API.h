//
//  RedScarf_API.h
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//
//#define  REDSCARF_BASE_URL @"http://192.168.1.95:8080"
//#define  REDSCARF_BASE_URL @"https://paytest.honglingjinclub.com"
//正式
//#define  REDSCARF_BASE_URL @"http://jianzhi.honglingjinclub.com"
//测试
#define  REDSCARF_BASE_URL @"http://121.42.58.92"
//#define  REDSCARF_BASE_URL @"http://192.168.1.41:8080"

#import <Foundation/Foundation.h>
#import "ASIFormDataRequest.h"

typedef void (^CompletionLoadHandle)(id result);


@interface RedScarf_API : NSObject


+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlstring
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                             block:(CompletionLoadHandle)block;

+ (ASIHTTPRequest *)zhangbRequestWithURL:(NSString *)zhangb
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                             block:(CompletionLoadHandle)block;

@end
