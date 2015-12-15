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
    self.view.backgroundColor = [UIColor whiteColor];
    [self comeBack:nil];
    [self initWebView];
}

-(void)initWebView
{
    NSURL *url;
    bannerView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth+kUITabBarHeight)];
    bannerView.delegate = self;
    url = [NSURL URLWithString:self.urlString];
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
    NSMutableURLRequest *req = [request mutableCopy];
    NSString *urlStr = [req.URL absoluteString];
    if([urlStr hasPrefix:REDSCARF_BASE_URL]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([defaults objectForKey:@"token"] &&  [urlStr rangeOfString:@"token="].location == NSNotFound) {
            if([urlStr rangeOfString:@"?"].location == NSNotFound) {
                urlStr = [NSString stringWithFormat:@"%@?token=%@", urlStr, [NSString URLencode:[defaults objectForKey:@"token"] stringEncoding:NSUTF8StringEncoding]];
            } else {
                urlStr = [NSString stringWithFormat:@"%@&token=%@", urlStr, [NSString URLencode:[defaults objectForKey:@"token"] stringEncoding:NSUTF8StringEncoding]];
            }
            req.URL = [NSURL URLWithString:urlStr];
            [bannerView loadRequest:req];
            return false;
        }
    }
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

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error
{
    [self hidHUD];
    NSString *errmsg = [error.userInfo valueForKey:@"NSLocalizedDescription"];
    [self alertView:errmsg];
}

@end
