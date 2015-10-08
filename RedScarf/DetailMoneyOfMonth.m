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
    self.title = @"账单详情";
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comeback"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    salaryArr = [NSMutableArray array];
    typeArr = [NSMutableArray arrayWithObjects:@"底薪",@"提成",@"推广费",@"奖金",@"提成调整",@"推广费调整",@"总计", nil];
    [self getMessage];
    [self initTableView];
}

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [params setObject:self.deatilSalary forKey:@"date"];
    [RedScarf_API requestWithURL:@"/salary/date" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            for (NSMutableDictionary *dic in [result objectForKey:@"msg"]) {
                NSLog(@"dic = %@",dic);
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
        }
    }];
}


-(void)initTableView
{
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 20)];
    head.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:head];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(60, 80, kUIScreenWidth-120, kUIScreenHeigth-60)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60, 0, kUIScreenWidth-120, 30)];
    view.backgroundColor = MakeColor(240, 240, 240);

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((kUIScreenWidth-120)/2, 0, 1, 30)];
    line.backgroundColor = MakeColor(229, 229, 229);
    [view addSubview:line];
    for (int i=0; i<2; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = MakeColor(87, 87, 87);
        label.font = [UIFont systemFontOfSize:12];

        label.frame = CGRectMake((kUIScreenWidth-120)/2*i, 0,(kUIScreenWidth-120)/2 , 30);
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

    UIView *line = [[UIView alloc] initWithFrame:CGRectMake((kUIScreenWidth-120)/2, 0, 1, 40)];
    line.backgroundColor = MakeColor(229, 229, 229);
    [cell.contentView addSubview:line];
    for (int i=0; i<2; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = MakeColor(87, 87, 87);
        label.font = [UIFont systemFontOfSize:12];
        
        label.frame = CGRectMake((kUIScreenWidth-120)/2*i, 0,(kUIScreenWidth-120)/2 , 40);
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
