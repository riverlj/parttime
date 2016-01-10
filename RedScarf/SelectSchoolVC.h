//
//  SelectSchoolVC.h
//  RedScarf
//
//  Created by zhangb on 15/8/15.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSTableViewController.h"
#import "MyProtocol.h"


@interface SelectSchoolVC : RSTableViewController<UISearchDisplayDelegate>

@property(nonatomic,strong)UITableView *schoolTableView;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)NSMutableArray *filteredArray;
@property(nonatomic,strong)UISearchDisplayController *searchaDisplay;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *nameArray;

@property(nonatomic,assign)id<MyProtocol>delegate1;

@end
