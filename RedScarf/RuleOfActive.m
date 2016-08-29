//
//  RuleOfActive.m
//  RedScarf
//
//  Created by zhangb on 15/8/26.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RuleOfActive.h"

@implementation RuleOfActive

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self comeBack:nil];
    if ([self.title isEqualToString:@"工资说明"]) {
        [self show];
    }else{
        [self initRule];
    }
}

-(void)show
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, kUIScreenWidth-30, 200)];
    label.numberOfLines = 0;
    label.textColor = color155;
    label.text = @"Q：薪资是按照什么规则计算的？\nA：y=x+0.5a,其中x为底薪，a为任务数。\n\n举个例子：小明同学配送了5个任务，到3个宿舍，底薪为5元，工资为：y=5+0.5*5=7.5元。";
    [self.view addSubview:label];
}
-(void)initRule
{
    NSArray *imageArray = @[@"1-1@2x",@"2-1@2x",@"3-1@2x",@"4-1@2x",@"5-1@2x"];
    NSArray *textArray = @[@"1.分享推广活动，告知用户扫描红领巾二维码，关注红领巾平台（若已经关注，则可直接进入第2步）；",@"2.告知用户选择“订早餐啦”-“我的”-“我的优惠券”，使用兼职个人兑换码即可兑换处一张姨妈枣8折代金券；",@"3.告知用户回到“首页”即可使用姨妈枣代金券进行下单，同时可以参加抽大奖活动；",@"4.根据推广费规则统计兼职推广粉丝下单数量并核算推广费；",@"5.推广费会与提成一并结算，结算方式为线上提现。"];
    for (int i = 0; i < 5; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, i*60+26+64, kUIScreenWidth-80, 60)];
        label.textColor = MakeColor(75, 75, 75);
        label.numberOfLines = 0;
        label.text = textArray[i];
        label.font = [UIFont systemFontOfSize:14];
        [self.view addSubview:label];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, i*58+43+i+64, 20, 20)];
        imageView.image = [UIImage imageNamed:imageArray[i]];
        [self.view addSubview:imageView];
    }
}
@end
