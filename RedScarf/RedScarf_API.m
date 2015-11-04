//
//  RedScarf_API.m
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RedScarf_API.h"
#import "TaskViewController.h"

@implementation RedScarf_API

+ (ASIHTTPRequest *)requestWithURL:(NSString *)urlstring
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                             block:(CompletionLoadHandle)block {
    //1.如果是GET请求，将参数拼接到url后面
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@%@",REDSCARF_BASE_URL,urlstring];
    
    if ([httpMethod isEqualToString:@"GET"]||[httpMethod isEqualToString:@"PUT"]) {
        if (params != nil) {//如果请求参数不为空
            //在url后面追加参数
            [url appendString:@"?"];
            NSArray *allkeys = [params allKeys];
            for (int i=0; i<allkeys.count; i++) {
                NSString *key = [allkeys objectAtIndex:i];
                NSString *value = [params objectForKey:key];
                
                [url appendFormat:@"%@=%@",key,value];
                
                if (i<allkeys.count-1) {
                    [url appendString:@"&"];
                }
            }
        }
    }
    
    //2.创建request请求
    
     ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    NSLog(@"url = %@",url);

    if ([urlstring isEqualToString:@"/user/setting/time"]) {
        NSMutableDictionary *content = [NSMutableDictionary dictionary];
        [content setObject:@"application/json; charset=UTF-8" forKey:@"Content-Type"];
        [request setRequestHeaders:content];

    }
    [request setRequestMethod:httpMethod];
    [request setTimeOutSeconds:20];
    
    //3.判断是否为POST请求，向请求体中添加参数
    if ([httpMethod isEqualToString:@"POST"]) {
        if (params != nil) {//如果请求参数不为空
            //向请求体内添加参数
            for (NSString *key in params) {
                id value = [params objectForKey:key];
                //判断是否为文件数据
                if ([value isKindOfClass:[NSData class]]) {
                    [request addData:value forKey:key];
                } else {
                    [request addPostValue:value forKey:key];
                }
            }
//            request setda
        }
    }
//    //.判断是否为PUT请求，向请求体中添加参数
//    if ([httpMethod isEqualToString:@"PUT"]) {
//        if (params != nil) {//如果请求参数不为空
//            //向请求体内添加参数
//            for (NSString *key in params) {
//                id value = [params objectForKey:key];
//                //判断是否为文件数据
//                if ([value isKindOfClass:[NSData class]]) {
//                    [request setData:value forKey:key];
//                } else {
//                    [request addPostValue:value forKey:key];
//                }
//            }
//        }
//    }

    
    //4.数据返回的处理
    [request setCompletionBlock:^{
        
        NSData *jsonData = request.responseData;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (block != nil) {
            block(result);
        }
    }];
    
    //5.请求失败
    [request setFailedBlock:^{
        NSLog(@"请求失败:%@",request.error);

        //        if (block != nil) {
        //            block(@"");
        //        }
    }];
    
    
    
    //6.发送异步请求
    [request startAsynchronous];
    
    return request;
    
}

+ (ASIHTTPRequest *)zhangbRequestWithURL:(NSString *)zhangb
                                  params:(NSMutableDictionary *)params
                              httpMethod:(NSString *)httpMethod
                                   block:(CompletionLoadHandle)block
{
    //1.如果是GET请求，将参数拼接到url后面
    NSMutableString *url = [NSMutableString stringWithFormat:@"%@",zhangb];
    
    if ([httpMethod isEqualToString:@"GET"]||[httpMethod isEqualToString:@"PUT"]) {
        if (params != nil) {//如果请求参数不为空
            //在url后面追加参数
            [url appendString:@"?"];
            NSArray *allkeys = [params allKeys];
            for (int i=0; i<allkeys.count; i++) {
                NSString *key = [allkeys objectAtIndex:i];
                NSString *value = [params objectForKey:key];
                
                [url appendFormat:@"%@=%@",key,value];
                
                if (i<allkeys.count-1) {
                    [url appendString:@"&"];
                }
            }
        }
    }
    
    //2.创建request请求
    
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
    NSLog(@"url = %@",url);
    
    if ([zhangb isEqualToString:@"/user/setting/time"]) {
        NSMutableDictionary *content = [NSMutableDictionary dictionary];
        [content setObject:@"application/json; charset=UTF-8" forKey:@"Content-Type"];
        [request setRequestHeaders:content];
        
    }
    [request setRequestMethod:httpMethod];
    [request setTimeOutSeconds:20];
    
    //3.判断是否为POST请求，向请求体中添加参数
    if ([httpMethod isEqualToString:@"POST"]) {
        if (params != nil) {//如果请求参数不为空
            //向请求体内添加参数
            for (NSString *key in params) {
                id value = [params objectForKey:key];
                //判断是否为文件数据
                if ([value isKindOfClass:[NSData class]]) {
                    [request addData:value forKey:key];
                } else {
                    [request addPostValue:value forKey:key];
                }
            }
            //            request setda
        }
    }
    //    //.判断是否为PUT请求，向请求体中添加参数
    //    if ([httpMethod isEqualToString:@"PUT"]) {
    //        if (params != nil) {//如果请求参数不为空
    //            //向请求体内添加参数
    //            for (NSString *key in params) {
    //                id value = [params objectForKey:key];
    //                //判断是否为文件数据
    //                if ([value isKindOfClass:[NSData class]]) {
    //                    [request setData:value forKey:key];
    //                } else {
    //                    [request addPostValue:value forKey:key];
    //                }
    //            }
    //        }
    //    }
    
    
    //4.数据返回的处理
    [request setCompletionBlock:^{
        
        NSData *jsonData = request.responseData;
        id result = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
        if (block != nil) {
            block(result);
        }
    }];
    
    //5.请求失败
    [request setFailedBlock:^{
        NSLog(@"请求失败:%@",request.error);
        
        //        if (block != nil) {
        //            block(@"");
        //        }
    }];
    
    
    
    //6.发送异步请求
    [request startAsynchronous];
    
    return request;

}

@end
