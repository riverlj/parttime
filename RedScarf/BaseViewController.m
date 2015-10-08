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
    self.view.backgroundColor = [UIColor whiteColor];
    
}


-(void)navigationBar
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comeback"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
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
        //        [self.view addSubview:self.hud];
    }
    self.hud.mode=MBProgressHUDModeIndeterminate;
//    [self.hud setYOffset:100];
    self.hud.labelText = title;
//    self.hud.dimBackground = YES;
    
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
