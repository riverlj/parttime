//
//  RSHttp.h
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface RSHttp : NSObject


+ (void)requestWithURL:(NSString *)urlstring
                            params:(id)params
                        httpMethod:(NSString *)httpMethod
                           success:(void (^)(NSDictionary *data)) success
                           failure:(void (^)(NSInteger code, NSString *errmsg))failure;

+ (void)payRequestWithURL:(NSString *)urlstring
                params:(id)params
            httpMethod:(NSString *)httpMethod
               success:(void (^)(NSDictionary *data)) success
               failure:(void (^)(NSInteger code, NSString *errmsg))failure;

+(void)postDataWithURL:(NSString *)urlstring
                params:(id)params
constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
               success:(void (^)(NSDictionary *data)) success
               failure:(void (^)(NSInteger code, NSString *errmsg))failure;


+ (void) processSuccess:(void (^)(NSDictionary *data)) success operation:(AFHTTPRequestOperation *)op response:(id)responseObject failure:(void (^)(NSInteger code, NSString *errmsg))failure;
+ (void) processFailure:(void (^)(NSInteger code, NSString *errmsg))failure operation:(AFHTTPRequestOperation *)op error:(NSError *)error;
+(void)mobileRequestWithURL:(NSString *)urlstring
                     params:(NSMutableDictionary *)params
                 httpMethod:(NSString *)httpMethod
                    success:(void (^)(NSDictionary *))success
                    failure:(void (^)(NSInteger, NSString *))failure;
@end
