//
//  MyModel.h
//  RedScarf
//
//  Created by zhangb on 15/8/27.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyModel : NSObject

//推荐粉丝总数
@property(nonatomic,strong)NSString *date;
@property(nonatomic,strong)NSString *fansNumAccumulate;
@property(nonatomic,strong)NSString *fansNumInOneDay;

//推广费总金额
@property(nonatomic,strong)NSString *AccountAccumulate;
@property(nonatomic,strong)NSString *AccountInOneDay;

//我的粉丝
@property(nonatomic,strong)NSString *fansName;
@property(nonatomic,strong)NSString *fansOrderAccountInOneDay;
@property(nonatomic,strong)NSString *fansOrderNumInOneDay;
@property(nonatomic,strong)NSString *joinDate;
@property(nonatomic,strong)NSString *fansOrderTotalAccount;

@property(nonatomic,strong)NSArray *fansDetailArr;




@end
