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
    [params setObject:@"0" forKey:@"timestamp"];
    [RSHttp payRequestWithURL:@"/pay/withdraw/record" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [bodyArray removeAllObjects];
        bodyArray = [data objectForKey:@"body"];
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
    }];
}

-(void)getSalaryMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"0" forKey:@"timestamp"];
    [RSHttp payRequestWithURL:@"/account/moneyChangeRecord" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [bodyArray removeAllObjects];
        bodyArray = [data objectForKey:@"body"];
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
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
        NSString *str = [NSDate formatTimestamp:[[dic objectForKey:@"requestTime"] integerValue]/1000 format:@"yyyy-MM-dd"];
        cell.dateLabel.text = [NSString stringWithFormat:@"%@",str];
        cell.changeLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"totalFee"] floatValue]/100];
    }else{
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic = [bodyArray objectAtIndex:indexPath.row];
        cell.detailLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"attach"]];
        cell.salaryLabel.text = [NSString stringWithFormat:@"余额：%.2f",[[dic objectForKey:@"accountMoney"] floatValue]/100];
        NSString *str = [NSDate formatTimestamp:[[dic objectForKey:@"timePoint"] integerValue]/1000 format:@"yyyy-MM-dd"];

        cell.dateLabel.text = [NSString stringWithFormat:@"%@",str];
        if ([[dic objectForKey:@"totalFee"] intValue] > 0) {
            cell.changeLabel.textColor = colorgreen65;
            cell.changeLabel.text = [NSString stringWithFormat:@"+%.2f",[[dic objectForKey:@"totalFee"] floatValue]/100];
        }else{
            cell.changeLabel.textColor = colorrede5;
            cell.changeLabel.text = [NSString stringWithFormat:@"%.2f",[[dic objectForKey:@"totalFee"] floatValue]/100];
        }
    }
    
    return cell;
}

@end
