//
//  FunsViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/25.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "FunsViewController.h"
#import "Header.h"
#import "ThreeRowsCell.h"
#import "MyModel.h"

@implementation FunsViewController
{
    NSMutableArray *dataArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [super viewWillAppear:animated];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"推广粉丝数";
    dataArray = [NSMutableArray array];
    [self navigationBar];
    [self getMessage];
    [self initTableView];
}

-(void)getMessage
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];

    app.tocken = [UIUtils replaceAdd:app.tocken];
    
    [RSHttp requestWithURL:@"/promotionActivity/index/fansTotal" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        for (NSMutableDictionary *dic in [[data objectForKey:@"msg"] objectForKey:@"list"]) {
            NSLog(@"dic = %@",dic);
            [dataArray addObject:dic];
        }
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

-(void)initTableView
{
    self.tableView.left = 18;
    self.tableView.width = kUIScreenWidth - 2 * self.tableView.left;
    self.tableView.tableFooterView = [UIView new];
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
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*view.frame.size.width/3, 0, view.frame.size.width/3, 30)];
        [view addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = MakeColor(87, 87, 87);
        label.font = [UIFont systemFontOfSize:14];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = MakeColor(229, 229, 229);
        [view addSubview:line];
        if (i == 0) {
            label.text = @"日期";
        }
        if (i == 1) {
            label.text = @"粉丝人数";
            line.frame = CGRectMake(i*view.frame.size.width/3, 0, 1, 30);
        }
        if (i == 2) {
            label.text = @"累计人数";
            line.frame = CGRectMake(i*view.frame.size.width/3, 0, 1, 30);
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
    ThreeRowsCell *cell = [[ThreeRowsCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    for (int i = 1; i < 3; i++) {
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = MakeColor(229, 229, 229);
        line.frame = CGRectMake(i*((kUIScreenWidth-30)/3), 0, 1, 40);
        [cell.contentView addSubview:line];

    }
    NSMutableDictionary *dic = dataArray[indexPath.row];
    cell.date.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"date"]];
    cell.funsCount.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fansNumAccumulate"]];
    cell.totalCount.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"fansNumInOneDay"]];
    
    return cell;
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
