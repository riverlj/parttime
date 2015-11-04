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
#import "Flurry.h"
#import "BaiduMobStat.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self BaiduMobStat];
    [UMSocialData setAppKey:AppKey];
    [UMSocialQQHandler setQQWithAppId:@"1104757597" appKey:@"5FWCaDeaGQs5JN5V" url:@"http://www.baidu.com"];
    [UMSocialWechatHandler setWXAppId:@"wxff361bf22a286ed2" appSecret:@"aa909ed684171b3af81e80a09b7c6541" url:@"http://www.baidu.com"];
    [Flurry setCrashReportingEnabled:YES];
    [Flurry startSession:@"ZWVZ56TNDFHVQX48RMD2"];
    AppDelegate *myDelegate = [UIApplication sharedApplication].delegate;
    myDelegate.count = @"";
    if (kUIScreenHeigth>480) {
        myDelegate.autoSizeScaleX = kUIScreenWidth/320;
        myDelegate.autoSizeScaleY = kUIScreenHeigth/568;
    }else{
        myDelegate.autoSizeScaleX = 1.0;
        myDelegate.autoSizeScaleY = 1.0;
    }
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    switch (status) {
        case NotReachable:
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"当前没有网络" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
            
        }
            break;
            
        default:
            break;
    }

    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
   
    myDelegate.count = [defaults objectForKey:@"count"];
    if (token.length) {
        BaseTabbarViewController *baseVC = [[BaseTabbarViewController alloc] init];
    
        myDelegate.tocken = token;
        self.window.rootViewController = baseVC;
    }else{
        //没登陆
        LoginViewController *login = [[LoginViewController alloc] init];
        self.window.rootViewController = login;
    }
    
    [self UpdateVersion];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)UpdateVersion
{
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    app.tocken = [UIUtils replaceAdd:app.tocken];
    if (app.tocken.length) {
        [params setObject:app.tocken forKey:@"token"];
        [params setObject:@"2" forKey:@"type"];
        
        [RedScarf_API requestWithURL:@"/user/version" params:params httpMethod:@"GET" block:^(id result) {
            NSLog(@"result = %@",result);
            if (![[result objectForKey:@"code"] boolValue]) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic = [result objectForKey:@"body"];
                NSString *versionStr = [dic objectForKey:@"version"];
                
                //当前版本
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                CFShow((__bridge CFTypeRef)(infoDictionary));
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                
                if ([versionStr intValue] != [app_Version intValue]) {
                    UIAlertView * aler=[[UIAlertView alloc]initWithTitle:@"提示" message:@"新版本更新" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                    [aler show];
                }
            }
            
        }];
        

    }
}

-(void)BaiduMobStat
{
    BaiduMobStat *statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES; //截获崩溃信息
    statTracker.logStrategy = BaiduMobStatLogStrategyCustom;
    statTracker.logSendInterval = 1;
    statTracker.logSendWifiOnly = YES;
    statTracker.sessionResumeInterval = 60;
    [statTracker startWithAppId:@"89b848cd73"];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==1) {
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"itms-services://?action=download-manifest&url=https://passport.honglingjinclub.com/downlod/RedScarf.plist"]];
    }
}

- (void)setRoorViewController:(UIViewController *)rootVC
{

    self.window.rootViewController = rootVC;
}

- (void)setViewController:(UIViewController *)rootVC
{
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:rootVC];
    
    self.window.rootViewController = navi;
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
