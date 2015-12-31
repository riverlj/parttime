//
//  MyBankCardVC.h
//  RedScarf
//
//  Created by zhangb on 15/9/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "MyProtocol.h"
#import "RSBankCardModel.h"

@interface MyBankCardVC : BaseViewController<MyProtocol>
@property(nonatomic, strong) RSBankCardModel *bankcard;

@end
