//
//  RSRefreshTableViewController.m
//  RedScarf
//
//  Created by lishipeng on 15/12/30.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSRefreshTableViewController.h"

@implementation RSRefreshTableViewController
{
    // 0代表正常网络请求， 1代表header刷新, 2代表footer刷新
    NSInteger refreshMethod;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.pageNum = 1;
    self.pageSize = 10;
    self.title = @"任务";
    refreshMethod = 0;
    self.httpMethod = @"GET";
    self.params = [NSMutableDictionary dictionary];
}

//如果设置下拉刷新
-(void)setUseFooterRefresh:(BOOL)useFooterRefresh
{
    if(useFooterRefresh) {
        self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginFooterRefresh)];
    }else {
        self.tableView.mj_footer = nil;
    }
}

-(void)beginFooterRefresh
{
    refreshMethod = 2;
    [self.params setObject:[NSString stringWithFormat:@"%ld", self.pageNum] forKey:@"pageNum"];
    [self.params setObject:[NSString stringWithFormat:@"%ld", self.pageSize] forKey:@"pageSize"];
    [self beginHttpRequest];
}

//如果设置上拉刷新
-(void)setUseHeaderRefresh:(BOOL)useHeaderRefresh
{
    if(useHeaderRefresh) {
        self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginHeaderRefresh)];
    }else {
        self.tableView.mj_footer = nil;
    }
}

-(void)beginHeaderRefresh
{
    refreshMethod = 1;
    self.pageNum = 1;
    
    [self.params setObject:[NSString stringWithFormat:@"%ld", self.pageNum] forKey:@"pageNum"];
    [self.params setObject:[NSString stringWithFormat:@"%ld", self.pageSize] forKey:@"pageSize"];
    [self beginHttpRequest];
}

-(void) beginHttpRequest
{
    [self beforeHttpRequest];
    [RSHttp requestWithURL:self.url params:self.params httpMethod:self.httpMethod success:^(NSDictionary *data) {
        if(refreshMethod == 1) {
            self.models = [NSMutableArray array];
        }
        NSInteger before = [self.models count];
        [self afterHttpSuccess:data];
        [self.tableView reloadData];
        NSInteger after = [self.models count];
        if(refreshMethod == 1 && self.tableView.mj_header) {
            [self.tableView.mj_header endRefreshing];
        }
        if(refreshMethod == 2 && self.tableView.mj_footer) {
            if(after - before < self.pageSize) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }
        if(after < self.pageSize && self.tableView.mj_footer) {
            self.tableView.mj_footer.hidden = YES;
        }
        self.pageNum++;
        refreshMethod = 0;
    } failure:^(NSInteger code, NSString *errmsg) {
        [self afterHttpFailure:code errmsg:errmsg];
    }];
}

-(void) beforeHttpRequest
{
    if(!self.params) {
        self.params = [NSMutableDictionary dictionary];
    }
}

-(void) afterHttpSuccess:(NSDictionary *)data
{
    [self hidHUD];
}

-(void) afterHttpFailure:(NSInteger)code errmsg:(NSString *)errmsg
{
    [self hidHUD];
    [self showToast:errmsg];
}
@end
