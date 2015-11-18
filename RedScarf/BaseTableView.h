//
//  BaseTableView.h
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface BaseTableView : UITableView<UITableViewDataSource,UITableViewDelegate>
{
    UIView *_tipView;
}

-(void)alertView:(NSString *)msg;


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

-(UIView *)named:(NSString *)imageNamed text:(NSString *)text;
@end
