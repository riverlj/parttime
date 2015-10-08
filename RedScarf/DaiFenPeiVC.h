//
//  DaiFenPeiVC.h
//  RedScarf
//
//  Created by zhangb on 15/8/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "JudgeTableViewName.h"

@interface DaiFenPeiVC : BaseViewController<JudgeTableViewName>

@property(nonatomic,strong)UITableView *addressTableView;
@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)NSString *aId;
@property(nonatomic,strong)NSString *userId;

@property(nonatomic,strong)NSMutableArray *dataArray;

@property(nonatomic,assign) int num;
@property(nonatomic,assign) int number;

@property(nonatomic,assign)id<JudgeTableViewName>delegate;

@end
