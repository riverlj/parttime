//
//  DetailMoneyOfMonth.m
//  RedScarf
//
//  Created by zhangb on 15/8/29.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "DetailMoneyOfMonth.h"

@implementation DetailMoneyOfMonth
{
    NSMutableArray *salaryArr;
    NSMutableArray *typeArr;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"账单详情";
    salaryArr = [NSMutableArray array];
    typeArr = [NSMutableArray arrayWithObjects:@"底薪",@"提成",@"推广费",@"奖金",@"提成调整",@"推广费调整",@"总计", nil];
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    self.tableView.left = 18;
    self.tableView.width = kUIScreenWidth - 2* self.tableView.left;
    [self getMessage];
}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.deatilSalary forKey:@"date"];
    [RSHttp requestWithURL:@"/salary/date" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        for (NSMutableDictionary *dic in [data objectForKey:@"body"]) {
            if ([dic objectForKey:@"basis"]) {
                [salaryArr addObject:[dic objectForKey:@"basis"]];
            }
            if ([dic objectForKey:@"commission"]) {
                [salaryArr addObject:[dic objectForKey:@"commission"]];
                
            }
            if ([dic objectForKey:@"promotion"]) {
                [salaryArr addObject:[dic objectForKey:@"promotion"]];
            }
            if ([dic objectForKey:@"adjustBonus"]) {
                [salaryArr addObject:[dic objectForKey:@"adjustBonus"]];
            }
            if ([dic objectForKey:@"adjustCommission"]) {
                [salaryArr addObject:[dic objectForKey:@"adjustCommission"]];
            }
            if ([dic objectForKey:@"adjustPromotion"]) {
                [salaryArr addObject:[dic objectForKey:@"adjustPromotion"]];
            }
            if ([dic objectForKey:@"sum"]) {
                [salaryArr addObject:[dic objectForKey:@"sum"]];
            }
            
        }
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self showToast:errmsg];
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60, 0, self.tableView.width, 30)];
    view.backgroundColor = MakeColor(240, 240, 240);

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.tableView.width/2, 0, 1, 30)];
    line.backgroundColor = MakeColor(229, 229, 229);
    [view addSubview:line];
    for (int i=0; i<2; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = MakeColor(87, 87, 87);
        label.font = [UIFont systemFontOfSize:12];

        label.frame = CGRectMake(self.tableView.width/2*i, 0,self.tableView.width/2 , 30);
        if (i==0) {
            label.text = @"类型";
        }
        if (i==1) {
            label.text = @"工资";
        }
        
        [view addSubview:label];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return salaryArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(self.tableView.width/2, 0, 1, 40)];
    line.backgroundColor = MakeColor(229, 229, 229);
    [cell.contentView addSubview:line];
    for (int i=0; i<2; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = MakeColor(87, 87, 87);
        label.font = [UIFont systemFontOfSize:12];
        
        label.frame = CGRectMake(self.tableView.width/2*i, 0,self.tableView.width/2 , 40);
        if (i==0) {
            label.text = typeArr[indexPath.row];
        }
        if (i==1) {
            label.text = [NSString stringWithFormat:@"%@",salaryArr[indexPath.row]];
        }
        
        [cell.contentView addSubview:label];
    }    
    return cell;
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
