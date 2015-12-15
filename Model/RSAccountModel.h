//
//  RSAccountModel.h
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSModel.h"

@interface RSAccountModel : RSModel <RSFileStorageProtocol,MTLJSONSerializing>

@property (nonatomic) NSInteger id;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *realName;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *headImg;
@property (nonatomic) NSInteger sex;

@property (nonatomic, strong) NSString *idCardNo;
@property (nonatomic, strong) NSString *idCardUrl1;
@property (nonatomic, strong) NSString *idCardUrl2;
@property (nonatomic, strong) NSString *studentIdCardNo;
@property (nonatomic, strong) NSString *studentIdCardUrl1;
@property (nonatomic, strong) NSString *studentIdCardUrl2;

@property (nonatomic) NSInteger identificationStatus;
@property (nonatomic, strong) NSString *level;

@property (nonatomic) NSInteger intPosition;
@property (nonatomic, strong) NSString *position;
@property (nonatomic) NSInteger status;

@property (nonatomic) NSInteger balance;
@property (nonatomic) NSInteger salary;

@property (nonatomic) NSInteger expireTime;

- (instancetype)initFromFile;
-(BOOL) isValid;
-(BOOL) isCEO;

+(id)sharedAccount;
@end
