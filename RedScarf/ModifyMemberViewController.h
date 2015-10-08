//
//  ModifyMemberViewController.h
//  RedScarf
//
//  Created by zhangb on 15/9/23.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
@protocol ReturnPhoneNumber <NSObject>

-(void)returnNumber:(NSString *)number;

@end
@interface ModifyMemberViewController : BaseViewController

@property(nonatomic,strong)NSString *phoneString;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)id<ReturnPhoneNumber>delegate;

@end
