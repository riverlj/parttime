//
//  RuleOfActive.m
//  RedScarf
//
//  Created by zhangb on 15/8/26.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RuleOfActive.h"

@implementation RuleOfActive

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
    [self comeBack:nil];
}

-(void)viewDidLoad
{
    self.title = @"活动规则";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.barTintColor = MakeColor(32, 102, 208);
    self.tabBarController.tabBar.hidden = YES;
    [self navigationBar];

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, kUIScreenHeigth)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    NSArray *imageArray = @[@"1-1@2x",@"2-1@2x",@"3-1@2x",@"4-1@2x"];
    NSArray *textArray = @[@"第一步：生成only for you的推广识别二维码；",@"第二步：用所有可行的方式推广（如：扫楼、群发、活动）；",@"第三步：鼓励同学们扫码下单买买买；",@"第四步：wait  for系统判定订单有效，工资定期入账。"];
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, i*60+26, kUIScreenWidth-80, 50)];
        label.textColor = MakeColor(75, 75, 75);
        label.numberOfLines = 0;
        label.text = textArray[i];
        label.font = [UIFont systemFontOfSize:14];
        [view addSubview:label];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, i*58+43, 20, 20)];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        [view addSubview:imageView];
        
    }
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
