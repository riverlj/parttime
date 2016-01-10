//
//  BaseTabbarViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseTabbarViewController.h"
#import "MyViewController.h"
#import "TeamViewController.h"
#import "Header.h"
#import "AppDelegate.h"
#import "HomePageViewController.h"
#import "UITabBarController+ViewController.h"
#import "GoPeiSongViewController.h"

@interface BaseTabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    [self setHidesBottomBarWhenPushed:YES];
    [self setViewController];
}

-(void)setViewController
{
    
    MyViewController *myVC = [[MyViewController alloc] init];
    UINavigationController *myNAVI = [[UINavigationController alloc] initWithRootViewController:myVC];
    myNAVI.tabBarItem.title = @"我的";
    [myNAVI.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MakeColor(133, 133, 133),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    UIColor *titleHighlightedColor = MakeColor(69, 128, 250);
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];

    myNAVI.tabBarItem.image = [[UIImage imageNamed:@"newwgeren"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myNAVI.tabBarItem.selectedImage = [[UIImage imageNamed:@"newgeren"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myNAVI.navigationController.navigationBar.translucent = NO;
    
    HomePageViewController *homeVC = [[HomePageViewController alloc] init];
    UINavigationController *homeNAVI = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNAVI.tabBarItem.title = @"首页";
    
    [homeNAVI.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MakeColor(133, 133, 133),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    homeNAVI.tabBarItem.image = [[UIImage imageNamed:@"newwshouye"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNAVI.tabBarItem.selectedImage = [[UIImage imageNamed:@"newshouye"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[homeNAVI, myNAVI];
    [self.view addSubview:self.btn];
}

-(UIButton *) btn
{
    if(_btn) {
        return _btn;
    }
    //圆形
    _btn = [[UIButton alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-25, kUIScreenHeigth-80, 60, 60)];
    _btn.layer.cornerRadius = 30;
    [_btn setBackgroundImage:[UIImage imageNamed:@"去送餐2x"] forState:UIControlStateNormal];
    _btn.layer.masksToBounds = YES;
    [_btn addTarget:self action:@selector(pressChange:) forControlEvents:UIControlEventTouchUpInside];
    return _btn;
}

-(void)pressChange:(id)sender
{
    GoPeiSongViewController *goVC = [[GoPeiSongViewController alloc] init];
    [[self selectedViewController] pushViewController:goVC animated:YES];
}

@end
