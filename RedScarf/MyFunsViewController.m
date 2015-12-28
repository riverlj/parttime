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
    MJRefreshFooterView *footView;
    int pageNum;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [super viewWillAppear:animated];
}

-(void)viewDidLoad
{
    self.title = @"我的粉丝";
    self.view.backgroundColor = [UIColor whiteColor];
    dataArray = [NSMutableArray array];
    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.barTintColor = MakeColor(32, 102, 208);
    self.tabBarController.tabBar.hidden = YES;
    pageNum = 1;
    [self getMessage];
    [self navigationBar];
    [self initTableView];
}

-(void)getMessage
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [params setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    
    [RSHttp requestWithURL:@"/promotionActivity/index/fansDetial" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [data objectForKey:@"msg"];
        
        dataArray = [dic objectForKey:@"fansDetail"];
        
        UILabel *label = (UILabel *)[self.view viewWithTag:201];
        label.text = [NSString stringWithFormat:@"粉丝下单累计总金额:%@",[dic objectForKey:@"fansOrderTotalAccount"]];
        [footView endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}
//上拉刷新
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    pageNum += 1;
    [self getMessage];
}


-(void)initTableView
{
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, kUIScreenWidth, 40)];
    countLabel.text = @"粉丝下单累计总金额:0";
    countLabel.tag = 201;
    countLabel.textColor = MakeColor(87, 87, 87);
    countLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:countLabel];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 104, kUIScreenWidth-30, kUIScreenHeigth-5)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    footView = [[MJRefreshFooterView alloc] init];
    footView.delegate = self;
    footView.scrollView = self.tableView;
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
