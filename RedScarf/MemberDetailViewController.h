//
//  MemberDetailViewController.h
//  RedScarf
//
//  Created by zhangb on 15/9/22.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "ModifyMemberViewController.h"



@interface MemberDetailViewController : BaseViewController<ReturnPhoneNumber>

@property(nonatomic,strong)NSString *memberId;

@end
