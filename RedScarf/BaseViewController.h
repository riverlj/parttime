//
//  BaseViewController.h
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "Header.h"
#import "RedScarf_API.h"
#import "AppDelegate.h"
#import "UIUtils.h"
#import "Reachability.h"

@interface BaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate,UIActionSheetDelegate,UISearchBarDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    UIView *_tipView;
}

-(NSString *)stringFromStatus:(NetworkStatus)status;

-(void)alertView:(NSString *)msg;

-(void)comeBack:(UIColor *)color;

-(void)navigationBar;

@property(nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong)MBProgressHUD *hud;
//加载提示
- (void)showLoading:(BOOL)show;

//增加提示语言
- (void)showLoadingByName:(BOOL)show desc:(NSString *)desc;

-(void)showAlertHUD:(NSString*)title;
//hud
//显示加载
- (void)showHUD:(NSString *)title;
//隐藏加载
- (void)hidHUD;
//隐藏之前显示加载完成的提示
- (void)hidHUDWithLoadComplete:(NSString *)title;

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
@end
