//
//  OrderTimeViewController.h
//  RedScarf
//
//  Created by zhangb on 15/9/16.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"

@interface OrderTimeViewController : BaseViewController<NSURLConnectionDataDelegate>
//团队里面的配送时间
@property(nonatomic,strong)NSString *username;

@end
