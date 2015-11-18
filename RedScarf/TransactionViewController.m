//
//  TransactionViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/30.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "TransactionViewController.h"
#import "DoPassWordViewController.h"
#import "SalaryTableViewCell.h"

@interface TransactionViewController ()

@end

@implementation TransactionViewController
{
    NSMutableArray *bodyArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self comeBack:nil];
    bodyArray = [NSMutableArray array];
    [self initTableView];
    if ([self.title isEqualToString:@"提现纪录"]) {
        [self getMessage];
    }
    if ([self.title isEqualToString:@"余额明细"]) {
        [self getSalaryMessage];
    }
}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"withdrawToken"]) {
        [params setObject:[defaults objectForKey:@"withdrawToken"] forKey:@"token"];
    }
    [params setObject:@"0" forKey:@"timestamp"];
    [RedScarf_API zhangbRequestWithURL:[NSString stringWithFormat:@"%@/pay/withdraw/record",REDSCARF_PAY_URL] params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if (![[result objectForKey:@"code"] boolValue]) {
            [bodyArray removeAllObjects];
            bodyArray = [result objectForKey:@"body"];
        }else{
            [self alertView:[result objectForKey:@"body"]];
        }
        [self.tableView reloadData];
    }];

}

-(void)getSalaryMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"withdrawToken"]) {
        [params setObject:[defaults objectForKey:@"withdrawToken"] forKey:@"token"];
    }
    [params setObject:@"0" forKey:@"timestamp"];
    [RedScarf_API zhangbRequestWithURL:[NSString stringWithFormat:@"%@/account/moneyChangeRecord",REDSCARF_PAY_URL] params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if (![[result objectForKey:@"code"] boolValue]) {
            [bodyArray removeAllObjects];
            bodyArray = [result objectForKey:@"body"];
        }else{
            [self alertView:[result objectForKey:@"body"]];
        }
        [self.tableView reloadData];
    }];
}

-(void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = color242;
    UIView *footView = [[UIView alloc] init];
    self.tableView.tableFooterView = footView;
    [self.view addSubview:self.tableView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.title isEqualToString:@"交易密码"]) {
        DoPassWordViewController *doPassWordVC = [[DoPassWordViewController alloc] init];
        if (indexPath.section == 0) {
            doPassWordVC.title = @"设置交易密码";
        }
        if (indexPath.section == 1) {
            doPassWordVC.title = @"重置交易密码";
        }
        doPassWordVC.telNum = self.telNum;
        [self.navigationController pushViewController:doPassWordVC animated:YES];
    }
    if ([self.title isEqualToString:@"提现纪录"]) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [bodyArray objectAtIndex:indexPath.row];
        if ([[dic objectForKey:@"status"] intValue] == 0) {
            [self alertView:@"提现申请正在审核中"];
        }
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            [self alertView:@"提现申请正在打款"];
        }
        if ([[dic objectForKey:@"status"] intValue] == 2) {
            [self alertView:@"银行卡信息有误，请更改"];
        }
        if ([[dic objectForKey:@"status"] intValue] == 3) {
            [self alertView:@"提现已成功"];
        }

    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([self.title isEqualToString:@"交易密码"]) {
    return 10;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.title isEqualToString:@"交易密码"]) {
        return 50;
    }
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([self.title isEqualToString:@"交易密码"]) {
        return 1;
    }
    return bodyArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForheaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 10)];
    view.backgroundColor = color242;
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([self.title isEqualToString:@"交易密码"]) {
        return 2;
    }
    return 1;
}

-(SalaryTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    SalaryTableViewCell *cell = [[SalaryTableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    if ([self.title isEqualToString:@"交易密码"]) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        UILabel *title = [[UILabel alloc] init];
        title.frame = CGRectMake(15, 0, 100, 50);
        title.font = textFont14;
        title.textColor = color155;
        [cell.contentView addSubview:title];
        
        if (indexPath.section == 0) {
            title.text = @"设置交易密码";
        }
        if (indexPath.section == 1) {
            title.text = @"重置交易密码";
        }

    }else if([self.title isEqualToString:@"提现纪录"]){
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [bodyArray objectAtIndex:indexPath.row];
        cell.detailLabel.text = @"提现";
        if ([[dic objectForKey:@"status"] intValue] == 0) {
            cell.salaryLabel.text = [NSString stringWithFormat:@"审核中"];
        }
        if ([[dic objectForKey:@"status"] intValue] == 1) {
            cell.salaryLabel.text = [NSString stringWithFormat:@"正在打款"];
        }
        if ([[dic objectForKey:@"status"] intValue] == 2) {
            cell.salaryLabel.text = [NSString stringWithFormat:@"提现失败"];
        }
        if ([[dic objectForKey:@"status"] intValue] == 3) {
            cell.salaryLabel.text = [NSString stringWithFormat:@"提现成功"];
        }
        NSString *str = [self timeIntersince1970:[[dic objectForKey:@"requestTime"] doubleValue]];

        cell.dateLabel.text = [NSString stringWithFormat:@"%@",str];
        cell.changeLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"totalFee"] floatValue]/100];
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [bodyArray objectAtIndex:indexPath.row];
        cell.detailLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"attach"]];
        cell.salaryLabel.text = [NSString stringWithFormat:@"余额：%.2f",[[dic objectForKey:@"accountMoney"] floatValue]/100];
        //将时间戳转化为时间    13位的除1000  我擦
        NSString *str = [self timeIntersince1970:[[dic objectForKey:@"timePoint"] doubleValue]];
      
        cell.dateLabel.text = [NSString stringWithFormat:@"%@",str];
        if ([[dic objectForKey:@"totalFee"] intValue] > 0) {
            cell.changeLabel.textColor = [UIColor greenColor];
            cell.changeLabel.text = [NSString stringWithFormat:@"+%.2f",[[dic objectForKey:@"totalFee"] floatValue]/100];
        }else{
            cell.changeLabel.textColor = [UIColor redColor];
            cell.changeLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"totalFee"] floatValue]/100];
        }
    }
    
    return cell;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end