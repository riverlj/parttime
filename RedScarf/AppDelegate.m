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
#import "LaunchimageViewController.h"
#import "XHCustomShareView.h"

@interface AppDelegate (){
    NSString *updateUrl;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self BaiduMobStat];
    [self UpdateVersion];

    LaunchimageViewController *lanchImageVc = [[LaunchimageViewController alloc]init];
    self.window.rootViewController = lanchImageVc;
    
     [UMSocialData setAppKey:YOUMENGAPPKEY];
    [UMSocialWechatHandler setWXAppId:WXAPPKEY appSecret:WXAPPSECRET url:@"http://honglingjinclub.com"];
    [WXApi registerApp:WXAPPKEY];
    
//    [self customsizeInterface];
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)customsizeInterface
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //导航样式
    [[UINavigationBar appearance] setBackgroundImage:[self imageFromColor:RS_THRME_COLOR] forBarMetrics:UIBarMetricsDefault];
    
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                          [UIColor whiteColor], NSForegroundColorAttributeName,
                                                          [UIFont boldSystemFontOfSize:17.0], NSFontAttributeName, nil]];
    [[UINavigationBar appearance] setBackgroundColor:RS_THRME_COLOR];
}

- (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


- (void)switchRootViewController {
    NSString *token = [NSUserDefaults getValue:@"token"];
    
    if (token.length) {
        BaseTabbarViewController *baseVC = [[BaseTabbarViewController alloc] init];
        [NSUserDefaults setValue:token forKey:@"token"];
        self.window.rootViewController = baseVC;
    }else{
        //没登陆
        LoginViewController *login = [[LoginViewController alloc] init];
        self.window.rootViewController = login;
    }
}

-(void)UpdateVersion
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    [RSHttp mobileRequestWithURL:@"/mobile/version/" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSMutableDictionary *dic = [data objectForKey:@"body"];
        NSString *content = [dic valueForKey:@"content"];
        updateUrl = [dic valueForKey:@"url"];
        if ([[dic valueForKey:@"forceUpdate"] boolValue]) {
            UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:nil otherButtonTitles:@"更新", nil];
            [alert show];
        } else {
            if([[dic valueForKey:@"showUpdate"] boolValue]) {
                UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"提示" message:content delegate:self cancelButtonTitle:@"更新" otherButtonTitles:@"取消", nil];
                [alert show];
            }
        }
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
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
            updateUrl = @"itms-services://?action=download-manifest&url=https://pay.honglingjinclub.com/PList/RedScarf.plist";
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
    if ([url.scheme isEqualToString:@"wx725baec806f0cae0"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    return [UMSocialSnsService handleOpenURL:url];
}

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if ([url.scheme isEqualToString:@"wx725baec806f0cae0"]) {
        [WXApi handleOpenURL:url delegate:self];
    }
    
    return [UMSocialSnsService handleOpenURL:url];
}

-(void) onResp:(BaseResp*)resp
{
    if ([resp isKindOfClass:SendAuthResp.class]) {
        SendAuthResp *aresp = (SendAuthResp *)resp;
        if (aresp.errCode== 0) {
            NSString *code = aresp.code;
            //请求token
            [self getAccess_token:code];
        }
    }
    
    if ([resp isKindOfClass:SendMessageToWXResp.class]) {
        SendMessageToWXResp *aresp = (SendMessageToWXResp *)resp;
        XHCustomShareView *shareView = [self.window viewWithTag:9876];
        [shareView dismissShareView];
        if (aresp.errCode == 0) {
            [[RSToastView shareRSToastView] showToast:@"分享成功"];
        }else{
            [[RSToastView shareRSToastView] showToast:@"分享失败"];
        }
    }
}

-(void)getAccess_token:(NSString *)code
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",WXAPPKEY,WXAPPSECRET,code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                //微信登陆
                [RSHttp requestWithURL:@"/user/wxauth" params:dic httpMethod:@"POSTJSON" success:^(NSDictionary *data) {
                    [[RSToastView shareRSToastView] showToast:@"授权成功"];
                } failure:^(NSInteger code, NSString *errmsg) {
                    [[RSToastView shareRSToastView] showToast:errmsg];
                }];
                
            }
        });
    });
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
