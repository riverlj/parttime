//
//  WithdrawViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/31.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "WithdrawViewController.h"
#import "ZCTradeView.h"
#import "UIAlertView+Quick.h"
#import "SubmitViewController.h"
#import "TransactionViewController.h"
#import "DoPassWordViewController.h"
#import "BankCardsViewController.h"
#import "RSBankCardModel.h"
#import "MyBankCardVC.h"

@interface WithdrawViewController ()<ZCTradeViewDelegate,UIAlertViewDelegate,UITextFieldDelegate >

@property (nonatomic,strong)ZCTradeView *zctView;
@property (nonatomic,copy)NSString *str;
@property (nonatomic,copy)NSString *cardId;
@property (nonatomic,assign) int passWordNum;

@end

@implementation WithdrawViewController
{
    UITextField *input;
    UIView *bgBlackView;
    NSString *cardNum;
    UILabel *mLabel;
    NSArray *bankCards;
    UILabel *cardLabel;
    
    UIScrollView *scrollView;
}

-(void)viewWillAppear:(BOOL)animated
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [RSHttp payRequestWithURL:@"/account/accountInfo" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSMutableDictionary *dic = [data objectForKey:@"body"];
        self.pwdStatus = [NSString stringWithFormat:@"%@",[dic objectForKey:@"pwdStatus"]];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
    }];
    mLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.salary floatValue]/100];

    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self comeBack:nil];
    self.title = @"提现";
    self.passWordNum = 4;
    self.view.backgroundColor = RS_COLOR_BACKGROUND;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"提现纪录" style:UIBarButtonItemStylePlain target:self action:@selector(didClickTianXianJILu)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
    
    [self initView];
}

