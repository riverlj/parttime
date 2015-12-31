//
//  RSBankCardModel.h
//  RedScarf
//
//  Created by lishipeng on 15/12/29.
//  Copyright © 2015年 zhangb. All rights reserved.
//  银行卡

#import "RSModel.h"

@interface RSBankCardModel : RSModel<MTLJSONSerializing>

//银行卡id
@property (nonatomic, assign) NSInteger id;
//账号类型
@property (nonatomic, assign) NSInteger accountType;
//合作方标识
@property (nonatomic, copy) NSString *externalId;

//真实姓名
@property (nonatomic, copy) NSString *realName;
//电话号码
@property (nonatomic, copy) NSString *phoneNumber;


//总行名称
@property (nonatomic, copy) NSString *bankName;
@property (nonatomic, assign) NSInteger bankId;
//银行卡号
@property (nonatomic, copy) NSString *cardNum;
//支行id
@property (nonatomic, assign) NSInteger branchBankId;
//支行名称
@property (nonatomic, strong) NSString *branchBankName;

@property (nonatomic, assign) NSInteger businessType;

@property (nonatomic, strong) NSString *provincename;
@property (nonatomic, assign) NSInteger provinceid;
@property (nonatomic, strong) NSString *cityname;
@property (nonatomic, assign) NSInteger cityid;

-(NSString *) showCardNum;
@end

