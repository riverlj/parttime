//
//  RSBankCardModel.m
//  RedScarf
//
//  Created by lishipeng on 15/12/29.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSBankCardModel.h"

@implementation RSBankCardModel
+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"id":@"id",
             @"accountType" : @"accountType",
             @"externalId" : @"externalId",
             @"cardNum" : @"cardNum",
             @"realName" : @"realName",
             @"bankName" : @"bankName",
             @"phoneNumber" : @"phoneNumber",
             @"branchBankId" : @"branchBankId",
             @"businessType" : @"businessType",
    };
}

-(NSString *)showCardNum
{
    if(self.cardNum) {
        return [self.cardNum addString:@" " every:4];
    }
    return @"";
}

-(void) setCardNum:(NSString *)cardNum
{
    _cardNum = [cardNum stringByReplacingOccurrencesOfString:@" " withString:@""];
}

-(void) setPhoneNumber:(NSString *)phoneNumber
{
    _phoneNumber = [phoneNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
}

@end
