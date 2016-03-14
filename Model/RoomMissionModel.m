//
//  RoomMissionModel.m
//  RedScarf
//
//  Created by lishipeng on 15/12/18.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RoomMissionModel.h"

@implementation RoomMissionModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name": @"customerName",
             @"snid" : @"sn",
             @"date" : @"date",
             @"mobile" : @"mobile",
    };
}

-(NSString *) cellClassName
{
    return @"RoomTableViewCell";
}

-(int) cellHeight
{
    return 80;
}

@end
