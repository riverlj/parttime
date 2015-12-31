//
//  TasksViewController.h
//  RedScarf
//
//  Created by lishipeng on 15/12/30.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSRefreshTableViewController.h"

@interface TasksViewController : RSRefreshTableViewController

@property(nonatomic)NSInteger searchType;
@property(nonatomic,strong)UISearchBar *searchBar;
@end
