//
//  SubmitViewController.m
//  RedScarf
//
//  Created by zhangb on 15/11/2.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "SubmitViewController.h"
#import "TransactionViewController.h"

@interface SubmitViewController ()

@end

@implementation SubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self comeBack:nil];
    self.title = @"提交";
    [self initView];
}

-(void)initView
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 80, kUIScreenWidth-40, (kUIScreenWidth - 36)*197.0/339)];
    bgView.image = [UIImage imageNamed:@"tijiaochengong"];
    [self.view addSubview:bgView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    btn.frame = CGRectMake(kUIScreenWidth/2-100, bgView.frame.size.height+bgView.frame.origin.y+40, 200, 40);
    [btn setTitle:@"查看提现纪录" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 6;
    btn.layer.masksToBounds = YES;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(TiXianJiLu) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundColor:colorblue];
    [self.view addSubview:btn];
}

-(void)TiXianJiLu
{
    TransactionViewController *transactionVC = [[TransactionViewController alloc] init];
    transactionVC.title = @"提现纪录";
    [self.navigationController pushViewController:transactionVC animated:YES];
}

@end
