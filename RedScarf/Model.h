//
//  Model.h
//  RedScarf
//
//  Created by zhangb on 15/8/17.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@property(nonatomic,strong)NSString *apartmentName;
@property(nonatomic,strong)NSString *taskNum;
@property(nonatomic,strong)NSString *aId;

//已处理
@property(nonatomic,strong)NSString *nameStr;
@property(nonatomic,strong)NSString *chuLiStr;
@property(nonatomic,strong)NSString *buyerStr;
@property(nonatomic,strong)NSString *telStr;
@property(nonatomic,strong)NSString *addressStr;
@property(nonatomic,strong)NSString *foodStr;
@property(nonatomic,strong)NSString *dateStr;
@property(nonatomic,strong)NSString *numberStr;
@property(nonatomic,strong)NSString *noctionStr;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSMutableArray *foodArr;

//已分配
@property(nonatomic,strong)NSString *mobile;
@property(nonatomic,strong)NSString *username;
@property(nonatomic,strong)NSString *userId;

@property(nonatomic,strong)NSMutableArray *tasksArr;
@property(nonatomic,strong)NSMutableArray *apartmentsArr;


//
@property(nonatomic,strong)NSMutableArray *contentArr;
@property(nonatomic,strong)NSString *room;
@property(nonatomic,strong)NSString *select;

@end
