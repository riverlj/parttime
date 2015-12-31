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

@interface WithdrawViewController ()<ZCTradeViewDelegate,UIAlertViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong)ZCTradeView *zctView;
@property (nonatomic,copy)NSString *str;
@property (nonatomic,copy)NSString *cardId;
@property (nonatomic,assign) int passWordNum;

@end

@implementation WithdrawViewController
{
    UITextField *input;
    UIView *bgBlackView;
    UIView *promptView;
//    __block int passWordNum;
    BOOL moreTimesOrNo;
    NSString *cardNum;
//    __block NSString *cardId;
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
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self comeBack:nil];
    self.title = @"提现";
    moreTimesOrNo = NO;
    self.passWordNum = 4;
    self.view.backgroundColor = color242;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"提现纪录" style:UIBarButtonItemStylePlain target:self action:@selector(didClickTianXianJILu)];
    self.navigationItem.rightBarButtonItem = right;
    [self getCardMsg];
}

//获取银行卡信息
-(void)getCardMsg
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [self showHUD:@"正在加载"];

    [RSHttp payRequestWithURL:@"/account/queryBankCard" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSArray *arr = [data objectForKey:@"body"];
        if (arr.count) {
            cardNum = [NSString stringWithFormat:@"%@",[[[data objectForKey:@"body"] objectAtIndex:0] objectForKey:@"cardNum"]];
            self.cardId = [NSString stringWithFormat:@"%@",[[[data objectForKey:@"body"] objectAtIndex:0] objectForKey:@"id"]];
        }
        [self initView];
        [self hidHUD];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self alertView:errmsg];
    }];
}

