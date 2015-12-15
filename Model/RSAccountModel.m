//
//  RSAccountModel.m
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSAccountModel.h"
static RSAccountModel *gsharedAccount = nil;

@implementation RSAccountModel

+(NSDictionary *) JSONKeyPathsByPropertyKey {
    return @{
             @"id": @"userInfo.id",
             @"mobile" : @"userInfo.mobilePhone",
             @"nickName" : @"userInfo.nickname",
             @"userName" : @"userInfo.username",
             @"realName" : @"userInfo.realName",
             @"headImg" : @"userInfo.url",
             @"sex" : @"userInfo.sex",
             
             @"idCardNo" : @"userInfo.idCardNo",
             @"idCardUrl1" : @"userInfo.idCardUrl1",
             @"idCardUrl2" : @"userInfo.idCardUrl2",
             @"studentIdCardNo" : @"userInfo.studentIdCardNo",
             @"studentIdCardUrl1" : @"userInfo.studentIdCardUrl1",
             @"studentIdCardUrl2" : @"userInfo.studentIdCardUrl2",
             
             @"identificationStatus" : @"userInfo.identificationStatus",
             @"level" : @"userInfo.level",
             @"intPosition" : @"userInfo.intPosition",
             @"position" : @"userInfo.position",
             @"status" : @"userInfo.status",
             
             @"balance" : @"balance",
             @"salary" : @"salary",
             
    };
}


+ (id)sharedAccount {
    if (gsharedAccount) {
        return gsharedAccount;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gsharedAccount = [[self alloc] initFromFile];
    });
    return gsharedAccount;
}

-(instancetype) init
{
    self = [super init];
    if(self) {
        self.expireTime = 0;
    }
    return self;
}

- (instancetype)initFromFile {
    //先从文件中读取数据
    NSDictionary *dic = [RSFileStorage readFromFile:[self getClassName]];
    if(dic) {
        self = [super initWithDictionary:dic error:nil];
    } else {
        self = [self init];
    }
    self = [super init];
    return self;
}



-(void) save
{
    NSString * filename = [self getClassName];
    NSInteger timestamp = [[NSDate date] timeIntervalSince1970];
    self.expireTime = timestamp + 3600*6;
    [RSFileStorage saveToFile:filename withDic:[self dictionaryValue]];
    gsharedAccount = [self initWithDictionary:[self dictionaryValue] error:nil];
}

-(BOOL) isValid
{
    NSInteger timestamp = [[NSDate date] timeIntervalSince1970];
    return self.id && self.expireTime > timestamp;
}

-(void) clear
{
    [RSFileStorage removeFile:[self getClassName]];
}

-(BOOL) isCEO
{
    return self.intPosition == 1;
}


@end
