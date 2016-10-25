//
//  LoginViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "Header.h"
#import "RSHttp.h"
#import "UIUtils.h"
#import "ForgetPassViewController.h"
#import "RSAccountModel.h"


@interface LoginViewController ()

@end

@implementation LoginViewController
{
    UITextField *nameField;
    UITextField *passField;
    BaseTabbarViewController *baseTabVC;
    UIScrollView *scrolView;
    UIImageView *logoView;
}

-(void)editing:(UITextField *)textField
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^ {
                         scrolView.contentInset = UIEdgeInsetsMake(-(textField.bottom -200), 0.0f, 0.0f, 0.0f);
                     }
                     completion:^(BOOL finished) {
                     }];
}
-(void) hideKeyboard
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^ {
                         scrolView.contentInset = UIEdgeInsetsMake(0, 0.0f, 0.0f, 0.0f);
                     }
                     completion:^(BOOL finished) {
                     }];
    [nameField resignFirstResponder];
    [passField resignFirstResponder];
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RSAccountModel *model = [RSAccountModel sharedAccount];
    if(model.mobile) {
        nameField.text = model.mobile;
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = MakeColor(244, 244, 244);
    [self initView];
    [nameField becomeFirstResponder];
}

-(void)initView
{
    scrolView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    [scrolView addTapAction:@selector(hideKeyboard) target:self];
    [self.view addSubview:scrolView];
    
    if (kUIScreenHeigth == 480) {
        logoView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 38, self.view.frame.size.width-120, self.view.frame.size.width-120)];

    }else{
        logoView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 78, self.view.frame.size.width-120, self.view.frame.size.width-120)];

    }
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.image = [UIImage imageNamed:@"logo"];
    [scrolView addSubview:logoView];
    
    UIImageView *leftImage;
    nameField = [[UITextField alloc] initWithFrame:CGRectMake(58, logoView.bottom+20, scrolView.width-116, 45)];
    leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(0,11, 64, nameField.height-22)];
    nameField.layer.borderColor = MakeColor(214, 214, 214).CGColor;
    nameField.layer.borderWidth = 1.0;
    nameField.layer.cornerRadius = 4;
    nameField.layer.masksToBounds = YES;
    nameField.keyboardType = UIKeyboardTypePhonePad;
    nameField.placeholder = @"请输入手机号";
    nameField.delegate = self;
    nameField.leftViewMode = UITextFieldViewModeAlways;
    nameField.clearButtonMode = UITextFieldViewModeWhileEditing;
    leftImage.image = [UIImage imageNamed:@"账户"];
    nameField.leftView = leftImage;
    leftImage.contentMode =  UIViewContentModeCenter;
    [scrolView addSubview:nameField];
    
    UIImageView *left;
    passField = [[UITextField alloc] initWithFrame:CGRectMake(nameField.left, nameField.bottom+10, nameField.width, nameField.height)];
    left = [[UIImageView alloc] initWithFrame:CGRectMake(0,11, 64, passField.height-22)];
    passField.layer.borderColor = MakeColor(214, 214, 214).CGColor;
    passField.layer.borderWidth = 1.0;
    passField.layer.cornerRadius = 4;
    passField.delegate = self;
    passField.layer.masksToBounds = YES;
    passField.secureTextEntry = YES;
    passField.clearButtonMode = UITextFieldViewModeWhileEditing;
    passField.placeholder = @"请输入密码";
    passField.leftView = left;
    passField.leftViewMode = UITextFieldViewModeAlways;
    left.image = [UIImage imageNamed:@"密码"];
    left.contentMode =  UIViewContentModeCenter;
    //[passField addSubview:left];
    [scrolView addSubview:passField];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (kUIScreenHeigth == 480) {
        loginBtn.frame = CGRectMake(58, passField.frame.origin.y+passField.frame.size.height+15, self.view.frame.size.width-116, 45);
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:16];

    }else{
        loginBtn.frame = CGRectMake(58, passField.frame.origin.y+passField.frame.size.height+20, self.view.frame.size.width-116, 50);
        loginBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    }
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:MakeColor(32, 102, 208)];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 4;
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(didClickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [scrolView addSubview:loginBtn];
    
    //忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [forgetBtn setTitleColor:MakeColor(32, 102, 208) forState:UIControlStateNormal];
    forgetBtn.frame = CGRectMake(loginBtn.frame.origin.x+loginBtn.frame.size.width/2-35, loginBtn.frame.size.height+loginBtn.frame.origin.y+7, 70, 30);
    [scrolView addSubview:forgetBtn];
    [forgetBtn addTarget:self action:@selector(ForgetPassWord) forControlEvents:UIControlEventTouchUpInside];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"忘记密码?"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [forgetBtn setAttributedTitle:str forState:UIControlStateNormal];
}

-(void)didClickLoginBtn
{
    if (nameField.text.length == 0) {
        [self alertView:@"用户名不能为空"];
        [nameField becomeFirstResponder];
        return;
    }
    if (nameField.text.length != 11) {
        [self alertView:@"用户名输入不正确"];
        [nameField becomeFirstResponder];
        return;
    }
    if (passField.text.length == 0) {
        [self alertView:@"密码不能为空"];
        return;
    }
    BOOL phoneNum = [UIUtils checkPhoneNumInput:nameField.text];
    if (!phoneNum) {
        [self alertView:@"输入的手机号有误"];
        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:nameField.text forKey:@"mobile"];
    
    NSString *str = [UIUtils getSha1String:passField.text];
    [self showHUD:@"正在登录"];
    [dic setObject:str forKey:@"password"];
    __weak __typeof(&*self)weakSelf = self;
    [RSHttp requestWithURL:@"/auth" params:dic httpMethod:@"POST" success:^(NSDictionary *data) {
        [weakSelf hidHUD];
        //重新获取配置信息
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        app.tocken = [data objectForKey:@"body"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:app.tocken forKey:@"token"];
        [defaults synchronize];
        baseTabVC = [[BaseTabbarViewController alloc] init];
        [app setRootViewController:baseTabVC];
        [AppSettingModel getAppSetting];
    } failure:^(NSInteger code, NSString *errmsg) {
        [weakSelf hidHUD];
        [weakSelf alertView:errmsg];
    }];
}


-(void)ForgetPassWord
{
    ForgetPassViewController *forgetPassVC = [[ForgetPassViewController alloc] init];
    [self presentViewController:forgetPassVC animated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField == nameField) {
        [textField resignFirstResponder];
        [passField becomeFirstResponder];
    } else {
        [self didClickLoginBtn];
    }
    return YES;
}

-(void)alertView:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    return;
}

#pragma mark 开始时提高界面高度实现不遮挡效果
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self editing:textField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == nameField) {
        if([textField.text length] >= 11 && ![string isEqualToString:@""]) {
            [passField becomeFirstResponder];
        }
    }
    
    return YES;
}
@end
