//
//  BuildingTaskModel.m
//  RedScarf
//
//  Created by lishipeng on 16/1/15.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "BuildingTaskModel.h"

@implementation RoomContentModel

+(NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"tag" : @"tag",
             @"count" : @"count",
             @"content" : @"content"
             };
}

@end

@implementation RoomTaskModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"room" : @"room",
             @"taskNum" : @"taskNum",
             @"content" : @"content"
             };
}

+ (NSValueTransformer *)contentJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:RoomContentModel.class];
}

+(void)getRoomTask:(NSDictionary *)params success:(void(^)(NSArray *roomTaskModels))success failure:(void (^)(void))failure {
    [RSHttp requestWithURL:@"/task/assignedTask/roomDetail" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        //data
        NSArray *array = [data valueForKey:@"body"];
        NSError *error = nil;
        
        NSArray *roomTaskModels =  [MTLJSONAdapter modelsOfClass:RoomTaskModel.class fromJSONArray:array error:&error];
        success(roomTaskModels);
        
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
        failure();
    }];

}

@end

@implementation BuildingTaskModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"room" : @"room",
             @"apartmentName": @"apartmentName",
             @"taskNum" : @"taskNum",
             @"apartmentId" : @"apartmentId"
             };
}

+(void)getBuildingTask:(NSDictionary *)params success:(void(^)(NSArray *buildingTaskModels))success failure:(void (^)(void))failure{
    [RSHttp requestWithURL:@"/task/assignedTask/apartmentAndCount" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSArray *body = [data valueForKey:@"body"];
        NSError *error = nil;
        NSArray * buildingTaskModels = [MTLJSONAdapter modelsOfClass:BuildingTaskModel.class fromJSONArray:body error:&error];
        if (error) {
            NSLog(@"error:%@",error);
        }
        success(buildingTaskModels);
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
        failure();
    }];
}



@end
