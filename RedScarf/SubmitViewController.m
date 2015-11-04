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
    self.view.backgroundColor = color242;
    if ([self.title isEqualToString:@"提交"]) {
        [self initView];
    }
    if ([self.title isEqualToString:@"提现详情"]) {
        [self initDetailView];
    }
    
}

-(void)initView
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 80, kUIScreenWidth-40, 195)];
    if (kUIScreenWidth == 320) {
        bgView.frame = CGRectMake(20, 80, kUIScreenWidth-40, 155);
    }
    bgView.backgroundColor = [UIColor whiteColor];
    bgView.layer.masksToBounds = YES;
    bgView.layer.cornerRadius = 8;
    bgView.image = [UIImage imageNamed:@"tijiaochengong"];
    bgView.layer.borderColor = color234.CGColor;
    bgView.layer.borderWidth = 0.8;
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

-(void)initDetailView
{
    
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
