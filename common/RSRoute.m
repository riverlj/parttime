//
//  RSRouteController.m
//  RedScarf
//
//  Created by lishipeng on 16/1/6.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSRoute.h"
#import "AppDelegate.h"
#import "RSWebViewController.h"
static RSRoute *gsharedAccount = nil;

@implementation RSRoute
{
    NSMutableDictionary *routeDic;
}

+ (id)sharedAccount {
    if (gsharedAccount) {
        return gsharedAccount;
    }
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gsharedAccount = [[self alloc] init];
    });
    return gsharedAccount;
}

-(instancetype) init
{
    self = [super init];
    if(self) {
        routeDic = [NSMutableDictionary dictionary];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"HomeViewController",@"vcName", @"1", @"isMenu", @"0", @"menuIndex", nil];
        [routeDic setObject:dic forKey:@"home"];
        dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"MyViewController",@"vcName", @"1", @"isMenu", @"1", @"menuIndex", nil];
        [routeDic setObject:dic forKey:@"myprofile"];
    }
    return self;
}

-(NSMutableDictionary *) getObjectByName:(NSString *)name
{
    NSMutableDictionary *dic;
    if([routeDic valueForKey:name]) {
        dic = [routeDic valueForKey:name];
    } else {
        dic = [NSMutableDictionary dictionary];
    }
    return dic;
}

-(void) setValueByName:(NSString *)name key:(NSString *)key value:(NSString *)value
{
    NSMutableDictionary *dic = [self getObjectByName:name];
    [dic setObject:value forKey:key];
    [routeDic setObject:dic forKey:name];
}

//注册vc
-(void) register:(NSString *)name vcName:(NSString *)vcName
{
    [self setValueByName:name key:@"vcName" value:vcName];
}

-(UIViewController *) getVcByName:(NSString *)name
{
    NSMutableDictionary *dic = [self getObjectByName:name];
    NSString *vcName = @"";
    if(![dic valueForKey:@"vcName"]) {
        vcName = [[name capitalizedString] append:@"ViewController"];
    } else {
        vcName = [dic valueForKey:@"vcName"];
    }
    if(NSClassFromString(vcName)) {
        UIViewController *vc = [[NSClassFromString(vcName) alloc] init];
        return vc;
    }
    return nil;
}

//获取当前的viewController
+(UIViewController *) superViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

//跳转到某一个path
-(void) redirectTo:(NSString *)path animation:(BOOL)animation
{
    NSDictionary *dict = [path parseURLParams];
    NSString *pathName = [dict objectForKey:@"path"];
    NSString *protocol = [dict valueForKey:@"protocol"];
    UIViewController *view = [RSRoute superViewController];
    if([protocol isEqualToString:@"http"] || [protocol isEqualToString:@"https"]) {
        RSWebViewController *webview = [[RSWebViewController alloc] init];
        if(view.tabBarController && view.navigationController) {
            [view.navigationController pushViewController:webview animated:animation];
        } else {
            [view presentViewController:webview animated:animation completion:^{}];
        }
        return;
    }
    NSArray *pagramArray = [pathName componentsSeparatedByString:@"/"];
    if(view.tabBarController) {
        if([self isMenu:(pagramArray[0])]) {
            [view.tabBarController setSelectedIndex:[self menuIndex:pagramArray[0]]];
        }
        if(![self isMenu:[pagramArray objectAtIndex:[pagramArray count]]]) {
            UIViewController *redirectVc =  [self getVcByName:[pagramArray objectAtIndex:[pagramArray count]]];
            [view.navigationController pushViewController:redirectVc animated:animation];
        }
    } else {
        UIViewController *redirectVc = [self getVcByName:[pagramArray objectAtIndex:[pagramArray count]]];
        if(redirectVc) {
            [view presentViewController:redirectVc animated:animation completion:^{
            }];
        }
    }
}

-(BOOL) isMenu:(NSString *)name
{
    NSMutableDictionary *dic = [self getObjectByName:name];
    if([[dic valueForKey:@"isMenu"] boolValue]) {
        return YES;
    }
    return NO;
}

-(NSInteger) menuIndex:(NSString *)name
{
    NSMutableDictionary *dic = [self getObjectByName:name];
    if([dic valueForKey:@"menuIndex"]) {
        return [[dic valueForKey:@"menuIndex"] integerValue];
    }
    return 0;
}
@end
