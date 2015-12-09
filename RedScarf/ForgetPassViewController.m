//
//  ForgetPassViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/19.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "ForgetPassViewController.h"

@interface ForgetPassViewController ()

@end

@implementation ForgetPassViewController
{
    UIButton *codeBtn;
    int num;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = color242;
    num = 60;
    [self initView];
    
}

-(void)initView
{
    UIView *barView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 64)];
    [self.view addSubview:barView];
    barView.backgroundColor = MakeColor(246, 251, 255);
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-40, 10, 80, 54)];
    title.text = @"忘记密码";
    title.font = textFont16;
    [barView addSubview:title];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 0.5)];
    [self.view addSubview:line];
    line.backgroundColor = color155;
    
    UIButton *back = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    back.frame = CGRectMake(10, 20, 30, 40);
    [back setImage:[[UIImage imageNamed:@"newfanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [back addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    [barView addSubview:back];
    
    for (int i = 0; i < 4; i++) {
        UITextField *TXT = [[UITextField alloc] initWithFrame:CGRectMake(18, 85+i*60, kUIScreenWidth-30, 45)];
        TXT.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:TXT];
        TXT.layer.cornerRadius = 3;
        TXT.layer.masksToBounds = YES;
        TXT.layer.borderColor = color234.CGColor;
        TXT.layer.borderWidth = 0.5;
        TXT.tag = 1000+i;
        if (i == 0) {
            TXT.placeholder = @"  手机号";
        }
        if (i == 1) {
            TXT.placeholder = @"  验证码";
            TXT.frame = CGRectMake(18, 85+i*60, kUIScreenWidth-150, 45);
            
            codeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            codeBtn.frame = CGRectMake(TXT.frame.size.width+TXT.frame.origin.x+20, 145, 102, 45);
            [codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
            [codeBtn addTarget:self action:@selector(code) forControlEvents:UIControlEventTouchUpInside];
            [codeBtn setBackgroundColor:colorblue];
            codeBtn.layer.cornerRadius = 3;
            codeBtn.layer.masksToBounds = YES;
            [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [self.view addSubview:codeBtn];
        }
        if (i == 2) {
            TXT.placeholder = @"  新密码";
        }
        if (i == 3) {
            TXT.placeholder = @"  确认密码";
        }
    }
    
    UIButton *doBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    doBtn.frame = CGRectMake(kUIScreenWidth/2-80, 340, 160, 45);
    doBtn.layer.cornerRadius = 5;
    doBtn.layer.masksToBounds = YES;
    [doBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [doBtn setTitle:@"确认修改" forState:UIControlStateNormal];
    [doBtn setBackgroundColor:colorblue];
    [doBtn addTarget:self action:@selector(makeSure) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:doBtn];
}
//发送验证码
-(void)code
{
    num = 60;
    UITextField *tf = (UITextField *)[self.view viewWithTag:1000];
        
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:tf.text forKey:@"mobile"];
    [RSHttp requestWithURL:@"/user/validCode"
                    params:params
                httpMethod:@"GET"
                   success:^(NSDictionary *data) {
                           [NSTimer scheduledTimerWithTimeInterval:1
                                                            target:self
                                                          selector:@selector(timer)
                                                          userInfo:nil
                                                           repeats:YES];
                   }
                   failure:^(NSInteger code, NSString *errmsg) {
                           [self alertView:errmsg];
                }];
}
//确认
-(void)makeSure
{
    UITextField *tf = (UITextField *)[self.view viewWithTag:1000];
    UITextField *tf1 = (UITextField *)[self.view viewWithTag:1001];
    UITextField *tf2 = (UITextField *)[self.view viewWithTag:1002];
    UITextField *tf3 = (UITextField *)[self.view viewWithTag:1003];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:tf.text forKey:@"mobilePhone"];
    [params setObject:tf1.text forKey:@"validCode"];
    [params setObject:tf2.text forKey:@"newPwd"];
    [params setObject:tf3.text forKey:@"reNewPwd"];
    [RSHttp requestWithURL:@"/user/password" params:params httpMethod:@"PUT" success:^(NSDictionary *data) {
        [self alertView:@"修改成功"];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
    }];
}

-(void)timer
{
    if (num == 0) {
        [codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
        
    }else{
        num--;
        [codeBtn setTitle:[NSString stringWithFormat:@"%d秒",num] forState:UIControlStateNormal];
    }
    
}

-(void)back
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
