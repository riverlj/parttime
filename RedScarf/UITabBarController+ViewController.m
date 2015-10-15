//
//  UITabBarController+ViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "UITabBarController+ViewController.h"

@implementation UITabBarController (ViewController)

- (UITabBarController *)tabbarController
{
    UIResponder *next = self.nextResponder;
    
    do {
        //判断响应者是否为视图控制器
        if ([next isKindOfClass:[UITabBarController class]]) {
            return (UITabBarController *)next;
        }
        
        next = next.nextResponder;
        
    } while (next != nil);
    
    return nil;
}

@end
