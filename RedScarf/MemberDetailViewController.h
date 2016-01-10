//
//  MemberDetailViewController.h
//  RedScarf
//
//  Created by zhangb on 15/9/22.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSRefreshTableViewController.h"
#import "ModifyMemberViewController.h"



@interface MemberDetailViewController : RSRefreshTableViewController<ReturnPhoneNumber>

@property(nonatomic,strong)NSString *memberId;

@end
