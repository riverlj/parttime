//
//  VersionViewController.m
//  RedScarf
//
//  Created by zhangb on 15/11/16.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "VersionViewController.h"

@interface VersionViewController ()

@end

@implementation VersionViewController
{
    NSString *app_Version;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    self.tabBarController.tabBar.hidden = YES;
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"版本管理";
    [self initView];
}

-(void)initView
{
    UIImageView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth/5*3)];
    [self.view addSubview:bgView];
    bgView.image = [UIImage imageNamed:@"versionbg"];
    bgView.userInteractionEnabled = YES;
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-110, kUIScreenHeigth/2-140, 75, 110)];
    iconView.image = [UIImage imageNamed:@"versionicon"];
    [self.view addSubview:iconView];
    
    //当前版本
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    
    UILabel *version = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2+10, kUIScreenHeigth/2-150, 150, 50)];
    version.text = [NSString stringWithFormat:@"版本号：v%@",app_Version];
    version.font = textFont15;
    version.textColor = [UIColor whiteColor];
    [self.view addSubview:version];
    
    UIButton *versionBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [versionBtn setTitle:@"检查更新" forState:UIControlStateNormal];
    [versionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    versionBtn.frame = CGRectMake(kUIScreenWidth/2+10, version.frame.size.height+version.frame.origin.y, 100, 30);
    versionBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    versionBtn.layer.borderWidth = 0.5;
    versionBtn.layer.cornerRadius = 5;
    versionBtn.layer.masksToBounds = YES;
    [versionBtn addTarget:self action:@selector(checkVersion) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:versionBtn];
    
    UIImageView *erweimaView;
    if (kUIScreenWidth == 320) {
        erweimaView = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-50, bgView.frame.size.height+bgView.frame.origin.y+20, 100, 100)];

    }else{
        erweimaView = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-50, bgView.frame.size.height+bgView.frame.origin.y+30, 100, 100)];

    }
        erweimaView.image = [UIImage imageNamed:@"erweima"];
    [self.view addSubview:erweimaView];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-10, erweimaView.frame.size.height+erweimaView.frame.origin.y+10, 30, 20)];
    title.textColor = [UIColor grayColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"先锋";
    title.font = textFont15;
    [self.view addSubview:title];
    UILabel *address;
    if (kUIScreenWidth == 320) {
        address = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-60, title.frame.size.height+title.frame.origin.y+10, 120, 20)];
    }else{
        address = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-60, title.frame.size.height+title.frame.origin.y+30, 120, 20)];
    }
    
    address.textAlignment = NSTextAlignmentCenter;
    address.textColor = [UIColor grayColor];
    address.text = @"@honglingjin.com";
    address.font = textFont12;
    [self.view addSubview:address];
}

-(void)checkVersion
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ([defaults objectForKey:@"token"]) {
        [params setObject:[defaults objectForKey:@"token"] forKey:@"token"];
        [params setObject:@"2" forKey:@"type"];
        [RSHttp requestWithURL:@"/user/version" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic = [data objectForKey:@"body"];
            NSString *versionStr = [dic objectForKey:@"version"];
            
            if (![versionStr isEqualToString:app_Version]) {
                UIAlertView * aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"新版本更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                [aler show];
            }else{
                [self alertView:@"当前为最新版本"];
            }
        } failure:^(NSInteger code, NSString *errmsg) {
        }];
        [RSHttp requestWithURL:@"/user/version" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            dic = [data objectForKey:@"body"];
            NSString *versionStr = [dic objectForKey:@"version"];
            
            if (![versionStr isEqualToString:app_Version]) {
                UIAlertView * aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"新版本更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"更新", nil];
                [aler show];
            }else{
                [self alertView:@"当前为最新版本"];
            }
        } failure:^(NSInteger code, NSString *errmsg) {
        }];
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://passport.honglingjinclub.com/downlod/RedScarf.plist"]];
    }
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
