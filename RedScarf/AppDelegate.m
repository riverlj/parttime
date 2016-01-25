//
//  AppDelegate.m
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "Header.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "BaiduMobStat.h"

@interface AppDelegate (){
    NSString *updateUrl;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self BaiduMobStat];
    AppDelegate *myDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [self UpdateVersion];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
   
    if (token.length) {
        BaseTabbarViewController *baseVC = [[BaseTabbarViewController alloc] init];
        myDelegate.tocken = token;
        self.window.rootViewController = baseVC;
    }else{
        //没登陆
        LoginViewController *login = [[LoginViewController alloc] init];
        self.window.rootViewController = login;
    }
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)UpdateVersion
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
            NSString *content = [dic objectForKey:@"content"];
            
            //当前版本
            NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
            CFShow((__bridge CFTypeRef)(infoDictionary));
            NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
            updateUrl = [dic objectForKey:@"url"];

            if (![versionStr isEqualToString:app_Version]) {
                UIAlertView * aler=[[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"更新", nil];
                [aler show];
            }
        } failure:^(NSInteger code, NSString *errmsg) {
        }];
    }
}

-(void)BaiduMobStat
{
    BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
    [statTracker startWithAppId:@"89b848cd73"];
    statTracker.enableExceptionLog = YES; //截获崩溃信息
    statTracker.logStrategy = BaiduMobStatLogStrategyAppLaunch;
    statTracker.logSendInterval = 1;
    statTracker.channelId = [UIDevice utm_source];
    statTracker.logSendWifiOnly = NO;
    statTracker.sessionResumeInterval = 60;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        if(!updateUrl) {
            updateUrl = @"itms-services://?action=download-manifest&url=https://passport.honglingjinclub.com/downlod/RedScarf.plist";
        }
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:updateUrl]];
    }
}

- (void)setRootViewController:(UIViewController *)rootVC
{

    self.window.rootViewController = rootVC;
}

- (void)setViewController:(UIViewController *)rootVC
{
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window.rootViewController = navi;
}
//强制用系统键盘
- (BOOL)application:(UIApplication *)application shouldAllowExtensionPointIdentifier:(NSString *)extensionPointIdentifier
{
    if ([extensionPointIdentifier isEqualToString:@"com.apple.keyboard-service"]) {
        return NO;
    }
    return YES;
}

-(BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [UMSocialSnsService handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [UMSocialSnsService handleOpenURL:url];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
