//
//  BaseViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "Header.h"
#import "UIView+ViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RS_COLOR_BACKGROUND;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, textFont18, NSFontAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.navigationController.navigationBar setBackgroundImage:[self imageFromColor:RS_THRME_COLOR ] forBarMetrics:UIBarMetricsDefault];
}


-(void) viewWillAppear:(BOOL)animated
{
    if(self.navigationController) {
        if(self.tabBarController && [self.tabBarController isKindOfClass:[BaseTabbarViewController class]]) {
            BaseTabbarViewController *tabBar = (BaseTabbarViewController *) self.tabBarController;
            if([self.navigationController.viewControllers count] > 1) {
                tabBar.tabBar.hidden = YES;
                tabBar.btn.hidden = YES;
            } else {
                tabBar.tabBar.hidden = NO;
                tabBar.btn.hidden = NO;
            }
        }
        //判断navigation是否有push
        if([self.navigationController.viewControllers count] > 1) {
            [self comeBack:nil];
        } else {
            self.navigationItem.leftBarButtonItem = nil;
        }
    }
    [super viewWillAppear:animated];
}

-(void)navigationBar
{

}

-(void)comeBack:(UIColor *)color
{
    UIImage *img= [[UIImage imageNamed:@"nav_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}



-(void)alertView:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    return;
}

-(MBProgressHUD *) hud
{
    if(_hud) {
        return _hud;
    }
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    return _hud;
}

//显示加载
- (void)showHUD:(NSString *)title {
    self.hud = nil;
    self.hud.mode=MBProgressHUDModeIndeterminate;
    self.hud.labelText = title;
    [self.hud show:YES];
}

//隐藏加载、
- (void)hidHUD {
    [self.hud hide:YES];
    self.hud = nil;
}


-(UIView *)named:(NSString *)imageNamed text:(NSString *)text
{
    UIView *view;
    view.tag = 666;
    UIImageView *kong;
    UILabel *label;
    if (kUIScreenWidth == 320) {
        view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-55, self.view.frame.size.height/2-75, 110, 150)];
        kong = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, kong.frame.size.height+kong.frame.origin.y+20, 110, 30)];
        

    }else{
        view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-55, self.view.frame.size.height/2-115, 110, 150)];
        kong = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, kong.frame.size.height+kong.frame.origin.y+20, 110, 30)];
        
    }
    view.backgroundColor = color242;
    
    kong.image = [UIImage imageNamed:imageNamed];
    [view addSubview:kong];
    
    label.text = [NSString stringWithFormat:@"暂时没有%@哟~",text];
    label.textColor = color155;
    label.font = textFont12;
    [view addSubview:label];
    return view;
}


-(void) didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)showToast:(NSString *)str
{
    self.hud.labelText = str;
    self.hud.mode = MBProgressHUDModeText;
    self.hud.yOffset = -100;
    [self.hud showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [self.hud removeFromSuperview];
        self.hud = nil;
    }];
    
}

-(RSTipsView *) tips
{
    if(_tips) {
        return _tips;
    }
    _tips = [[RSTipsView alloc] initWithFrame:self.view.bounds];
    [_tips setTitle:@"暂时没有数据哦" withImg:@"kongrenwu"];
    return _tips;
}

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
