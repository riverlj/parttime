//
//  BuildingTaskModel.m
//  RedScarf
//
//  Created by lishipeng on 16/1/15.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "BuildingTaskModel.h"

@implementation BuildingTaskModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"room": @"room",
             @"taskNum" : @"taskNum",
             @"apartmentId" : @"apartmentId"
             };
}

-(int)cellHeight
{
    return 55;
}

+(void)getBuildingTaskSuccess:(void(^)(NSArray *buildingTaskModels))success failure:(void (^)(void))failure{
    [RSHttp requestWithURL:@"/task/assignedTask/apartmentAndCount" params:nil httpMethod:@"GET" success:^(NSDictionary *data) {
        NSArray *body = [data valueForKey:@"body"];
        NSError *error = nil;
        NSArray * buildingTaskModels = [MTLJSONAdapter modelsOfClass:BuildingTaskModel.class fromJSONArray:body error:&error];
        if (error) {
            NSLog(@"error:%@",error);
        }
        success(buildingTaskModels);
    } failure:^(NSInteger code, NSString *errmsg) {
        failure();
    }];
}



@end
