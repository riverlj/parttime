//
//  ManageMoneyMattersViewController.m
//  RedScarf
//
//  Created by 李江 on 16/10/17.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "ManageMoneyMattersViewController.h"
#import "RSWebView.h"

@interface ManageMoneyMattersViewController ()
{
    RSWebView *bannerView;
}
@end

@implementation ManageMoneyMattersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initWebView];
}

-(void)initWebView
{
    NSURL *url;
    bannerView = [[RSWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    bannerView.delegate = self;
    url = [NSURL URLWithString:self.urlstr];
    if(!url) {
        [self alertView:@"URL地址错误"];
        return;
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    request.timeoutInterval = 5;
    [bannerView loadRequest:request];
    [self.view addSubview:bannerView];
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showHUD:@"加载中"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hidHUD];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self hidHUD];
}
@end
