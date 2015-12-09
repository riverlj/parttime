//
//  RecommendViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/26.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RecommendViewController.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"

@implementation RecommendViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [super viewWillAppear:animated];
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
//    codeView.backgroundColor = [UIColor redColor];
    codeView.image = [UIImage imageNamed:@"shareerweima"];
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
    [UMSocialData setAppKey:AppKey];
    [UMSocialQQHandler setQQWithAppId:@"1104757597" appKey:@"5FWCaDeaGQs5JN5V" url:[NSString stringWithFormat:@"weixin.honglingjinclub.com/activity/pingtaituiguang?exchangecode=%@",self.code]];
    [UMSocialWechatHandler setWXAppId:@"wxff361bf22a286ed2" appSecret:@"aa909ed684171b3af81e80a09b7c6541" url:[NSString stringWithFormat:@"weixin.honglingjinclub.com/activity/pingtaituiguang?exchangecode=%@",self.code]];

    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:AppKey
                                      shareText:[NSString stringWithFormat:@"看完你就懂了！兑换码：%@",self.code]
                                     shareImage:[UIImage imageNamed:@"shareerweima"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToQzone,UMShareToQQ,UMShareToWechatSession,UMShareToWechatTimeline,nil]
                                       delegate:self];
    //微信只分享图片
//    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    //qq空间需要的参数
    [UMSocialData defaultData].extConfig.qzoneData.url = @"http://relay.honglingjinclub.com/saoma.jpg";
    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:[NSString stringWithFormat:@"weixin.honglingjinclub.com/activity/pingtaituiguang?exchangecode=%@",self.code]];
    [UMSocialData defaultData].extConfig.title = @"姨妈枣凭啥刷爆朋友圈？";

}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
