//
//  BaseViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "Header.h"
#import "UIViewExt.h"
#import "UIView+ViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = color_gray_f3f5f7;

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
    }
    [super viewWillAppear:animated];
}

-(void)navigationBar
{

}
//获取当前时间
-(NSString *)date:(NSString *)type
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:type];
    NSString *dateStr = [formatter stringFromDate:date];
    return dateStr;
}

-(NSString *)timeIntersince1970:(double)date
{
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:date/1000];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date1];
    return dateStr;
}

-(void)comeBack:(UIColor *)color
{
    UIImage *img= [[UIImage imageNamed:@"newfanhui"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:color,NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];

}

-(NSString *)stringFromStatus:(NetworkStatus)status
{
    NSString *string;
    switch (status) {
        case NotReachable:
        {
            string = @"not";
        }
            break;
        case ReachableViaWiFi:
        {
            string = @"wifi";
        }
            break;
        case ReachableViaWWAN:
        {
            string = @"wwan";
        }
            break;
            
        default:
            break;
    }
    return string;
}


-(void)alertView:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    return;
}

- (void)showLoading:(BOOL)show {
    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, (kUIScreenHeigth-20-44)/2, kUIScreenWidth, 30)];
        _tipView.backgroundColor = [UIColor clearColor];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [_tipView addSubview:activityView];
        
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        loadLabel.backgroundColor = [UIColor clearColor];
        loadLabel.text = @"正在加载...";
        loadLabel.textColor = [UIColor blackColor];
        [loadLabel sizeToFit];
        [_tipView addSubview:loadLabel];
    
        loadLabel.left = (kUIScreenWidth - loadLabel.width+10)/2;
        activityView.right = loadLabel.left - 5;
        
    }
    
    if (show) {
        [self.view addSubview:_tipView];
    } else {
        if (_tipView.superview) {
            [_tipView removeFromSuperview];
        }
    }
    
}


- (void)showLoadingByName:(BOOL)show desc:(NSString *)desc{
    if (_tipView == nil) {
        _tipView = [[UIView alloc] initWithFrame:CGRectMake(0, (kUIScreenHeigth-20-44)/2, kUIScreenWidth, 30)];
        _tipView.backgroundColor = [UIColor clearColor];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityView startAnimating];
        [_tipView addSubview:activityView];
        
        UILabel *loadLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        loadLabel.backgroundColor = [UIColor clearColor];
        loadLabel.text = desc;
        loadLabel.textColor = [UIColor blackColor];
        [loadLabel sizeToFit];
        [_tipView addSubview:loadLabel];
        
        loadLabel.left = (kUIScreenWidth - loadLabel.width+10)/2;
        activityView.right = loadLabel.left - 5;
        
    }
    
    if (show) {
        [self.view addSubview:_tipView];
    } else {
        if (_tipView.superview) {
            [_tipView removeFromSuperview];
        }
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
}


//显示加载
- (void)showHUD:(NSString *)title {
    [self.hud hide:NO];
    if (_hud == nil) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    } else {
    }
    self.hud.mode=MBProgressHUDModeIndeterminate;
    self.hud.labelText = title;
    
}
-(void)showAlertHUD:(NSString*)title{
    [self.hud hide:NO];
    if (_hud == nil) {
        self.hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    } else {
        //        [self.view addSubview:self.hud];
    }
    self.hud.labelText = title;
    self.hud.dimBackground = YES;
    self.hud.mode=MBProgressHUDModeCustomView;
    [self.hud hide:YES afterDelay:1.5];
}
//隐藏加载、
- (void)hidHUD {
    [self.hud hide:YES];
    self.hud = nil;
}

- (void)hidHUDWithLoadComplete:(NSString *)title {
    self.hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    self.hud.mode = MBProgressHUDModeCustomView;
    self.hud.labelText = title;
    
    //延迟隐藏
    [self.hud hide:YES afterDelay:1.5];
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

-(void)showAllTextDialog:(NSString *)str
{
    [self.hud hide:NO];
    if (_hud == nil) {
        self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    } else {
    }
    [self.view addSubview:self.hud];
    self.hud.yOffset = 100;
    self.hud.labelText = str;
    self.hud.mode = MBProgressHUDModeText;
    [self.hud showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [self.hud removeFromSuperview];
        self.hud = nil;
    }];
    
}
@end
