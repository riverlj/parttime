//
//  RSHttp.m
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSHttp.h"
#import "LoginViewController.h"
@implementation RSHttp

+ (void)baseRequestWithURL:(NSString *)urlstring
                            params:(NSMutableDictionary *)params
                        httpMethod:(NSString *)httpMethod
                          success:(void (^)(NSDictionary *))success
                          failure:(void (^)(NSInteger, NSString *))failure
        constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
{
    NSString *url = [urlstring urlWithHost:nil];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //设置超时时间
    manager.requestSerializer.timeoutInterval = 5;
    if([httpMethod isEqualToString:@"GET"]) {
        [manager GET:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    } else if([httpMethod isEqualToString:@"POST"]) {
        [manager POST:url parameters:params constructingBodyWithBlock:block success:^(AFHTTPRequestOperation *operation, id responseObject) {
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
    } else if([httpMethod isEqualToString:@"POSTJSON"]){
        [manager POST:url parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self processSuccess:success operation:operation response:responseObject failure:failure];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self processFailure:failure operation:operation error:error];
        }];
    }else {
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
        NSDictionary *userInfo;
        if([responseObject objectForKey:@"msg"]) {
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[responseObject valueForKey:@"msg"], NSLocalizedDescriptionKey, nil];
        } else {
            userInfo = [NSDictionary dictionaryWithObjectsAndKeys:[responseObject valueForKey:@"body"], NSLocalizedDescriptionKey, nil];
        }
        NSError *error = [NSError errorWithDomain:@"httpUserError" code:code userInfo:userInfo];
        [self processFailure:failure operation:op error:error];
    }
}

+(void) processFailure:(void (^)(NSInteger code, NSString *errmsg))failure
             operation:(AFHTTPRequestOperation *)op
                 error:(NSError *)error
{
    if(error.code == 401) {
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        LoginViewController *loginVC = [[LoginViewController alloc] init];
        [app setRoorViewController:loginVC];
    }
    NSString *errmsg = [error.userInfo valueForKey:@"NSLocalizedDescription"];
    failure(error.code, errmsg);
}


+(void) requestWithURL:(NSString *)urlstring
                params:(NSMutableDictionary *)params
            httpMethod:(NSString *)httpMethod success:(void (^)(NSDictionary *))success
               failure:(void (^)(NSInteger, NSString *))failure
{
    urlstring = [urlstring urlWithHost:REDSCARF_BASE_URL];
    //添加token参数
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"token"] &&  [urlstring rangeOfString:@"token="].location == NSNotFound) {
        if([urlstring rangeOfString:@"?"].location == NSNotFound) {
            urlstring = [NSString stringWithFormat:@"%@?token=%@", urlstring, [NSString URLencode:[defaults objectForKey:@"token"] stringEncoding:NSUTF8StringEncoding]];
        } else {
            urlstring = [NSString stringWithFormat:@"%@&token=%@", urlstring, [NSString URLencode:[defaults objectForKey:@"token"] stringEncoding:NSUTF8StringEncoding]];
        }
    }
    [self baseRequestWithURL:urlstring params:params httpMethod:httpMethod success:success failure:failure constructingBodyWithBlock:nil];
}


+(void)payRequestWithURL:(NSString *)urlstring
                  params:(NSMutableDictionary *)params
              httpMethod:(NSString *)httpMethod
                 success:(void (^)(NSDictionary *))success
                 failure:(void (^)(NSInteger, NSString *))failure
{
    urlstring = [urlstring urlWithHost:REDSCARF_PAY_URL];
    //添加paytoken
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"withdrawToken"] &&  [urlstring rangeOfString:@"token="].location == NSNotFound) {
        if([urlstring rangeOfString:@"?"].location == NSNotFound) {
            urlstring = [NSString stringWithFormat:@"%@?token=%@", urlstring, [NSString URLencode:[defaults objectForKey:@"withdrawToken"] stringEncoding:NSUTF8StringEncoding]];
        } else {
            urlstring = [NSString stringWithFormat:@"%@&token=%@", urlstring, [NSString URLencode:[defaults objectForKey:@"withdrawToken"] stringEncoding:NSUTF8StringEncoding]];
        }
    }
    [self baseRequestWithURL:urlstring params:params httpMethod:httpMethod success:success failure:failure constructingBodyWithBlock:nil];
}

+(void) postDataWithURL:(NSString *)urlstring params:(NSMutableDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(NSDictionary *))success failure:(void (^)(NSInteger, NSString *))failure
{
    urlstring = [urlstring urlWithHost:nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"token"] &&  [urlstring rangeOfString:@"token="].location == NSNotFound) {
        if([urlstring rangeOfString:@"?"].location == NSNotFound) {
            urlstring = [NSString stringWithFormat:@"%@?token=%@", urlstring, [NSString URLencode:[defaults objectForKey:@"token"] stringEncoding:NSUTF8StringEncoding]];
        } else {
            urlstring = [NSString stringWithFormat:@"%@&token=%@", urlstring, [NSString URLencode:[defaults objectForKey:@"token"] stringEncoding:NSUTF8StringEncoding]];
        }
    }
    [self baseRequestWithURL:urlstring params:params httpMethod:@"POST" success:success failure:failure constructingBodyWithBlock:block];
}
@end
