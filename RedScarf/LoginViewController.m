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
#import "RedScarf_API.h"
#import "UIUtils.h"
#import "Flurry.h"
#import "ForgetPassViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController
{
    UITextField *nameField;
    UITextField *passField;
    BaseTabbarViewController *baseTabVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = MakeColor(244, 244, 244);
    [Flurry logEvent:@"login_count"];
    [self initView];
    
    
}

-(void)initView
{
    UIImageView *logoView;
    if (kUIScreenHeigth == 480) {
        logoView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 38, self.view.frame.size.width-120, self.view.frame.size.width-120)];

    }else{
        logoView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 78, self.view.frame.size.width-120, self.view.frame.size.width-120)];

    }
    logoView.contentMode = UIViewContentModeScaleAspectFit;
    logoView.image = [UIImage imageNamed:@"logo"];
    [self.view addSubview:logoView];
    
    UIImageView *leftImage;
    if (kUIScreenHeigth == 480) {
        nameField = [[UITextField alloc] initWithFrame:CGRectMake(58, logoView.frame.origin.y+logoView.frame.size.height+20, self.view.frame.size.width-116, 45)];
        leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(20,12, 20, nameField.frame.size.height-22)];

    }else{
        nameField = [[UITextField alloc] initWithFrame:CGRectMake(58, logoView.frame.origin.y+logoView.frame.size.height+25, self.view.frame.size.width-116, 50)];
        leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(20,11, 26, nameField.frame.size.height-22)];

    }
    nameField.layer.borderColor = MakeColor(214, 214, 214).CGColor;
    nameField.layer.borderWidth = 1.0;
    nameField.layer.cornerRadius = 4;
    nameField.layer.masksToBounds = YES;
    nameField.placeholder = @"请输入手机号";
    nameField.delegate = self;
    nameField.textAlignment = NSTextAlignmentCenter;
    leftImage.image = [UIImage imageNamed:@"账户"];
    [nameField addSubview:leftImage];
    [self.view addSubview:nameField];
    
    UIImageView *left;
    if (kUIScreenHeigth == 480) {
        passField = [[UITextField alloc] initWithFrame:CGRectMake(58, nameField.frame.origin.y+nameField.frame.size.height+10, self.view.frame.size.width-116, 45)];
        left = [[UIImageView alloc] initWithFrame:CGRectMake(20,12, 18, passField.frame.size.height-22)];

    }else{
        passField = [[UITextField alloc] initWithFrame:CGRectMake(58, nameField.frame.origin.y+nameField.frame.size.height+15, self.view.frame.size.width-116, 50)];
        left = [[UIImageView alloc] initWithFrame:CGRectMake(20,11, 24, passField.frame.size.height-22)];

    }
    passField.layer.borderColor = MakeColor(214, 214, 214).CGColor;
    passField.layer.borderWidth = 1.0;
    passField.layer.cornerRadius = 4;
    passField.delegate = self;
    passField.layer.masksToBounds = YES;
    passField.secureTextEntry = YES;
    passField.placeholder = @"请输入密码";
    passField.textAlignment = NSTextAlignmentCenter;
    left.image = [UIImage imageNamed:@"密码"];
    [passField addSubview:left];
    [self.view addSubview:passField];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    if (kUIScreenHeigth == 480) {
        loginBtn.frame = CGRectMake(58, passField.frame.origin.y+passField.frame.size.height+15, self.view.frame.size.width-116, 45);
        loginBtn.font = [UIFont systemFontOfSize:16];

    }else{
        loginBtn.frame = CGRectMake(58, passField.frame.origin.y+passField.frame.size.height+20, self.view.frame.size.width-116, 50);
        loginBtn.font = [UIFont systemFontOfSize:18];

    }
    [loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [loginBtn setBackgroundColor:MakeColor(32, 102, 208)];
    loginBtn.layer.masksToBounds = YES;
    loginBtn.layer.cornerRadius = 4;
    [loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginBtn addTarget:self action:@selector(didClickLoginBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
    
    //忘记密码
    UIButton *forgetBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [forgetBtn setTitleColor:MakeColor(32, 102, 208) forState:UIControlStateNormal];
    forgetBtn.frame = CGRectMake(loginBtn.frame.origin.x+loginBtn.frame.size.width/2-35, loginBtn.frame.size.height+loginBtn.frame.origin.y+7, 70, 30);
    [self.view addSubview:forgetBtn];
    [forgetBtn addTarget:self action:@selector(ForgetPassWord) forControlEvents:UIControlEventTouchUpInside];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:@"忘记密码?"];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [forgetBtn setAttributedTitle:str forState:UIControlStateNormal];
}

-(void)didClickLoginBtn:(id)sender
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    NSString *net = [self stringFromStatus:status];
    NSLog(@"net = %@",net);
    if ([net isEqualToString:@"not"]) {
        [self alertView:@"当前没有网络"];
        return;
    }
    
    if (nameField.text.length == 0) {
        [self alertView:@"用户名不能为空"];
        return;
    }
    if (nameField.text.length != 11) {
        [self alertView:@"用户名输入不正确"];
        return;
    }
    if (passField.text.length == 0) {
        [self alertView:@"密码不能为空"];
        return;
    }
    BOOL phoneNum = [UIUtils checkPhoneNumInput:nameField.text];
    if (!phoneNum) {
//        [self alertView:@"输入的手机号有误"];
//        return;
    }
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setObject:nameField.text forKey:@"mobile"];
    
    NSString *str = [UIUtils getSha1String:passField.text];
    [self showHUD:@"正在登陆"];
    [dic setObject:str forKey:@"password"];
    [RedScarf_API requestWithURL:@"/auth" params:dic httpMethod:@"POST" block:^(id result) {
                NSLog(@"result = %@",[result objectForKey:@"msg"]);
        
                if (![[result objectForKey:@"success"] boolValue]) {
                    [self hidHUD];
                    [self alertView:[result objectForKey:@"msg"]];
                }
                if ([[result objectForKey:@"success"] boolValue]) {
                    AppDelegate *app = [UIApplication sharedApplication].delegate;
                    app.tocken = [result objectForKey:@"msg"];
                    NSLog(@"token = %@",app.tocken);
                    
                    app.tocken = [UIUtils replaceAdd:app.tocken];

                    [dic setObject:app.tocken forKey:@"token"];
                [RedScarf_API requestWithURL:@"/resource/appMenu" params:dic httpMethod:@"GET" block:^(id result) {
                    NSLog(@"result = %@   %@",[result objectForKey:@"msg"],result);
                    
                    NSMutableArray *tabCount = [result objectForKey:@"msg"];
                    app.array = tabCount;
                    for (NSDictionary *dic in tabCount) {
                        NSLog(@"dic = %@",dic);
                        app.count = [NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]];
                    }
                    [Flurry logEvent:@"login_count"];

                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:app.tocken forKey:@"token"];
                    [defaults setObject:app.count forKey:@"count"];
                    [defaults synchronize];
                    baseTabVC = [[BaseTabbarViewController alloc] init];
                    [app setRoorViewController:baseTabVC];

                }];
                    
                }
        }];
    
}

-(void)ForgetPassWord
{
    ForgetPassViewController *forgetPassVC = [[ForgetPassViewController alloc] init];
    [self presentViewController:forgetPassVC animated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
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
    CGRect frame = textField.frame;
    
    //键盘高度216
    int offset;
    if (kUIScreenHeigth == 480) {
        offset = frame.origin.y + 19 - (self.view.frame.size.width - 180.0);

    }else{
        offset = frame.origin.y + 19 - (self.view.frame.size.width - 110.0);

    }
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    //将软键盘Y坐标向上移动offset个单位 以使下面显示软键盘显示
    if (offset > 0 )
        self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark 结束时恢复界面高度
//-(void)textFieldDidEndEditing:(UITextField *)textField
//{
//    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
//}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view endEditing:YES];
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
