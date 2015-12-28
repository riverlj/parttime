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
#import "RSHttp.h"
#import "AppDelegate.h"
#import "UIUtils.h"
#import "BaiduMobStat.h"
#import "MJRefreshFooterView.h"
#import "MJRefreshHeaderView.h"

@interface BaseViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate,UISearchControllerDelegate,UISearchDisplayDelegate,UIActionSheetDelegate,UISearchBarDelegate,UIAlertViewDelegate,UITextFieldDelegate,MJRefreshBaseViewDelegate>
{
    UIView *_tipView;
}

@property(nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong)MBProgressHUD *hud;

-(void)alertView:(NSString *)msg;

-(void)comeBack:(UIColor *)color;

-(void)navigationBar;


-(void)showAlertHUD:(NSString*)title;
//hud
//显示加载
- (void)showHUD:(NSString *)title;
//隐藏加载
- (void)hidHUD;
//toast
-(void)showToast:(NSString *)str;

-(UIView *)named:(NSString *)imageNamed text:(NSString *)text;
-(void)didClickLeft;
@end
