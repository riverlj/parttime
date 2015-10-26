//
//  FinishViewController.h
//  RedScarf
//
//  Created by zhangb on 15/8/18.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"
#import "BaseTableView.h"

@interface FinishViewController : BaseViewController<MJRefreshBaseViewDelegate>

@property(nonatomic,strong)UITableView *finishTableView;

@property(nonatomic,strong)NSMutableArray *dataArr;

@property(nonatomic,strong)NSMutableArray *searchDataArr;

@property(nonatomic,strong)NSMutableArray *filteredArray;

@property(nonatomic,strong)NSMutableArray *telArray;

@property(nonatomic,strong)NSString *status;

@property(nonatomic,strong)UISearchBar *searchBar;

@property(nonatomic,strong)UISearchDisplayController *searchaDisplay;

@end
