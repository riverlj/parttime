//
//  WithdrawModel.m
//  RedScarf
//
//  Created by 李江 on 16/10/14.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "WithdrawModel.h"


@implementation WithdrawViewModel
@end;

@implementation WithdrawModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"requestTime" : @"requestTime",
             @"resultTime" : @"resultTime",
             @"status" : @"status",
             @"totalFee" : @"totalFee"
             };
}

-(NSString *)statusStr {
    switch (self.status.integerValue) {
        case 0:
            _statusStr = @"审核中";
            break;
        case 1:
            _statusStr = @"正在打款";
            break;
        case 2:
            _statusStr = @"提现失败";
            break;
        case 3:
            _statusStr = @"提现成功";
            break;
        default:
            _statusStr = @"提现状态有误，请联系校园CEO";
            break;
    }
    return _statusStr;
}

@end
