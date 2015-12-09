//
//  RSHttp.m
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSHttp.h"
@implementation RSHttp

+ (void)requestWithURL:(NSString *)urlstring
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                          success:(void (^)(NSDictionary *))success
               failure:(void (^)(NSInteger, NSString *))failure
{
    NSString *url = [urlstring urlWithHost:nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //设置超时时间
    manager.requestSerializer.timeoutInterval = 5;
    if([httpMethod isEqualToString:@"GET"]) {
        [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    } else if([httpMethod isEqualToString:@"POST"]) {
        [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    } else if([httpMethod isEqualToString:@"PUT"]) {
        [manager PUT:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    } else if([httpMethod isEqualToString:@"DELETE"]) {
        [manager DELETE:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    } else {
        [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    }
}

+(void) processSuccess:(void (^)(NSDictionary *data)) success
             operation:(AFHTTPRequestOperation *)op
              response:(id)responseObject
               failure:(void (^)(NSInteger code, NSString *errmsg))failure;
{

    NSInteger code = [[responseObject valueForKey:@"code"] integerValue];
    //如果成功
    if(code == 0) {
        success(responseObject);
    } else {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[responseObject valueForKey:@"msg"], NSLocalizedDescriptionKey, nil];
        NSError *error = [NSError errorWithDomain:@"httpUserError" code:code userInfo:userInfo];
        [self processFailure:failure operation:op error:error];
    }
}

+(void) processFailure:(void (^)(NSInteger code, NSString *errmsg))failure
             operation:(AFHTTPRequestOperation *)op
                 error:(NSError *)error
{
    
    NSString *errmsg = [error.userInfo valueForKey:@"NSLocalizedDescription"];
    failure(error.code, errmsg);
}

+(void)payRequestWithURL:(NSString *)urlstring
                  params:(NSMutableDictionary *)params
              httpMethod:(NSString *)httpMethod
                 success:(void (^)(NSDictionary *))success
                 failure:(void (^)(NSInteger, NSString *))failure
{
    urlstring = [urlstring urlWithHost:REDSCARF_PAY_URL];
    [self requestWithURL:urlstring params:params httpMethod:httpMethod success:success failure:failure];
}


/* if ([httpMethod isEqualToString:@"GET"]||[httpMethod isEqualToString:@"PUT"]) {
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
 NSURLRequest *request = [NSURLRequest requestWithURL:url];
 
 AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
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
 
 return request;*/

/*+ (ASIHTTPRequest *)zhangbRequestWithURL:(NSString *)zhangb
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
        }
    }
    
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

}*/

@end
