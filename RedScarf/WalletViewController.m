//
//  WalletViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/30.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "WalletViewController.h"
#import "MyBankCardVC.h"
#import "TransactionViewController.h"
#import "WithdrawViewController.h"

@interface WalletViewController ()

@end

@implementation WalletViewController
{
    NSString *salary;
    NSString *pwdStatus;
    NSString *telNum;
    NSString *showStr;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self comeBack:nil];
    self.view.backgroundColor = color242;
    self.title = @"红领巾钱包";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"提现" style:UIBarButtonItemStylePlain target:self action:@selector(didClickTianXian)];
    self.navigationItem.rightBarButtonItem = right;
    [self getToken];
    [self initTableView];
}
//获取支付系统需要的token
-(void)getToken
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [RSHttp requestWithURL:@"/user/token/finance" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:[data objectForKey:@"body"] forKey:@"withdrawToken"];
        [defaults synchronize];
        [self getMessage];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
    }];

}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [RSHttp payRequestWithURL:@"/account/accountInfo" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSMutableDictionary *dic = [data objectForKey:@"body"];
        salary = [NSString stringWithFormat:@"%@",[dic objectForKey:@"money"]];
        pwdStatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pwdStatus"]];
        telNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"phoneNumber"]];
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
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            TransactionViewController *transactionVC = [[TransactionViewController alloc] init];
            transactionVC.title = @"余额明细";
            [self.navigationController pushViewController:transactionVC animated:YES];
        }
        if (indexPath.row == 1) {
            MyBankCardVC *bankCardVC = [[MyBankCardVC alloc] init];
            [self.navigationController pushViewController:bankCardVC animated:YES];

        }
    }
    if (indexPath.section == 1) {
        TransactionViewController *transactionVC = [[TransactionViewController alloc] init];
        transactionVC.title = @"交易密码";
        transactionVC.telNum = telNum;
        [self.navigationController pushViewController:transactionVC animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 2;
    }
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForheaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 10)];
    view.backgroundColor = color242;
    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    UILabel *title = [[UILabel alloc] init];
    title.frame = CGRectMake(15, 0, 70, 50);
    title.font = textFont14;
    title.textColor = color155;
    [cell.contentView addSubview:title];
    
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            title.text = @"账户余额：";
            UILabel *salaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(title.frame.size.width+title.frame.origin.x, 0, 150, 50)];
            salaryLabel.font = textFont14;
            salaryLabel.text = [NSString stringWithFormat:@"¥%.2f",[salary floatValue]/100];
            salaryLabel.textColor = colorgreen65;
            [cell.contentView addSubview:salaryLabel];
        }
        if (indexPath.row == 1) {
            title.text = @"银行卡";
        }
    }
    if (indexPath.section == 1) {
        title.text = @"交易密码";
    }
    
    return cell;
}

-(void)didClickTianXian
{
    if (showStr.length) {
        [self alertView:showStr];
        return;
    }else{
        WithdrawViewController *withdrawVC = [[WithdrawViewController alloc] init];
        withdrawVC.pwdStatus = pwdStatus;
        withdrawVC.telNum = telNum;
        withdrawVC.salary = salary;
        [self.navigationController pushViewController:withdrawVC animated:YES];

    }
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
