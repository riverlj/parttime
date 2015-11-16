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
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
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
//    [self getMessage];
    [self initTableView];
}
//获取支付系统需要的token
-(void)getToken
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [RedScarf_API requestWithURL:@"/user/token/finance" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@" token result = %@",result);
        if (![[result objectForKey:@"code"] boolValue]) {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:[result objectForKey:@"body"] forKey:@"withdrawToken"];
            [defaults synchronize];
            [self getMessage];
        }else{
            [self alertView:[result objectForKey:@"msg"]];
        }
    }];

}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"withdrawToken"]) {
        [params setObject:[defaults objectForKey:@"withdrawToken"] forKey:@"token"];
    }
    
    [RedScarf_API zhangbRequestWithURL:[NSString stringWithFormat:@"%@/account/accountInfo",REDSCARF_PAY_URL] params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if (![[result objectForKey:@"code"] boolValue]) {

            NSMutableDictionary *dic = [result objectForKey:@"body"];
            salary = [NSString stringWithFormat:@"%@",[dic objectForKey:@"money"]];
            pwdStatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pwdStatus"]];
            telNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"phoneNumber"]];
        }else{
            showStr = [NSString stringWithFormat:@"%@",[result objectForKey:@"body"]];
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
            salaryLabel.textColor = [UIColor greenColor];
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
