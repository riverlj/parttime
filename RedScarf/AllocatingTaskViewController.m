//
//  AllocatingTaskViewController.m
//  RedScarf
//
//  Created by lishipeng on 15/12/31.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "AllocatingTaskViewController.h"
#import "Model.h"

@implementation AllocatingTaskViewController


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"分配任务";
    self.url = @"/task/fuzzyUser";
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 44)];
    [self.searchBar.layer setBorderColor:color242.CGColor];
    [self.searchBar.layer setBorderWidth:1.0];
    [self.searchBar setBarTintColor:color242];
    self.tableView.tableHeaderView = self.searchBar;
}

-(void) beforeHttpRequest
{
    self.params = [NSMutableDictionary dictionary];
    [self.params setObject:self.searchBar.text forKey:@"name"];
    [self showHUD:@"加载中"];
}

-(void) afterHttpSuccess:(NSDictionary *)data
{
    for (NSMutableDictionary *dic in [data objectForKey:@"msg"]) {
        Model *model = [[Model alloc] init];
        model.username = [dic objectForKey:@"username"];
        model.tasksArr = [dic objectForKey:@"apartments"];
        model.mobile = [dic objectForKey:@"mobile"];
        model.userId = [dic objectForKey:@"userId"];
        model.present = [[dic objectForKey:@"present"] boolValue];
        model.cellClassName = @"DistributionCell";
        model.cellHeight = 40;
        [self.models addObject:model];
    }
}


@end
