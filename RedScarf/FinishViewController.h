//
//  FinishViewController.h
//  RedScarf
//
//  Created by zhangb on 15/8/18.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSRefreshTableViewController.h"

@interface FinishViewController : RSRefreshTableViewController
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic, strong)UIView *btnView;
@property(nonatomic) BOOL hideBtnView;
@end
