//
//  DoPassWordViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/30.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "DoPassWordViewController.h"
#import "UIUtils.h"

@interface DoPassWordViewController ()

@end

@implementation DoPassWordViewController
{
    NSArray *imageArray;
    NSArray *titleArray;
    UITextField *passWord;
    UITextField *newPassWord;
    UIButton *codeBtn;
    int num;
    UITextField *codeTextField;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self comeBack:nil];
    num = 60;
    imageArray = [NSArray arrayWithObjects:@"yanzheng",@"shezhi",@"hchenggong", nil];
    titleArray = [NSArray arrayWithObjects:@"输入验证码",@"设置密码",@"设置成功", nil];
    [self initView];
}

-(void)initView
{
    for (int i = 0; i < 3; i++) {
        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake((kUIScreenWidth-132)/4*(i+1)+44*i, 84, 44, 44)];
        [self.view addSubview:image];
        image.image = [UIImage imageNamed:imageArray[i]];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-132)/4*(i+1)+44*i, image.frame.size.height+image.frame.origin.y+5, 50, 20)];
        label.text = titleArray[i];
        label.textColor = colorblue;
        label.font = [UIFont systemFontOfSize:10];
        [self.view addSubview:label];
        
        if (i != 2) {
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(image.frame.size.width+image.frame.origin.x+3, image.frame.size.width/2+image.frame.origin.y, (kUIScreenWidth-132)/4-6, 0.8)];
            line.backgroundColor = colorblue;
            [self.view addSubview:line];
        }
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15,160 , kUIScreenWidth-30, 1.0)];
    lineView.backgroundColor = color232;
    [self.view addSubview:lineView];
    
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView.frame.origin.y+lineView.frame.size.height+7, 250, 40)];
    telLabel.text = [NSString stringWithFormat:@"手机号：%@",self.telNum];
    [self.view addSubview:telLabel];
    
    //验证码
    codeTextField = [[UITextField alloc] initWithFrame:CGRectMake(15, telLabel.frame.size.height+telLabel.frame.origin.y+5, kUIScreenWidth-180, 45)];
    codeTextField.layer.borderColor = color234.CGColor;
    codeTextField.delegate = self;
    codeTextField.layer.borderWidth = 0.5;
    codeTextField.placeholder = @" 验证码";
    codeTextField.layer.cornerRadius = 5;
    codeTextField.layer.masksToBounds = YES;
    codeTextField.backgroundColor = [UIColor whiteColor];
    codeTextField.clearButtonMode = UITextFieldViewModeAlways;
    codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:codeTextField];
    
    codeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    codeBtn.frame = CGRectMake(codeTextField.frame.size.width+codeTextField.frame.origin.x+20, telLabel.frame.size.height+telLabel.frame.origin.y+5, 130, 45);
    [codeBtn setBackgroundColor:colorblue];
    codeBtn.layer.cornerRadius = 5;
    codeBtn.layer.masksToBounds = YES;
    [codeBtn setTitle:@"发送验证码" forState:UIControlStateNormal];
    [codeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [codeBtn addTarget:self action:@selector(didClickCodeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:codeBtn];
    
    passWord = [[UITextField alloc] initWithFrame:CGRectMake(15, codeTextField.frame.size.height+codeTextField.frame.origin.y+15, kUIScreenWidth-30, 45)];
    passWord.layer.borderColor = color234.CGColor;
    passWord.layer.borderWidth = 0.5;
    passWord.placeholder = @" 新密码";
    passWord.secureTextEntry = YES;
    passWord.delegate = self;
    passWord.layer.cornerRadius = 5;
    passWord.layer.masksToBounds = YES;
    passWord.backgroundColor = [UIColor whiteColor];
    passWord.clearButtonMode = UITextFieldViewModeAlways;
    passWord.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:passWord];
    
    newPassWord = [[UITextField alloc] initWithFrame:CGRectMake(15, passWord.frame.size.height+passWord.frame.origin.y+10, kUIScreenWidth-30, 45)];
    newPassWord.placeholder = @" 确认密码";
    newPassWord.delegate = self;
    newPassWord.secureTextEntry = YES;
    newPassWord.layer.borderColor = color234.CGColor;
    newPassWord.layer.borderWidth = 0.5;
    newPassWord.layer.cornerRadius = 5;
    newPassWord.layer.masksToBounds = YES;
    newPassWord.backgroundColor = [UIColor whiteColor];
    newPassWord.clearButtonMode = UITextFieldViewModeAlways;
    newPassWord.keyboardType = UIKeyboardTypeNumberPad;
    [self.view addSubview:newPassWord];
    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveBtn.frame = CGRectMake(kUIScreenWidth/2-50, newPassWord.frame.size.height+newPassWord.frame.origin.y+30, 100, 40);
    [saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    [saveBtn setBackgroundColor:colorblue];
    saveBtn.layer.cornerRadius = 5;
    saveBtn.layer.masksToBounds = YES;
    [saveBtn addTarget:self action:@selector(SaveBtn) forControlEvents:UIControlEventTouchUpInside];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.view addSubview:saveBtn];
    
}

-(void)didClickCodeBtn
{
    if ([codeBtn.titleLabel.text isEqualToString:@"重新获取"]) {
        num = 60;
        
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [self showHUD:@"正在发送"];
        [RSHttp payRequestWithURL:@"/verifyCode/shortMsg" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
            [self alertView:@"发送成功"];
            [self hidHUD];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
        } failure:^(NSInteger code, NSString *errmsg) {
            [self alertView:@"发送失败"];
        }];
        
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [self showHUD:@"正在发送"];
        [RSHttp payRequestWithURL:@"/verifyCode/shortMsg" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
            [self alertView:@"发送成功"];
            [self hidHUD];
            [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
        } failure:^(NSInteger code, NSString *errmsg) {
            [self alertView:@"发送失败"];
        }];
     }
}

-(void)SaveBtn
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if (!codeTextField.text.length) {
        [self alertView:@"请输入手机验证码"];
        return;
    }
    if (passWord.text.length != 6) {
        [self alertView:@"密码必须为6位数字"];
        return;
    }
    
    if (![UIUtils isNumber:passWord.text]) {
        [self alertView:@"密码必须为数字"];
        return;
    }
    if (!passWord.text.length) {
        [self alertView:@"请输入密码"];
        return;
    }
    if (![passWord.text isEqualToString:newPassWord.text]) {
        [self alertView:@"两次输入的密码不一致"];
        return;
    }
    [params setObject:codeTextField.text forKey:@"verifyCode"];
    [params setObject:passWord.text forKey:@"payPwd"];
    if ([defaults objectForKey:@"uuid"]) {
        [params setObject:[defaults objectForKey:@"uuid"] forKey:@"macAddr"];
    }
    [self showHUD:@"正在设置"];
    [RSHttp payRequestWithURL:@"/account/setPayPwd" params:params httpMethod:@"POST" success:^(NSDictionary *data) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:passWord.text forKey:@"passWord"];
        [defaults synchronize];
        [self alertView:[data objectForKey:@"body"]];
        [self.navigationController popViewControllerAnimated:YES];
        [self hidHUD];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
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

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if([string isEqualToString:@""]) {
        return YES;
    }
    NSInteger maxLength = 6;
    if([textField.text length] >= maxLength) {
        return NO;
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == codeTextField) {
        [passWord becomeFirstResponder];
    } else if(textField == passWord) {
        [newPassWord becomeFirstResponder];
    } else if(textField == newPassWord) {
        [self SaveBtn];
    }
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
@end
