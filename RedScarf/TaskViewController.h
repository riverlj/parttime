//
//  TaskViewController.h
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "MyProtocol.h"
#import "JudgeTableViewName.h"

@interface TaskViewController : BaseViewController<UISearchBarDelegate,JudgeTableViewName>

@property(nonatomic,strong)UIView *btnView;
@property(nonatomic,strong)UITableView *YiFenPeiTableview;

@property(nonatomic,strong) NSMutableArray *nameArr;
@property(nonatomic,strong) NSMutableArray *addressArr;

@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)NSMutableArray *filteredArray;

@property(nonatomic,strong) NSMutableArray *daifenpeiDataArr;
@property(nonatomic,strong) NSMutableArray *dataArr;

@property(nonatomic,strong)NSString *yiOrDaifenpei;

@end
