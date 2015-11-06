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

@interface WithdrawViewController ()<ZCTradeViewDelegate,UIAlertViewDelegate>

@property (nonatomic,strong)ZCTradeView *zctView;
@property (nonatomic,copy)NSString *str;

@end

@implementation WithdrawViewController
{
    UITextField *input;
    UIView *bgBlackView;
    UIView *promptView;
    __block int passWordNum;
    BOOL moreTimesOrNo;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self comeBack:nil];
    self.title = @"提现";
    moreTimesOrNo = NO;
    passWordNum = 4;
    self.view.backgroundColor = color242;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"提现纪录" style:UIBarButtonItemStylePlain target:self action:@selector(didClickTianXianJILu)];
    right.tintColor = color155;
    self.navigationItem.rightBarButtonItem = right;
    [self initView];
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
    moneyLabel.textColor = [UIColor greenColor];
    moneyLabel.textAlignment = NSTextAlignmentCenter;
    moneyLabel.font = textFont14;
    [bgView addSubview:moneyLabel];
    
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, (bgView.frame.size.height+bgView.frame.origin.y+18)+(i*50), kUIScreenWidth, 50)];
        label.backgroundColor = [UIColor whiteColor];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = textFont15;
        label.textColor = color102;
        [self.view addSubview:label];
        
        if (i == 0) {
            label.frame = CGRectMake(0, bgView.frame.size.height+bgView.frame.origin.y+18, 100, 50);
            label.text = @"    提现金额：";
            
            input = [[UITextField alloc] initWithFrame:CGRectMake(label.frame.size.width+label.frame.origin.x, bgView.frame.size.height+bgView.frame.origin.y+18, kUIScreenWidth-100, 50)];
            input.delegate = self;
//            input.keyboardType = UIKeyboardTypeNumberPad;
            input.placeholder = @"请输入提现金额";
            input.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:input];
        }
        if (i == 1) {
            label.frame = CGRectMake(0, bgView.frame.size.height+bgView.frame.origin.y+18+(i*50), 120, 50);
            label.text = @"    手续费：0元";
            label.tag = 100;
            UILabel *plainLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.size.width+label.frame.origin.x, bgView.frame.size.height+bgView.frame.origin.y+18+(i*50), kUIScreenWidth-120, 50)];
            plainLabel.text = @"(提现金额少于100元，手续费1元)";
            plainLabel.textColor = color102;
            plainLabel.backgroundColor = [UIColor whiteColor];
            plainLabel.font = textFont12;
            [self.view addSubview:plainLabel];
        }
        if (i == 2) {
            label.text = @"    银行卡：6666666666666";
        }
        if (i == 3) {
            label.tag = 200;
            label.text = @"    实际提现金额：0元";
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
        
        NSString *shijiStr = [shiji.text stringByReplacingOccurrencesOfString:@"    实际提现金额：" withString:@""];
        NSString *shouxuStr = [shouxu.text stringByReplacingOccurrencesOfString:@"    手续费：" withString:@""];
        
        NSString *str = [NSString stringWithFormat:@"确认提现%@元？含实际体现%@，手续费%@",input.text,shijiStr,shouxuStr];
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
    self.zctView = [ZCTradeView tradeView];
    
    [self.zctView showInView:self.view.window];
    self.zctView.delegate = self;
    self.zctView.finish = ^(NSString *passWord){
        
        NSLog(@"  passWord %@ ",passWord);
        
        [blockSelf.zctView hidenKeyboard];
        
            NSString *money = [NSString stringWithFormat:@"%d",[input.text intValue]*100];
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [params setObject:@"1e6c0701241557fa375f9054ade19260742b22e718d84db1" forKey:@"token"];
            [params setObject:passWord forKey:@"payPwd"];
            [params setObject:money forKey:@"totalFee"];
            [params setObject:@"2" forKey:@"bankCardId"];
            if ([defaults objectForKey:@"uuid"]) {
                [params setObject:[defaults objectForKey:@"uuid"] forKey:@"macAddr"];
            }
            //提现接口
            NSLog(@"resultParams = %@",params);
            [RedScarf_API zhangbRequestWithURL:@"https://paytest.honglingjinclub.com/pay/withdraw" params:params httpMethod:@"GET" block:^(id result) {
                NSLog(@"result = %@",result);
                if (result &&![[result objectForKey:@"code"] boolValue]) {
                    [self alertView:@"提现成功"];
                    SubmitViewController *submitVC = [[SubmitViewController alloc] init];
                    submitVC.title = @"提交";
                    [self.navigationController pushViewController:submitVC animated:YES];
                    return ;
                }else{
                    if ([[NSString stringWithFormat:@"%@",[result objectForKey:@"body"]] isEqualToString:@"该账户已被锁定"] || [[NSString stringWithFormat:@"%@",[result objectForKey:@"body"]] isEqualToString:@"4"]) {
                        [self alertView:@"该账户已被锁定"];
                    }else if([[NSString stringWithFormat:@"%@",[result objectForKey:@"body"]] isEqualToString:@"余额不足"]){
                        [self alertView:@"余额不足"];
                    }else{
//                        [self alertView:[NSString stringWithFormat:@"还有%d次输入机会",4-[[result objectForKey:@"body"] intValue]]];
                        UIAlertView *al = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"还有%d次输入机会",4-[[result objectForKey:@"body"] intValue]] delegate:blockSelf cancelButtonTitle:@"确定" otherButtonTitles:@"重试", nil];
                        passWordNum--;
                        [al show];
                    }
                    
                }
                
            }];
            
    };
}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    UILabel *shiji = (UILabel *)[self.view viewWithTag:200];
    UILabel *shouxu = (UILabel *)[self.view viewWithTag:100];
    if ([input.text intValue] < 100) {
        shouxu.text = @"    手续费：1元";
        shiji.text = [NSString stringWithFormat:@"    实际提现金额：%d元",[input.text intValue] - 1];
    }else{
        shouxu.text = @"    手续费：0元";
        shiji.text = [NSString stringWithFormat:@"    实际提现金额：%@元",input.text];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
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
    [btn setBackgroundColor:colorblue];
    btn.layer.cornerRadius = 5;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [whiteView addSubview:btn];
    
}

-(void)cencel
{
    [[self.view viewWithTag:10000] removeFromSuperview];
    [[self.view viewWithTag:20000] removeFromSuperview];
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
