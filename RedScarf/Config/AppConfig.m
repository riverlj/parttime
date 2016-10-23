//
//  AppConfig.m
//  RedScarf
//
//  Created by 李江 on 16/10/21.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "AppConfig.h"

@implementation AppConfig
+ (AppDelegate *)getAPPDelegate
{
    AppDelegate *delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return delegate;
}
@end
