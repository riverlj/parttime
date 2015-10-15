//
//  AppDelegate.h
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseTabbarViewController.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property float autoSizeScaleX;
@property float autoSizeScaleY;
@property (nonatomic,strong) NSString *tocken;
@property (nonatomic,strong) NSString *status;

@property (nonatomic,assign) NSString *count;
@property (nonatomic,strong) NSMutableArray *array;

- (void)setRoorViewController:(UIViewController *)rootVC;
- (void)setViewController:(UIViewController *)rootVC;


@end

