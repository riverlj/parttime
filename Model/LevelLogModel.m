//
//  LevelLogModel.m
//  RedScarf
//
//  Created by lishipeng on 15/12/10.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "LevelLogModel.h"

@implementation LevelLogModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"growth": @"growth",
             @"id" : @"id",
             @"info" : @"info",
             @"time" : @"time",
    };
}

-(NSString *) cellClassName
{
    return @"NormalLogCell";
}

-(int) cellHeight
{
    return 80;
}

@end
