//
//  MyFunsViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/26.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "MyFunsViewController.h"
#import "FourRowsCell.h"
#import "MyModel.h"

@implementation MyFunsViewController
{
    NSMutableArray *dataArray;
    int pageNum;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [super viewWillAppear:animated];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的粉丝";
    dataArray = [NSMutableArray array];
    pageNum = 1;
    [self getMessage];
    [self navigationBar];
    [self initTableView];
}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [params setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    
    [RSHttp requestWithURL:@"/promotionActivity/index/fansDetial" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        pageNum ++;
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [data objectForKey:@"body"];
        
        NSInteger i = 0;
        for (NSDictionary *temp in [dic objectForKey:@"fansDetail"]) {
            [dataArray addObject:temp];
            i++;
        }
        
        UILabel *label = (UILabel *)[self.view viewWithTag:201];
        label.text = [NSString stringWithFormat:@"粉丝下单累计总金额:%@",[dic objectForKey:@"fansOrderTotalAccount"]];
        [self.tableView reloadData];
        [self.tableView.mj_footer endRefreshing];
        if(i < 10) {
            self.tableView.mj_footer.hidden = YES;
        }
    } failure:^(NSInteger code, NSString *errmsg) {
        [self.tableView.mj_footer endRefreshing];
        [self showToast:errmsg];
    }];
}

-(void)initTableView
{
    self.tableView.left = 18;
    self.tableView.width = kUIScreenWidth - 2*self.tableView.left;
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, kUIScreenWidth, 40)];
    countLabel.text = @"粉丝下单累计总金额:0";
    countLabel.tag = 201;
    countLabel.textColor = MakeColor(87, 87, 87);
    countLabel.font = [UIFont systemFontOfSize:12];
    self.tableView.tableHeaderView = countLabel;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMessage)];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kUIScreenWidth-30, 30)];
    view.backgroundColor = MakeColor(240, 240, 240);
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*view.frame.size.width/4, 0, view.frame.size.width/4, 30)];
        [view addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = MakeColor(87, 87, 87);
        label.font = [UIFont systemFontOfSize:12];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = MakeColor(229, 229, 229);
        [view addSubview:line];
        if (i == 0) {
            label.text = @"姓名";
        }
        if (i == 1) {
            label.text = @"加入日期";
            line.frame = CGRectMake(i*view.frame.size.width/4, 0, 1, 30);
        }
        if (i == 2) {
            label.text = @"下单总数";
            line.frame = CGRectMake(i*view.frame.size.width/4, 0, 1, 30);
        }
        if (i == 3) {
            label.text = @"下单金额";
            line.frame = CGRectMake(i*view.frame.size.width/4, 0, 1, 30);
        }
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    FourRowsCell *cell = [[FourRowsCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    for (int i = 1; i < 4; i++) {
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = MakeColor(229, 229, 229);
        line.frame = CGRectMake(i*((kUIScreenWidth-30)/4), 0, 1, 40);
        [cell.contentView addSubview:line];
        
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = dataArray[indexPath.row];
    
    
    cell.date.text = [dic objectForKey:@"fansName"];
    cell.orderCount.text = [dic objectForKey:@"joinDate"];
    cell.reimburseCounts.text = [dic objectForKey:@"fansOrderNumInOneDay"];
    cell.totalOrderCounts.text = [dic objectForKey:@"fansOrderAccountInOneDay"];
    
    return cell;
}


@end