-(void)initView
{
    
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.height)];
    scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT);
    [self.view addSubview:scrollView];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, SCREEN_WIDTH, 45)];
    tipLabel.text = @"提取金额";
    tipLabel.textColor = [NSString colorFromHexString:@"515151"];
    tipLabel.font = Font(15);
    [contentView addSubview:tipLabel];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(tipLabel.x, tipLabel.bottom, SCREEN_WIDTH-2*tipLabel.x, 1.0/[UIScreen mainScreen].scale)];
    lineView.backgroundColor = [UIColor blackColor];
    [contentView addSubview:lineView];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(tipLabel.x, lineView.bottom + 35, 21, 26)];
    imageView.image = [UIImage imageNamed:@"icon_RMB"];
    [contentView addSubview:imageView];
    input = [[UITextField alloc] initWithFrame:CGRectMake(imageView.right + 15, imageView.top, SCREEN_WIDTH-imageView.right -  15 - tipLabel.x , 40)];
    input.textColor = [NSString colorFromHexString:@"222222"];
    input.font = BoldFont(40);
    [input becomeFirstResponder];
    input.keyboardType = UIKeyboardTypeNumberPad;
    input.layer.borderColor = RS_Line_Color.CGColor;
    input.centerY = imageView.centerY;

    [contentView addSubview:input];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(tipLabel.x, input.bottom + 5, SCREEN_WIDTH-2*tipLabel.x, 1.0/[UIScreen mainScreen].scale)];
    lineView.backgroundColor = [UIColor blackColor];
    [contentView addSubview:lineView];

    UILabel *totalMoneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipLabel.x, lineView.bottom + 5, SCREEN_WIDTH-2*tipLabel.x, 25)];
    totalMoneyLabel.text = [NSString stringWithFormat:@"可提金额%@元", _salary];
    totalMoneyLabel.textColor = [NSString colorFromHexString:@"515151"];
    totalMoneyLabel.font = Font(15);
    CGSize totalMoneyLabelsize = [totalMoneyLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    totalMoneyLabel.width = totalMoneyLabelsize.width;
    totalMoneyLabel.height = totalMoneyLabelsize.height + 10;
    totalMoneyLabel.textAlignment = NSTextAlignmentCenter;
    [contentView addSubview:totalMoneyLabel];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(tipLabel.x, totalMoneyLabel.bottom, SCREEN_WIDTH-2*tipLabel.x, 1.0/[UIScreen mainScreen].scale)];
    lineView.backgroundColor = [UIColor blackColor];
    lineView.hidden = YES;
    [contentView addSubview:lineView];
    
    contentView.height = lineView.bottom;
    [scrollView addSubview:contentView];
    
    UIView * accountContentView = [[UIView alloc] initWithFrame:CGRectMake(0, contentView.bottom + 10, SCREEN_WIDTH, 0)];
    accountContentView.backgroundColor = [UIColor whiteColor];
    UILabel *accountLabel = [[UILabel alloc] initWithFrame:CGRectMake(tipLabel.x, 0, SCREEN_WIDTH - 2*tipLabel.x, 48)];
    accountLabel.font = Font(15);
    accountLabel.textColor = [NSString colorFromHexString:@"515151"];
    accountLabel.text = [NSString stringWithFormat:@"微信账号：%@", _wxaccount];
    accountContentView.height = accountLabel.bottom;
    [accountContentView addSubview:accountLabel];
    [scrollView addSubview:accountContentView];
    
    
    UIButton *surebut = [UIButton buttonWithType:UIButtonTypeCustom];
    surebut.backgroundColor = RS_THRME_COLOR;
    [surebut setTitle:@"确认" forState:UIControlStateHighlighted];
    [surebut setTitle:@"确认" forState:UIControlStateNormal];
    surebut.layer.cornerRadius = 4;
    surebut.layer.masksToBounds = YES;
    [surebut addTarget:self action:@selector(clickSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    surebut.frame = CGRectMake(tipLabel.x, accountContentView.bottom + 10, SCREEN_WIDTH-2*tipLabel.x, 42);
    [scrollView addSubview:surebut];
    [self.view addSubview:scrollView];
    
}


-(void)didClickTianXianJILu
{
    TransactionViewController *transactionVC = [[TransactionViewController alloc] init];
    transactionVC.title = @"提现纪录";
    [self.navigationController pushViewController:transactionVC animated:YES];
}

-(void)clickSaveBtn
{
    if ([self.pwdStatus isEqualToString:@"0"]) {
        //设置交易密码
        [self settingPwdView];
        return;
    }else {
        if (!input.text.length) {
            [self alertView:@"提现金额不能为空"];
            return;
        }
        if ([input.text floatValue] <= 1) {
            [self alertView:@"提现金额不能小于1元"];
            return;
        }
        if ([input.text floatValue] > [self.salary floatValue]) {
            [self alertView:[NSString stringWithFormat:@"提现金额不能大于%@",self.salary]];
            return;
        }
        [input resignFirstResponder];
        
        NSString *str = [NSString stringWithFormat:@"确认提现%@元吗？",input.text];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:str delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
        return;

    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            [self inputText];
        }
            break;
        default:
            break;
    }
}