-(void)initView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(18, 82, kUIScreenWidth-36, 62)];
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.borderColor = color232.CGColor;
    bgView.layer.borderWidth = 1.0;
    bgView.layer.cornerRadius = 8;
    bgView.layer.masksToBounds = YES;
    [self.view addSubview:bgView];
    
    UILabel *showLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2-40, 5, 80, 26)];
    showLabel.text = @"可提现金额";
    showLabel.textAlignment = NSTextAlignmentCenter;
    showLabel.font = textFont14;
    [bgView addSubview:showLabel];
    
    UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(bgView.frame.size.width/2-40, 25, 80, 31)];
    moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",[self.salary floatValue]/100];
    moneyLabel.textColor = colorgreen65;
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = textFont14;
    [bgView addSubview:moneyLabel];
    
    for (int i = 0; i < 4; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, (bgView.frame.size.height+bgView.frame.origin.y+18)+(i*50), kUIScreenWidth, 50)];
        view.backgroundColor = [UIColor whiteColor];
        view.tag = 999999;
        [self.view addSubview:view];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 50)];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = textFont15;
        label.textColor = color102;
        [view addSubview:label];
        
        if (i == 0) {
            view.frame = CGRectMake(0, bgView.frame.size.height+bgView.frame.origin.y+18, 100, 50);
            label.text = @"    提现金额：";
            
            input = [[UITextField alloc] initWithFrame:CGRectMake(view.frame.size.width+view.frame.origin.x, bgView.frame.size.height+bgView.frame.origin.y+18, kUIScreenWidth-100, 50)];
            input.delegate = self;
            input.placeholder = @"请输入提现金额";
            input.textColor = color102;
            input.font = textFont15;
            input.backgroundColor = [UIColor whiteColor];
            input.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
            [self.view addSubview:input];
        }
        if (i == 1) {
            view.frame = CGRectMake(0, bgView.frame.size.height+bgView.frame.origin.y+18+(i*50), 75, 50);
            label.text = @"    手续费：";
            
            UILabel *money = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width+view.frame.origin.x, bgView.frame.size.height+bgView.frame.origin.y+18+(i*50), 15, 50)];
            money.text = @"0";
            money.textAlignment = NSTextAlignmentCenter;
            money.font = textFont15;
            money.textColor = colorrede5;
            money.tag = 100;
            [self.view addSubview:money];
            
            UILabel *plainLabel = [[UILabel alloc] initWithFrame:CGRectMake(money.frame.size.width+money.frame.origin.x, bgView.frame.size.height+bgView.frame.origin.y+18+(i*50), kUIScreenWidth-120, 50)];
            plainLabel.text = @"元 (金额少于100元，手续费1元)";
            plainLabel.textColor = color102;
            plainLabel.numberOfLines = 0;
            plainLabel.backgroundColor = [UIColor whiteColor];
            plainLabel.font = textFont14;
            [self.view addSubview:plainLabel];
        }
        if (i == 2) {
            label.text = [NSString stringWithFormat:@"    银行卡：%@",cardNum];
            label.userInteractionEnabled = YES;
            label.backgroundColor = [UIColor whiteColor];
            UIButton *btn = [[UIButton alloc] initWithFrame:view.bounds];
            [btn setBackgroundColor:[UIColor clearColor]];
            [btn addTarget:self action:@selector(selectBank) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:btn];
            
            UIImageView *showImage = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth-30, 20, 10, 15)];
            showImage.image = [UIImage imageNamed:@"you2x"];
            [view addSubview:showImage];
        }
        if (i == 3) {
            view.frame = CGRectMake(0, bgView.frame.size.height+bgView.frame.origin.y+18+(i*50), 105, 50);
            label.text = @"    实际提现金额：";
            UILabel *moneyLabel = [[UILabel alloc] initWithFrame:CGRectMake(view.frame.size.width+view.frame.origin.x+10, bgView.frame.size.height+bgView.frame.origin.y+18+(i*50), 60, 50)];
            moneyLabel.textAlignment = NSTextAlignmentCenter;
            moneyLabel.textColor = colorgreen65;
            moneyLabel.tag = 200;
            moneyLabel.font = textFont15;
            moneyLabel.text = @"0.00";
            [self.view addSubview:moneyLabel];
            
            UILabel *yuan = [[UILabel alloc] initWithFrame:CGRectMake(moneyLabel.frame.size.width+moneyLabel.frame.origin.x, bgView.frame.size.height+bgView.frame.origin.y+18+(i*50), 15, 50)];
            yuan.textColor = color102;
            yuan.text = @"元";
            yuan.font = textFont15;
            [self.view addSubview:yuan];

            
        }
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, (bgView.frame.size.height+bgView.frame.origin.y+18)+(i*50), kUIScreenWidth, 0.5)];
        lineView.backgroundColor = color232;
        [self.view addSubview:lineView];
    }
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveBtn.frame = CGRectMake(kUIScreenWidth/2-100, 400, 200, 40);
    [saveBtn setBackgroundColor:colorblue];
    [saveBtn setTitle:@"确认" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    saveBtn.layer.cornerRadius = 6;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn addTarget:self action:@selector(clickSaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    
}

-(void)selectBank
{
    BankCardsViewController *bankcards = [[BankCardsViewController alloc] init];
    [self.navigationController pushViewController:bankcards animated:YES];
}

-(void)didClickTianXianJILu
{
    TransactionViewController *transactionVC = [[TransactionViewController alloc] init];
    transactionVC.title = @"提现纪录";
    [self.navigationController pushViewController:transactionVC animated:YES];
}

-(void)clickSaveBtn
{
    UILabel *shiji = (UILabel *)[self.view viewWithTag:200];
    UILabel *shouxu = (UILabel *)[self.view viewWithTag:100];
    
    if ([self.pwdStatus isEqualToString:@"0"]) {
        [self settingPwdView];
    }else {
        if (!input.text.length) {
            [self alertView:@"提现金额不能为空"];
            return;
        }
        if ([input.text floatValue] <= 1) {
            [self alertView:@"提现金额不能小于1元"];
            return;
        }
        [input resignFirstResponder];
        NSString *shijiStr = [shiji.text stringByReplacingOccurrencesOfString:@"    实际提现金额：" withString:@""];
        NSString *shouxuStr = [shouxu.text stringByReplacingOccurrencesOfString:@"    手续费：" withString:@""];
        
        NSString *str = [NSString stringWithFormat:@"确认提现%@元？含实际提现%@元，手续费%@元",input.text,shijiStr,shouxuStr];
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
    //判断是否有银行卡信息，若无则跳转至银行卡的页面
    if(!self.cardId) {
        [self selectBank];
        return;
    }
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
        [params setObject:weakSelf.cardId forKey:@"bankCardId"];
        if ([defaults objectForKey:@"uuid"]) {
            [params setObject:[defaults objectForKey:@"uuid"] forKey:@"macAddr"];
        }
        //提现接口
        [RSHttp payRequestWithURL:@"/pay/withdraw" params:params httpMethod:@"POST" success:^(NSDictionary *data) {
            [weakSelf alertView:@"提现成功"];
            SubmitViewController *submitVC = [[SubmitViewController alloc] init];
            submitVC.title = @"提交";
            [weakSelf.navigationController pushViewController:submitVC animated:YES];
        } failure:^(NSInteger code, NSString *errmsg) {
            if ([[NSString stringWithFormat:@"%@",errmsg] isEqualToString:@"该账户已被锁定"] || [[NSString stringWithFormat:@"%@",errmsg] isEqualToString:@"4"]) {
                [weakSelf alertView:@"该账户已被锁定"];
            }else if([[NSString stringWithFormat:@"%@",errmsg] isEqualToString:@"余额不足"]){
                [weakSelf alertView:@"余额不足"];
            }else{
                UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"还有%d次输入机会",4-[errmsg intValue]] delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:@"重试", nil];
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

//判断日期是今天，昨天还是明天
-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"今天";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"昨天";
    }else if ([dateString isEqualToString:tomorrowString])
    {
        return @"明天";
    }
    else
    {
        return dateString;
    }
}

@end
