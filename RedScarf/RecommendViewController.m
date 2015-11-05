//
//  RecommendViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/26.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RecommendViewController.h"


@implementation RecommendViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
    [self comeBack:nil];
}

-(void)viewDidLoad
{
    self.title = @"我要推荐";
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.barTintColor = MakeColor(32, 102, 208);
    self.tabBarController.tabBar.hidden = YES;
    [self navigationBar];
    [self initView];
}

-(void)initView
{
    UIImageView *codeView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 100, kUIScreenWidth-120, kUIScreenWidth-120)];
    codeView.backgroundColor = [UIColor redColor];
    [self.view addSubview:codeView];
    
    UILabel *code = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-70, codeView.frame.size.height+codeView.frame.origin.y+20, 140, 40)];
    code.text = [NSString stringWithFormat:@"兑换码：%@",self.code];
    code.textColor = color155;
    [self.view addSubview:code];
    code.font = textFont16;
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    shareBtn.frame = CGRectMake(40, code.frame.size.height+code.frame.origin.y+20, kUIScreenWidth-80, 40);
    [shareBtn setTitle:@"大方的分享" forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(didClickShareBtn) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    shareBtn.backgroundColor = MakeColor(85, 130, 255);
    shareBtn.layer.masksToBounds = YES;
    shareBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    shareBtn.layer.cornerRadius = 5;
    [self.view addSubview:shareBtn];
    
}

-(void)didClickShareBtn
{
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:AppKey
                                      shareText:@"红领巾正式上线"
                                     shareImage:[UIImage imageNamed:nil]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:self];
    //qq空间需要的参数
    [UMSocialData defaultData].extConfig.qzoneData.url = @"http://baidu.com";
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:@"http://star.xiziwang.net/uploads/allimg/140930/19_140930101146_1.jpg"];
    
    [UMSocialData defaultData].extConfig.qzoneData.title = @"红领巾";
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
