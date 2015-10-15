//
//  DistributionTableView.h
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseTableView.h"
#import "JudgeTableViewName.h"

@interface DistributionTableView : BaseTableView<JudgeTableViewName,NSURLConnectionDataDelegate>

@property(nonatomic,strong) NSMutableArray *addressArr;
@property(nonatomic,strong) NSMutableArray *roomArr;
@property(nonatomic,strong) NSMutableArray *totalArr;

@property(nonatomic,strong) NSString *nameTableView;

@property(nonatomic,strong) NSString *judgeStr;

@property(nonatomic,strong) NSString *aId;

@property(nonatomic,strong) NSString *roomNum;

@property(nonatomic,strong) NSMutableData *totalData;

@end
