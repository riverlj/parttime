//
//  AddressViewVontroller.h
//  RedScarf
//
//  Created by zhangb on 15/8/8.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "MyProtocol.h"
#import "JudgeTableViewName.h"

@interface AddressViewVontroller : BaseViewController<MyProtocol>

@property(nonatomic,strong)NSString *addressStr;
@property(nonatomic,strong)NSString *tId;

@property(nonatomic,assign)id<JudgeTableViewName>delegate;

@end
