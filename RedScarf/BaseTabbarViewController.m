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
#import "TaskViewController.h"
#import "Header.h"
#import "AppDelegate.h"
#import "Part-timeTaskVC.h"
#import "HomePageViewController.h"
#import "UITabBarController+ViewController.h"

@interface BaseTabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabbarViewController


-(void)viewWillAppear:(BOOL)animated
{
    [self setViewController];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    self.tabBar.tintColor = [UIColor blackColor];

    self.delegate = self;
}

-(void)setViewController
{
    
    MyViewController *myVC = [[MyViewController alloc] init];
    UINavigationController *myNAVI = [[UINavigationController alloc] initWithRootViewController:myVC];
    myNAVI.tabBarItem.title = @"我的";
    [myNAVI.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MakeColor(133, 133, 133),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    UIColor *titleHighlightedColor = MakeColor(69, 128, 250);
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor,
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
    self.viewControllers = @[homeNAVI,myNAVI];

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
