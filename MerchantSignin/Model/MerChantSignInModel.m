//
//  MerChantSignInModel.m
//  RedScarf
//
//  Created by 李江 on 16/10/8.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "MerChantSignInModel.h"

@implementation MerChantSignInModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"goodsid": @"goodsid",
             @"mobile" : @"mobile",
             @"status" : @"status",
             @"checktime" : @"checktime",
             @"optusername" : @"optusername",
             @"goodsname" : @"goodsname"
             };
}

+(void)getSchoolInfo:(void(^)(NSArray *merchants))success failure:(void(^)(void))failure{
    
    [RSHttp requestWithURL:@"/goods/schoolinfo" params:nil httpMethod:@"GET" success:^(NSDictionary *data) {
        NSArray *arrays = data[@"body"][@"goodsinfo"];
        NSError * error = nil;
        NSArray *array = [MTLJSONAdapter modelsOfClass:MerChantSignInModel.class fromJSONArray:arrays error:&error];
        if (error) {
            [[RSToastView shareRSToastView] showToast:@"goods/schoolinfo数据解析失败~"];
        }
        success(array);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
        failure();
    }];
}

+ (void)makeSureSended:(MerChantSignInModel *)model success:(void(^)(void))success failure:(void(^)(void))failure {
    
    NSDate *now = [NSDate date];
    NSString *str = [now stringFromDateWithFormat:@"yyyy-MM-dd"];
    NSString *temp = [NSString stringWithFormat:@"%@ %@:00", str, model.checktime];
    
    NSDictionary *params = @{
                             @"goodsid" : model.goodsid,
                             @"checktime" : temp
                             };
    [[RSToastView shareRSToastView] showHUD:@"提交中..."];
    [RSHttp requestWithURL:@"/goods/check" params:params httpMethod:@"POST" success:^(NSDictionary *data) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:@"提交成功"];
        success();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:errmsg];
        failure();
    }];
}

+ (void)sendMissGood:(NSDictionary *)params success:(void(^)(void))success failure:(void(^)(void))failure {
    [[RSToastView shareRSToastView] showHUD:@"提交中..."];
    [RSHttp requestWithURL:@"/goods/rategoods" params:params httpMethod:@"POST" success:^(NSDictionary *data) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:@"提交成功"];
        success();
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] hidHUD];
        [[RSToastView shareRSToastView] showToast:errmsg];
        failure();
    }];
}

@end
