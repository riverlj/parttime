//
//  AddressViewVontroller.m
//  RedScarf
//
//  Created by zhangb on 15/8/8.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "AddressViewVontroller.h"
#import "Header.h"
#import "SelectSchoolVC.h"
#import "AppDelegate.h"
#import "UIUtils.h"
#import "ModAddressTableView.h"


@implementation AddressViewVontroller
{
    NSString *addressId;
    ModAddressTableView *modTableView;
}

-(void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.barTintColor = MakeColor(32, 102, 208);
    self.title = @"修改送餐地址";
   
    [self initNavigation];
    [self initView];
}

-(void)initNavigation
{
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDone)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
    
    //隐藏tabbar上的按钮
    UIButton *barBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [barBtn removeFromSuperview];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comeback"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}

-(void)initView
{

    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, kUIScreenWidth-15, 50)];
    addressLabel.text = [NSString stringWithFormat:@"当前地址:%@",self.addressStr];
    addressLabel.textColor = MakeColor(75, 75, 75);
    [self.view addSubview:addressLabel];
    
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(15, 119, kUIScreenWidth-30, 1)];
    line.image = [UIImage imageNamed:@"xuxian"];
    [self.view addSubview:line];
    UIButton *tf1 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    tf1.frame = CGRectMake(15, 134, kUIScreenWidth-30, 45);
    tf1.tag = 10001;
    tf1.layer.borderColor = [UIColor grayColor].CGColor;
    [tf1 setTitle:@"请选择楼栋" forState:UIControlStateNormal];
    tf1.titleLabel.font = [UIFont systemFontOfSize:16];
    [tf1 addTarget:self action:@selector(didClick) forControlEvents:UIControlEventTouchUpInside];
    [tf1 setTitleColor:MakeColor(187, 186, 194)forState:UIControlStateNormal];
    tf1.layer.borderWidth = 1.0;
    tf1.layer.cornerRadius = 5;
    tf1.layer.masksToBounds = YES;
    [self.view addSubview:tf1];
    UITextField *tf2 = [[UITextField alloc] initWithFrame:CGRectMake(15, 184, kUIScreenWidth-30, 45)];
    tf2.layer.borderColor = [UIColor grayColor].CGColor;
    tf2.layer.borderWidth = 1.0;
    tf2.layer.borderWidth = 1.0;
    tf2.layer.cornerRadius = 5;
    tf2.placeholder = @"输入寝室号";
    tf2.tag = 10002;
    tf2.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tf2];
    
}

-(void)returnAddress:(NSString *)address aId:(NSString *)aId
{
    addressId = aId;
    UIButton *btn = (UIButton *)[self.view viewWithTag:10001];
    [btn setTitle:address forState:UIControlStateNormal];
}


-(void)didClick
{
    SelectSchoolVC *selectVC = [[SelectSchoolVC alloc] init];
    selectVC.delegate1 = self;
    [self.navigationController pushViewController:selectVC animated:YES];
}

-(void)didClickDone
{
    UITextField *tf = (UITextField *)[self.view viewWithTag:10002];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:self.tId forKey:@"tId"];

    if (addressId) {
        [params setObject:addressId forKey:@"aId"];

    }else{
        [self alertView:@"请请选择楼栋"];
    }
    
    
    
    if (![UIUtils isNumber:tf.text]||tf.text.length>6) {
        [self alertView:@"房间号只能是小于六位的数字"];
        
    }else{
        [params setObject:tf.text forKey:@"room"];
        [RSHttp requestWithURL:@"/task/updateUnstandardAddr" params:params httpMethod:@"PUT" success:^(NSDictionary *data) {
            [self alertView:@"修改成功"];
            [self.delegate returnNameOfTableView:@"address"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSInteger code, NSString *errmsg) {
        }];
    }
    

}

-(void)didClickLeft
{
    [self.delegate returnNameOfTableView:@"address"];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)alertView:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    return;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

@end
