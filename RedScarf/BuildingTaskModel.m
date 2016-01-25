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
             };
}

-(int)cellHeight
{
    return 55;
}
@end
