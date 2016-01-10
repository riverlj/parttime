//
//  ModifyMemberViewController.h
//  RedScarf
//
//  Created by zhangb on 15/9/23.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSTableViewController.h"
@protocol ReturnPhoneNumber <NSObject>

-(void)returnNumber:(NSString *)number;

@end
@interface ModifyMemberViewController : RSTableViewController

@property(nonatomic,strong)NSString *phoneString;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,weak)id<ReturnPhoneNumber>delegate1;

@end
