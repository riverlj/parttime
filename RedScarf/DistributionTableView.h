//
//  DistributionTableView.h
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseTableView.h"
#import "JudgeTableViewName.h"

@interface DistributionTableView : BaseTableView<JudgeTableViewName>

@property(nonatomic,strong) NSMutableArray *addressArr;

@property(nonatomic,strong) NSString *nameTableView;

@end
