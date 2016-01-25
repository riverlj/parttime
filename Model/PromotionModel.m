//
//  PromotionModel.m
//  RedScarf
//
//  Created by lishipeng on 16/1/20.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "PromotionModel.h"

@implementation PromotionModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name" : @"otherUserName",
             @"mobile" : @"otherUserPhone",
             @"orderCnt" : @"otherUserTotalOrder",
             @"promotionCnt" : @"otherUserYestdayOrder",
    };
}

-(int) cellHeight
{
    return 45;
}

+ (NSValueTransformer *)orderCntJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)value stringValue];
        }else {
            return (NSString*)value;
        }
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return (NSString *)value;
    }];
}

+ (NSValueTransformer *)promotionCntJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if([value isKindOfClass:[NSNumber class]]) {
            return [(NSNumber *)value stringValue];
        }else {
            return (NSString*)value;
        }
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return (NSString *)value;
    }];
}
@end
