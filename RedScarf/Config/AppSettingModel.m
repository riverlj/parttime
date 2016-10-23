//
//  AppSettingModel.m
//  RedScarf
//
//  Created by 李江 on 16/10/21.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "AppSettingModel.h"

@implementation AppBusiness

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"type" : @"type",
             @"name" : @"name"
             };
}

@end

static AppSettingModel *shareAppSettingModel = nil;
@implementation AppSettingModel

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"businesslist" : @"businesslist"
             };
}

+ (NSValueTransformer *)businesslistJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:AppBusiness.class];
}

+(void)getAppSetting {
    [RSHttp requestWithURL:@"/setting/info" params:@"GET" httpMethod:@"GET" success:^(NSDictionary *data) {
        NSDictionary *body = [data valueForKey:@"body"];
        NSError *error = nil;
        AppSettingModel *appsettingModel = [MTLJSONAdapter modelOfClass:AppSettingModel.class fromJSONDictionary:body error:&error];
        if (error) {
            NSLog(@"error:%@",error);
        }
        
        AppDelegate *delegate = [AppConfig getAPPDelegate];
        delegate.appSettingModel = appsettingModel;
        
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}
@end
