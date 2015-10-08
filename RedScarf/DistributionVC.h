//
//  DistributionVC.h
//  RedScarf
//
//  Created by zhangb on 15/8/12.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "JudgeTableViewName.h"

@interface DistributionVC : BaseViewController<JudgeTableViewName>

@property(nonatomic,strong) UITableView *detailTableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSString *aId;
@property(nonatomic,strong)NSString *titleStr;

@property(nonatomic,assign)id<JudgeTableViewName>delegate;

@end
