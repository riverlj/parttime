//
//  TotalMoneyViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/25.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "TotalMoneyViewController.h"
#import "Header.h"
#import "ThreeRowsCell.h"

@implementation TotalMoneyViewController
{
    NSMutableArray *dataArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
    [self comeBack:nil];
}

-(void)viewDidLoad
{
    self.title = @"推广费总金额";
    self.view.backgroundColor = [UIColor whiteColor];
    dataArray = [NSMutableArray array];
    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.barTintColor = MakeColor(32, 102, 208);
    self.tabBarController.tabBar.hidden = YES;
    [self getMessage];
    [self navigationBar];
    [self initTableView];
}

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];

    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    
    [RedScarf_API requestWithURL:@"/promotionActivity/index/promotionAccount" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            for (NSMutableDictionary *dic in [[result objectForKey:@"msg"] objectForKey:@"list"]) {
                NSLog(@"dic = %@",dic);
                [dataArray addObject:dic];
            }
            [self.tableView reloadData];
        }
    }];
    
}


-(void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 5, kUIScreenWidth-30, kUIScreenHeigth-5)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
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
            label.text = @"推广费";
            line.frame = CGRectMake(i*view.frame.size.width/3, 0, 1, 30);
        }
        if (i == 2) {
            label.text = @"累计金额";
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
    
    NSMutableDictionary *dic = [dataArray objectAtIndex:indexPath.row];
    cell.date.text = [dic objectForKey:@"date"];
    cell.funsCount.text = [dic objectForKey:@"AccountInOneDay"];
    cell.totalCount.text = [dic objectForKey:@"AccountAccumulate"];
    
    return cell;
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
