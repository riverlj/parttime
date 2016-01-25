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
    refreshMethod = 0;
    self.httpMethod = @"GET";
    self.params = [NSMutableDictionary dictionary];
    self.models = [NSMutableArray array];
}

-(void) setModels:(NSMutableArray *)models
{
    [super setModels:models];
    if([self.models count] < self.pageSize && self.tableView.mj_footer) {
        self.tableView.mj_footer.hidden = YES;
    }
}

//如果设置下拉刷新
-(void)setUseFooterRefresh:(BOOL)useFooterRefresh
{
    _useFooterRefresh = useFooterRefresh;
    if(useFooterRefresh) {
        if(!self.tableView.mj_footer) {
            self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(beginFooterRefresh)];
        }
    }else {
        self.tableView.mj_footer = nil;
    }
}

-(void)beginFooterRefresh
{
    refreshMethod = 2;
    [self beginHttpRequest];
}

//如果设置上拉刷新
-(void)setUseHeaderRefresh:(BOOL)useHeaderRefresh
{
    _useHeaderRefresh = useHeaderRefresh;
    if(useHeaderRefresh) {
        if(!self.tableView.mj_header) {
            self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(beginHeaderRefresh)];
        }
    }else {
        self.tableView.mj_header = nil;
    }
}

-(void)beginHeaderRefresh
{
    refreshMethod = 1;
    self.pageNum = 1;
    [self beginHttpRequest];
}

-(void) beginHttpRequest
{
    [self beforeHttpRequest];
    if(!self.url || [self.url isEqualToString:@""]) {
        return;
    }
    [RSHttp requestWithURL:self.url params:self.params httpMethod:self.httpMethod success:^(NSDictionary *data) {
        [self beforeProcessHttpData];
        NSInteger before = [self.models count];
        [self afterHttpSuccess:data];
        NSInteger after = [self.models count];
        [self afterProcessHttpData:before afterCount:after];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self afterHttpFailure:code errmsg:errmsg];
    }];
}

-(void) beforeHttpRequest
{
    self.params = [NSMutableDictionary dictionary];
    if(self.useHeaderRefresh || self.useFooterRefresh) {
        [self.params setObject:[NSNumber numberWithInteger:self.pageNum] forKey:@"pageNum"];
        [self.params setObject:[NSNumber numberWithInteger:self.pageSize] forKey:@"pageSize"];
    }
    //如果是正常请求，默认加上loading
    if(refreshMethod == 0) {
        [self showHUD:@"加载中"];
    }
}

-(void) beforeProcessHttpData
{
    [self hidHUD];
    if(refreshMethod !=2 ) {
        self.models = [NSMutableArray array];
    }
}

-(void) afterHttpSuccess:(NSDictionary *)data
{
}

-(void) afterProcessHttpData:(NSInteger)before afterCount:(NSInteger)after
{
    [self.tableView reloadData];
    if(self.tableView.mj_header) {
        [self.tableView.mj_header endRefreshing];
    }
    if(self.tableView.mj_footer) {
        if(after - before < self.pageSize) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }
    if(after < self.pageSize && self.tableView.mj_footer) {
        self.tableView.mj_footer.hidden = YES;
    }
    
    if(after == 0) {
        if(![self.tips superview]) {
            [self.tips setFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height)];
            //修改tips 的位置，防止遮住搜索框等表格头
            if(self.tableView.tableHeaderView) {
                self.tips.top = self.tableView.tableHeaderView.height;
            }
            [self.tableView addSubview:self.tips];
        }
    } else {
        if([self.tips superview]) {
            [self.tips removeFromSuperview];
        }
    }
    self.pageNum++;
    refreshMethod = 0;
}


-(void) afterHttpFailure:(NSInteger)code errmsg:(NSString *)errmsg
{
    [self hidHUD];
    [self showToast:errmsg];
    if(refreshMethod == 1) {
        [self.tableView.mj_header endRefreshing];
    }
    if(refreshMethod == 2) {
        [self.tableView.mj_footer endRefreshing];
    }
}
@end
