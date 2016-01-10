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

//显示加载
- (void)showHUD:(NSString *)title {
    [self.hud hide:NO];
    self.hud.mode=MBProgressHUDModeIndeterminate;
    [self.hud setYOffset:-40];
    self.hud.labelText = title;
}

//隐藏加载、
- (void)hidHUD {
    [self.hud hide:YES];
    self.hud = nil;
}

-(UIView *)named:(NSString *)imageNamed text:(NSString *)text
{
    
    UIView *view;
    UIImageView *kong;
    UILabel *label;
    if (kUIScreenWidth == 320) {
        view = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-55, self.frame.size.height/2-75, 110, 150)];
        kong = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 110, 110)];
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, kong.frame.size.height+kong.frame.origin.y+20, 110, 30)];
        
    }else{
        view = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-55, self.frame.size.height/2-115, 110, 150)];
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

-(MBProgressHUD *) hud
{
    if(_hud) {
        return _hud;
    }
    _hud = [[MBProgressHUD alloc] initWithView:self];
    [self addSubview:self.hud];
    return _hud;
}

-(void)showToast:(NSString *)str
{
    [self.hud hide:NO];
    self.hud.yOffset = kUIScreenHeigth/2;
    self.hud.labelText = str;
    self.hud.mode = MBProgressHUDModeText;
    [self.hud showAnimated:YES whileExecutingBlock:^{
        self.hud.yOffset = kUIScreenHeigth/2 - 150;
        sleep(1);
    } completionBlock:^{
        [self.hud removeFromSuperview];
        self.hud = nil;
    }];
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}
@end
