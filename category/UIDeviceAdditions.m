//
//  UIDeviceAdditions.m
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "UIDeviceAdditions.h"
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <ifaddrs.h>
#import <sys/utsname.h>
#import "FCUUID.h"

@implementation UIDevice(HardWare)
+(NSString *) utm_campaign
{
    return @"pttms";
}

+(NSString *) utm_source
{
    return @"inhouse";
}

+(NSString *) utm_content
{
    return [FCUUID uuidForDevice];
}

+ (NSString *)networkStatus
{
    NSString *connType = @"None";
    
    struct ifaddrs * addrs;
    const struct ifaddrs * cursor;
    
    if (!getifaddrs(&addrs)) {
        cursor = addrs;
        while (cursor != NULL) {
            // the second test keeps from picking up the loopback address
            if (cursor->ifa_addr->sa_family == AF_INET && (cursor->ifa_flags & IFF_LOOPBACK) == 0) {
                NSString *name = [NSString stringWithUTF8String:cursor->ifa_name];
                NSLog(@"%@",name);
                if ([name isEqualToString:@"en0"]) {  // Wi-Fi adapter
                    connType = @"WiFi";
                } else if ([name isEqualToString:@"lo0"] || [name isEqualToString:@"vmnet1"]) {
                    connType = @"None";
                } else {
                    connType = @"GPRS";
                }
                //break;
            }
            cursor = cursor->ifa_next;
        }
        freeifaddrs(addrs);
    }
    return connType;
}

+ (BOOL)isPad
{
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

+ (CGFloat)scale {
    if ([UIScreen instancesRespondToSelector:@selector(scale)] && [UIScreen mainScreen].scale>1.0) {
        return [UIScreen mainScreen].scale;
    }
    return 1.0f;
}

+ (BOOL)isRetina
{
    if ([UIScreen instancesRespondToSelector:@selector(scale)] && [UIScreen mainScreen].scale>1.0) {
        return YES;
    }
    return NO;
}
+ (BOOL)isSingleTask
{
    struct utsname name;
    uname(&name);
    float version = [[UIDevice currentDevice].systemVersion floatValue];//判定系统版本。
    if (version < 4.0 || strstr(name.machine, "iPod1,1") != 0 || strstr(name.machine, "iPod2,1") != 0) {
        return YES;
    } else {
        return NO;
    }
}

+ (NSString *)modelName
{
    NSMutableArray *arr = [NSMutableArray array];
    //第一参数为系统号
    [arr addObject:@"ios"];
    //第二参数为系统版本
    [arr addObject:[[UIDevice currentDevice] systemVersion]];
    //第三参数为机型
    [arr addObject:[[[UIDevice currentDevice] model]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
    return [arr componentsJoinedByString:@"|"];
}

+ (NSString *)clientVersion {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

@end
