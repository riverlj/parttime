//
//  AllocatingTaskVC.h
//  RedScarf
//
//  Created by zhangb on 15/8/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "JudgeTableViewName.h"

@interface AllocatingTaskVC : BaseViewController

@property(nonatomic,assign)int num;
@property(nonatomic,strong)UITableView *taskTableView;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,strong)NSMutableArray *filteredArray;
@property(nonatomic,strong)UISearchDisplayController *searchaDisplay;

@property(nonatomic,strong)NSString *aId;
@property(nonatomic,strong)NSString *room;
@property(nonatomic,strong)NSString *userId;

@property(nonatomic,strong)NSMutableArray *nameArray;

//判断是不是从已分配跳的界面
@property(nonatomic,assign)int number;
@end
