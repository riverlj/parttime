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

@property (nonatomic,strong)MBProgressHUD *hud;


-(void)alertView:(NSString *)msg;

-(void)showAlertHUD:(NSString*)title;

//显示加载
- (void)showHUD:(NSString *)title;
//隐藏加载
- (void)hidHUD;
-(void)showToast:(NSString *)str;


-(UIView *)named:(NSString *)imageNamed text:(NSString *)text;
@end
