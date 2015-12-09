//
//  BannerViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/16.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BannerViewController.h"
#import "UIWebView+AFNetworking.h"

@interface BannerViewController ()

@end

@implementation BannerViewController
{
    UIWebView *bannerView;
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
    bannerView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth+kUITabBarHeight)];
    bannerView.delegate = self;
    if ([self.title isEqualToString:@"详情"]) {
        url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",self.url]];
    }else if ([self.title isEqualToString:@"CEO群"]){
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jianzhi.honglingjinclub.com/html/banner/20151113/ceo.html"]];
    }else{
        url = [NSURL URLWithString:[NSString stringWithFormat:@"http://jianzhi.honglingjinclub.com/html/banner/20151026/QandA.html"]];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
    request.timeoutInterval = 5;
    [bannerView loadRequest:request];
    [self.view addSubview:bannerView];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showHUD:@"加载中"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hidHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [self hidHUD];
    NSString *errmsg = [error.userInfo valueForKey:@"NSLocalizedDescription"];
    [self alertView:errmsg];
}
@end
