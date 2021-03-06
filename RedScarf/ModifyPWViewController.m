//
//  ModifyPWViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/19.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "ModifyPWViewController.h"
#import "LoginViewController.h"

@interface ModifyPWViewController ()

@end

@implementation ModifyPWViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = self.titleString;
    if ([self.titleString isEqualToString:@"查看身份证"]) {
        [self initId];
    }
    if ([self.titleString isEqualToString:@"查看学生证"]) {
        [self initId];
    }
    if ([self.titleString isEqualToString:@"修改密码"]) {
        [self initModifyPW];
    }
    [self navigationBar];
}
-(void)navigationBar
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comeback"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
//    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    
    //隐藏tabbar上的按钮
    UIButton *barBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [barBtn removeFromSuperview];
}
-(void)initStudentId
{

}

-(void)initId
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 74, kUIScreenWidth-40, 40)];
    
    [self.view addSubview:label];
    UILabel *idLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 114, kUIScreenWidth-40, 40)];
    idLabel.textAlignment = NSTextAlignmentCenter;
    idLabel.backgroundColor = [UIColor whiteColor];
    idLabel.textColor = MakeColor(128, 128, 128);
    idLabel.layer.borderColor = MakeColor(128, 128, 128).CGColor;
    idLabel.layer.borderWidth = 1.0;
    idLabel.layer.cornerRadius = 3;
    idLabel.layer.masksToBounds = YES;
    idLabel.text = self.idString;
    [self.view addSubview:idLabel];
    
    UIImageView *idImageView = [[UIImageView alloc] initWithFrame:CGRectMake(35, 128, 20, 15)];
    idImageView.image = [UIImage imageNamed:@"shenfen"];
    [self.view addSubview:idImageView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(65, 123, 1, 23)];
    line.backgroundColor = MakeColor(128, 128, 128);
    [self.view addSubview:line];
    
    UILabel *imglabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 160, kUIScreenWidth-40, 40)];
    if ([self.titleString isEqualToString:@"查看身份证"]) {
        label.text = @"身份证:";
        imglabel.text = @"身份证照片:";
    }else{
        label.text = @"学生证:";
        imglabel.text = @"学生证照片:";
    }
    
    [self.view addSubview:imglabel];
    
    for (int i = 0; i < 2; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((kUIScreenWidth-60)/2*i+(i+1)*20, 210, (kUIScreenWidth-60)/2, 90)];
        UIImage *placeholder = [UIImage imageNamed:@"upload"];
        
        if ([self.titleString isEqualToString:@"查看身份证"]) {
            if (i == 0) {
                [img sd_setImageWithURL:[NSURL URLWithString:self.idUrl1] placeholderImage:placeholder];
            }
            if (i == 1) {
                [img sd_setImageWithURL:[NSURL URLWithString:self.idUrl2] placeholderImage:placeholder];
            }
        }else{
            if (i == 0) {
                [img sd_setImageWithURL:[NSURL URLWithString:self.studentUrl1] placeholderImage:placeholder];
            }
            if (i == 1) {
                [img sd_setImageWithURL:[NSURL URLWithString:self.studentUrl2] placeholderImage:placeholder];
            }

        }
        
        [self.view addSubview:img];
    }
}

-(void)initModifyPW
{
    for (int i = 0; i < 3; i++) {
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(25,(45*i+(i+1)*10), kUIScreenWidth-50, 45)];
        tf.layer.borderColor = MakeColor(224, 224, 224).CGColor;
        tf.backgroundColor = [UIColor whiteColor];
        tf.delegate = self;
        tf.layer.cornerRadius = 4;
        tf.layer.masksToBounds = YES;
        tf.layer.borderWidth = 0.8;
        tf.secureTextEntry = YES;
        if (i == 0) {
            tf.placeholder = @"   输入原密码";
            tf.tag = 100;
        }
        if (i == 1) {
            tf.placeholder = @"  输入新密码";
            tf.tag = 101;
        }
        if (i == 2) {
            tf.placeholder = @"  确认新密码";
            tf.tag = 102;
        }
        [self.view addSubview:tf];
    }
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(25, 181, kUIScreenWidth-50, 45);
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:colorblue];
    btn.titleLabel.textColor = [UIColor whiteColor];
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = 6;
    [self.view addSubview:btn];

}

-(void)save
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    UITextField *old = (UITextField *)[self.view viewWithTag:100];
    UITextField *new = (UITextField *)[self.view viewWithTag:101];
    UITextField *reNew = (UITextField *)[self.view viewWithTag:102];
    
    app.tocken = [UIUtils replaceAdd:app.tocken];
     NSString *oldStr = [UIUtils getSha1String:old.text];
     NSString *newStr = [UIUtils getSha1String:new.text];
     NSString *reNewStr = [UIUtils getSha1String:reNew.text];
    [params setObject:oldStr forKey:@"oldPwd"];
    [params setObject:newStr forKey:@"newPwd"];
    [params setObject:reNewStr forKey:@"reNewPwd"];
   
    [RSHttp requestWithURL:@"/user/loginPwd" params:params httpMethod:@"PUT" success:^(NSDictionary *data) {
        [self alertView:@"修改成功"];
        LoginViewController *login = [[LoginViewController alloc] init];
        [app setRootViewController:login];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
    }];
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

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view endEditing:YES];
}

@end
