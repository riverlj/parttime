//
//  DaiFenPeiTableView.h
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseTableView.h"
#import "JudgeTableViewName.h"

@interface DaiFenPeiTableView : BaseTableView<JudgeTableViewName>


@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *aIdArray;

@property(nonatomic,strong)NSString *nameTableView;

@end
