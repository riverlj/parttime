//
//  WalletViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/30.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "WalletViewController.h"
#import "BankCardsViewController.h"
#import "TransactionViewController.h"
#import "WithdrawViewController.h"
#import "RSSingleTitleModel.h"

@interface WalletViewController ()

@end

@implementation WalletViewController
{
    NSString *salary;
    NSString *pwdStatus;
    NSString *telNum;
    NSInteger status;
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([NSUserDefaults getValue:@"withdrawToken"] && ![[NSUserDefaults getValue:@"withdrawToken"] isEqualToString:@""]) {
        [self getMessage];
    } else {
        [self getToken];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红领巾钱包";
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"提现" style:UIBarButtonItemStylePlain target:self action:@selector(didClickTianXian)];
    self.navigationItem.rightBarButtonItem = right;
    UIView *footView = [[UIView alloc] init];
    self.tableView.tableFooterView = footView;
    [self generageModels];
    [self getToken];
}
//获取支付系统需要的token
-(void)getToken
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self showHUD:@"加载中"];
    [RSHttp requestWithURL:@"/user/token/finance" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [NSUserDefaults setValue:[data objectForKey:@"body"] forKey:@"withdrawToken"];
        [self getMessage];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self showToast:errmsg];
    }];
}


-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [RSHttp payRequestWithURL:@"/account/accountInfo" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [self hidHUD];
        NSMutableDictionary *dic = [data objectForKey:@"body"];
        salary = [NSString stringWithFormat:@"%@",[dic objectForKey:@"money"]];
        pwdStatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pwdStatus"]];
        telNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"phoneNumber"]];
        status = [[dic objectForKey:@"status"] integerValue];
        [self generageModels];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self showToast:errmsg];
    }];
}

-(void) generageModels
{
    self.sections = [NSMutableArray array];
    _models = [NSMutableArray array];
    
    NSMutableArray *items1 = [NSMutableArray array];
    RSSingleTitleModel *model = [[RSSingleTitleModel alloc]init];
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              textFont14, NSFontAttributeName,
                              color155, NSForegroundColorAttributeName, nil];
    NSMutableAttributedString *attrStr;
    attrStr = [[NSMutableAttributedString alloc]initWithString:@"账户余额：" attributes:attrDict];
    if(salary) {
        NSString *moneyStr = [NSString stringWithFormat:@"￥%.2f",[salary floatValue]/100];
        attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"账户余额：%@", moneyStr] attributes:attrDict];
        [attrStr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color_green_65cb99, NSForegroundColorAttributeName, nil] range:NSMakeRange(5, [moneyStr length])];
    }
    model.str = attrStr;
    [model setSelectAction:@selector(transaction) target:self];
    [items1 addObject:model];
    
    model = [[RSSingleTitleModel alloc]init];
    attrStr = [[NSMutableAttributedString alloc]initWithString:@"银行卡" attributes:attrDict];
    model.str = attrStr;
    [items1 addObject:model];
    [model setSelectAction:@selector(bankcard) target:self];
    [_models addObject:items1];
    
    NSMutableArray *items2 = [NSMutableArray array];
    model = [[RSSingleTitleModel alloc] init];
    attrStr = [[NSMutableAttributedString alloc]initWithString:@"交易密码" attributes:attrDict];
    model.str = attrStr;
    [model setSelectAction:@selector(modifyPass) target:self];
    [items2 addObject:model];
    [_models addObject:items2];
    [self.tableView reloadData];
}

-(void)transaction
{
    TransactionViewController *transactionVC = [[TransactionViewController alloc] init];
    transactionVC.title = @"余额明细";
    [self.navigationController pushViewController:transactionVC animated:YES];
}

-(void)bankcard
{
    BankCardsViewController *bankCardVC = [[BankCardsViewController alloc] init];
    [self.navigationController pushViewController:bankCardVC animated:YES];
}

-(void)modifyPass
{
    TransactionViewController *transactionVC = [[TransactionViewController alloc] init];
    transactionVC.title = @"交易密码";
    transactionVC.telNum = telNum;
    [self.navigationController pushViewController:transactionVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}


-(UIView *)tableView:(UITableView *)tableView viewForheaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 10)];
    view.backgroundColor = color_red_e54545;
    return view;
}

-(void)didClickTianXian
{
    if(status == 2) {
        [self showToast:@"当前账号已经被冻结"];
        return;
    }
    WithdrawViewController *withdrawVC = [[WithdrawViewController alloc] init];
    withdrawVC.pwdStatus = pwdStatus;
    withdrawVC.telNum = telNum;
    withdrawVC.salary = salary;
    [self.navigationController pushViewController:withdrawVC animated:YES];
}

@end
