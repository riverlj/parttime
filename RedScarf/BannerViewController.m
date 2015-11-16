//
//  BannerViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/16.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BannerViewController.h"

@interface BannerViewController ()

@end

@implementation BannerViewController
{
    UIWebView *bannerView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self comeBack:nil];
    [self initWebView];
}

-(void)initWebView
{
    NSURL *url;
    bannerView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth+64)];
    bannerView.delegate = self;
    if ([self.title isEqualToString:@"详情"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://weixin.honglingjinclub.com/activity/customactivity?id=3"]];
    }else if ([self.title isEqualToString:@"CEO群"]){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jianzhi.honglingjinclub.com/html/banner/20151113/ceo.html"]];
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jianzhi.honglingjinclub.com/html/banner/20151026/QandA.html"]];
    }
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    [bannerView loadRequest:request];
    [self.view addSubview:bannerView];
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
