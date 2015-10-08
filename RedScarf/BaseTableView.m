//
//  BaseTableView.m
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseTableView.h"
#import "MBProgressHUD.h"
#import "UIView+ViewController.h"
#import "Header.h"
#import "UIViewExt.h"
@implementation BaseTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    
    [self viewDidLayoutSubviews];
    
    return self;
}

-(void)viewDidLayoutSubviews {
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)])  {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
    
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
        [self addSubview:_tipView];
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
        [self addSubview:_tipView];
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
        self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
    } else {
        //        [self.view addSubview:self.hud];
    }
    self.hud.mode=MBProgressHUDModeIndeterminate;
//    self.hud.minSize = CGSizeMake(30, 30);
    [self.hud setYOffset:-40];
    self.hud.labelText = title;
//    self.hud.dimBackground = YES;
    
}
-(void)showAlertHUD:(NSString*)title{
    [self.hud hide:NO];
    if (_hud == nil) {
        self.hud = [MBProgressHUD showHUDAddedTo:self animated:YES];
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


@end