//弹框
-(void)inputText
{
    __block WithdrawViewController *blockSelf = self;
    __weak typeof(self) weakSelf=self;

    self.zctView = [ZCTradeView tradeView];
    [self.zctView showInView:self.view];
    self.zctView.delegate = self;
    [self.zctView.responsder becomeFirstResponder];
    self.zctView.finish = ^(NSString *passWord){
        [blockSelf.zctView hidenKeyboard];
        
        NSString *money = [NSString stringWithFormat:@"%.0f",[input.text floatValue]*100];
            
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"withdrawToken"]) {
            [params setObject:[defaults objectForKey:@"withdrawToken"] forKey:@"token"];
        }
        [params setObject:passWord forKey:@"payPwd"];
        [params setObject:money forKey:@"totalFee"];
        [params setObject:[UIDevice utm_content] forKey:@"macAddr"];
        
        //提现接口
        [weakSelf showHUD:@"加载中"];
        [RSHttp payRequestWithURL:@"/pay/withdraw" params:params httpMethod:@"POST" success:^(NSDictionary *data) {
            [weakSelf alertView:@"提现成功"];
            SubmitViewController *submitVC = [[SubmitViewController alloc] init];
            submitVC.title = @"提交";
            weakSelf.salary = [NSString stringWithFormat:@"%0.2f", [self.salary floatValue] - [[params objectForKey:@"totalFee"] floatValue]];
            [weakSelf.navigationController pushViewController:submitVC animated:YES];
            [weakSelf hidHUD];
        } failure:^(NSInteger code, NSString *errmsg) {
            [weakSelf hidHUD];
            if ([errmsg isKindOfClass:[NSString class]]) {
                [weakSelf alertView:errmsg];
            }else{
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"还有%d次输入机会",[errmsg intValue]] delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:@"重试", nil];
                weakSelf.passWordNum--;
                [al show];
            }
        }];
    };
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    UILabel *shiji = (UILabel *)[self.view viewWithTag:200];
    UILabel *shouxu = (UILabel *)[self.view viewWithTag:100];
    float shuru = [input.text floatValue]*100;
    float salary = [self.salary floatValue];
    if (shuru > salary) {
        input.text = @"";
        shiji.text = @"0.00";
        [self alertView:@"提现金额不能大于当前余额"];
    }else{
        if ([input.text floatValue] > 1) {
            if ([input.text intValue] < 100) {
                shouxu.text = @"1";
                shiji.text = [NSString stringWithFormat:@"%.2f",[input.text floatValue] - 1.00];
            }else{
                shouxu.text = @"0";
                shiji.text = [NSString stringWithFormat:@"%.2f",[input.text floatValue]];
            }
        }
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    UILabel *shiji = (UILabel *)[self.view viewWithTag:200];
    UILabel *shouxu = (UILabel *)[self.view viewWithTag:100];
    float shuru = [input.text floatValue]*100;
    float salary = [self.salary floatValue];
    if (shuru > salary) {
        input.text = @"";
        shiji.text = @"0.00";
        [self alertView:@"提现金额不能大于当前余额"];
        
    }else{
        
        if ([input.text floatValue] > 1) {
            if ([input.text intValue] < 100) {
                shouxu.text = @"1";
                shiji.text = [NSString stringWithFormat:@"%.2f",[input.text floatValue] - 1.00];
            }else{
                shouxu.text = @"0";
                shiji.text = [NSString stringWithFormat:@"%.2f",[input.text floatValue]];
            }
        }
    }
    //个别手机的提现密码会输入到这个里面
    [input resignFirstResponder];
    [textField resignFirstResponder];
    return YES;
}

-(void)settingPwdView
{
    bgBlackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
    bgBlackView.backgroundColor = MakeColor(83, 83, 83);
    bgBlackView.alpha = 0.4;
    bgBlackView.tag = 10000;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cencel)];
    tap.numberOfTapsRequired = 1;
    [bgBlackView addGestureRecognizer:tap];
    [self.view addSubview:bgBlackView];
    
    UIView *whiteView = [[UIView alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-100, kUIScreenHeigth/2-70, 200, 140)];
    [self.view addSubview:whiteView];
    whiteView.tag = 20000;
    whiteView.layer.cornerRadius = 10;
    whiteView.layer.masksToBounds = YES;
    whiteView.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 160, 30)];
    title.text = @"请输入交易密码";
    title.textAlignment = NSTextAlignmentCenter;
    title.textColor = color102;
    title.font = textFont16;
    [whiteView addSubview:title];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 43, 200, 1)];
    line.backgroundColor = color232;
    [whiteView addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(whiteView.frame.size.width/2-80,whiteView.frame.size.height/2-20, 160, 40)];
    label.text = @"请先设置交易密码";
    label.textColor = color155;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = textFont15;
    [whiteView addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(whiteView.frame.size.width/2-50, label.frame.size.height+label.frame.origin.y+7, 100, 30);
    [btn setTitle:@"去设置" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(settingPwdViewVC) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:colorblue];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [whiteView addSubview:btn];
    
}

-(void)settingPwdViewVC
{
    DoPassWordViewController *passWordVC = [[DoPassWordViewController alloc] init];
    passWordVC.telNum = self.telNum;
    [self.navigationController pushViewController:passWordVC animated:YES];
}

-(void)cencel
{
    [[self.view viewWithTag:10000] removeFromSuperview];
    [[self.view viewWithTag:20000] removeFromSuperview];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[self.view viewWithTag:10000] removeFromSuperview];
    [[self.view viewWithTag:20000] removeFromSuperview];
    [super viewWillDisappear:animated];
}




@end
