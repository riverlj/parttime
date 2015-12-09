//
//  RSAccountModel.m
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSAccountModel.h"

@implementation RSAccountModel

+ (id)sharedAccount {
    static RSAccountModel *gsharedAccount = nil;
    if (gsharedAccount) {
        return gsharedAccount;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gsharedAccount = [[self alloc] initFromFile];
    });
    return gsharedAccount;
}

- (instancetype)initFromFile {
    //先从文件中读取数据
    NSDictionary *dic = [RSFileStorage readFromFile:[self getClassName]];
    if(dic) {
        self = [super initWithDictionary:dic error:nil];
    } else {
        self = [self init];
    }
    return self;
}



-(void) save
{
    NSString * filename = [self getClassName];
    [RSFileStorage saveToFile:filename withDic:[self dictionaryValue]];
}

-(void) clear
{
    [RSFileStorage removeFile:[self getClassName]];
}



@end
