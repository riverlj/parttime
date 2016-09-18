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
#import "RSTwoTitleModel.h"
#import "RSSingleTitleCell.h"
#import "WalletHeaderViewCell.h"
#import "BoundAccountViewController.h"

#define HEADER_HEIGHT [LayOutConfig adapterDeviceHeight(187)]
#define HEADER_COLOR [NSString colorFromHexString:@"1474ff"]

@interface WalletViewController ()
{
    UIImage *oldImg1;
    UIImage *oldImg2;
    
    UIView *headerView;
    //微信账号绑定状态
    NSInteger wxstatusid;
    NSString *wxaccount;
}
@end

@implementation WalletViewController
{
    NSString *salary; //账户余额
    NSString *pwdStatus;    //密码状态
    NSString *telNum;
    NSInteger status;   //账号状态
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"红领巾钱包";
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"提现" style:UIBarButtonItemStylePlain target:self action:@selector(didClickTianXian)];
    self.navigationItem.rightBarButtonItem = right;
    right.tintColor = [UIColor whiteColor];
    UIView *footView = [[UIView alloc] init];
    self.tableView.tableFooterView = footView;
    self.tableView.y = -64;
    
}

-(void)getWeixin {
    __weak WalletViewController *selfB = self;
    [RSHttp requestWithURL:@"/user/wxinfo" params:nil httpMethod:@"GET" success:^(NSDictionary *data) {
        
        NSDictionary *dic = [data valueForKey:@"body"];
        wxstatusid = [[dic valueForKey:@"status"] integerValue];
        NSDictionary *wxdic = [dic valueForKey:@"userinfo"];
        wxaccount = [wxdic valueForKey:@"nickname"];
        [selfB getMessage];
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    oldImg1 = [self.navigationController.navigationBar backgroundImageForBarMetrics:UIBarMetricsDefault];
    oldImg2 = [self.navigationController.navigationBar shadowImage];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    [self getToken];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:oldImg1 forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:oldImg2];
}

//获取支付系统需要的token
-(void)getToken
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self showHUD:@"加载中"];
    //获取支付TOken
    __weak WalletViewController *selfB = self;
    [RSHttp requestWithURL:@"/user/token/finance" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [NSUserDefaults setValue:[data objectForKey:@"body"] forKey:@"withdrawToken"];
        [selfB getWeixin];
    } failure:^(NSInteger code, NSString *errmsg) {
        [selfB hidHUD];
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //获取账号信息，
    [RSHttp payRequestWithURL:@"/account/accountInfo" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [self hidHUD];
        NSMutableDictionary *dic = [data objectForKey:@"body"];
        salary = [NSString stringWithFormat:@"%@",[dic objectForKey:@"money"]];
        double money  = [salary longLongValue] / 100.0;
        salary = [NSString stringWithFormat:@"%.2lf", money];
        pwdStatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pwdStatus"]];
        telNum = [NSString stringWithFormat:@"%@",[dic objectForKey:@"phoneNumber"]];
        status = [[dic objectForKey:@"status"] integerValue];
        
        [self generageModels];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self showToast:errmsg];
    }];
}


//构建数据模型
-(void) generageModels
{
    self.sections = [NSMutableArray array];
    _models = [NSMutableArray array];
    
    NSMutableArray *items1 = [NSMutableArray array];
    
    
    RSTwoTitleModel *model = [[RSTwoTitleModel alloc]init];
    model.cellClassName = @"WalletHeaderViewCell";
    model.onetitle = @"账户余额(元)";
    model.twotitle =  salary;
    model.cellHeight = 128+64;
    [items1 addObject:model];
    
    model = [[RSTwoTitleModel alloc]init];
    model.cellClassName = @"WalletViewCell";
    model.onetitle = @"账号绑定";
    model.cellHeight = 48;
    if (wxstatusid == 1) {
        model.twotitle = @"已绑定";
    }else {
        model.twotitle = @"未绑定";
    }
    [model setSelectAction:@selector(bankcard) target:self];
    [items1 addObject:model];
    
    RSSingleTitleModel *singleModel = [[RSSingleTitleModel alloc]init];
    NSDictionary *attrDict = @{
                               NSFontAttributeName : Font(15),
                               NSForegroundColorAttributeName : [NSString colorFromHexString:@"222222"]
                               };
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:@"交易密码" attributes:attrDict];
    singleModel.str = attrStr;
    singleModel.cellHeight = 48;
    [items1 addObject:singleModel];
    [singleModel setSelectAction:@selector(modifyPass) target:self];
    [_models addObject:items1];
    
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
    BoundAccountViewController *bactl = [[BoundAccountViewController alloc] init];
    [self.navigationController pushViewController:bactl animated:YES];
}


-(void)modifyPass
{
    TransactionViewController *transactionVC = [[TransactionViewController alloc] init];
    transactionVC.title = @"交易密码";
    transactionVC.telNum = telNum;
    transactionVC.pwdStatus = pwdStatus;
    [self.navigationController pushViewController:transactionVC animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
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
    
    if (wxstatusid != 1) {
        [[RSToastView shareRSToastView] showToast:@"请先绑定微信账号"];
        return;
    }
    WithdrawViewController *withdrawVC = [[WithdrawViewController alloc] init];
    withdrawVC.pwdStatus = pwdStatus;
    withdrawVC.telNum = telNum;
    withdrawVC.salary = salary;
    withdrawVC.wxaccount = wxaccount;
    [self.navigationController pushViewController:withdrawVC animated:YES];
}


@end
