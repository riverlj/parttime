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

@interface BaseTabbarViewController ()<UITabBarControllerDelegate>

@end

@implementation BaseTabbarViewController
{
    UIButton *button;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self setViewController];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
}

-(void)setViewController
{
//    self.tabBar.barTintColor = MakeColor(32, 102, 208);

    
    MyViewController *myVC = [[MyViewController alloc] init];
    UINavigationController *myNAVI = [[UINavigationController alloc] initWithRootViewController:myVC];
    myNAVI.tabBarItem.title = @"我的";
    [myNAVI.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MakeColor(133, 133, 133),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    UIColor *titleHighlightedColor = MakeColor(69, 128, 250);
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, UITextAttributeTextColor,
                                                       nil] forState:UIControlStateSelected];

    myNAVI.tabBarItem.image = [[UIImage imageNamed:@"我"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myNAVI.tabBarItem.selectedImage = [[UIImage imageNamed:@"我的"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myNAVI.navigationController.navigationBar.translucent = NO;
    
    HomePageViewController *homeVC = [[HomePageViewController alloc] init];
    UINavigationController *homeNAVI = [[UINavigationController alloc] initWithRootViewController:homeVC];
    homeNAVI.tabBarItem.title = @"首页";
    
    [homeNAVI.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MakeColor(133, 133, 133),NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    homeNAVI.tabBarItem.image = [[UIImage imageNamed:@"wshouye"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    homeNAVI.tabBarItem.selectedImage = [[UIImage imageNamed:@"shouye"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    TeamViewController *teamVC = [[TeamViewController alloc] init];
    UINavigationController *teamNAVI = [[UINavigationController alloc] initWithRootViewController:teamVC];
//    teamNAVI.tabBarItem.title = @"团队";
//    [teamNAVI.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
//    teamNAVI.tabBarItem.image = [[UIImage imageNamed:@"团队"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    teamNAVI.tabBarItem.selectedImage = [[UIImage imageNamed:@"tuanduiSelect"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];


    //中间的圆形
    [self addCenterButtonWithImage:[UIImage imageNamed:@"去送餐2x"] selectedImage:[UIImage imageNamed:@"去送餐2x"]];
    
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    NSLog(@"app.count = %d",app.count);
    if (app.count == 3) {
        self.viewControllers = @[homeNAVI,teamNAVI,myNAVI];

    }else{
        Part_timeTaskVC *taskVC = [[Part_timeTaskVC alloc] init];
        UINavigationController *taskNAVI = [[UINavigationController alloc] initWithRootViewController:taskVC];
        taskNAVI.tabBarItem.title = @"任务";
        
        [taskNAVI.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
        taskNAVI.tabBarItem.image = [[UIImage imageNamed:@"任务"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        taskNAVI.tabBarItem.selectedImage = [[UIImage imageNamed:@"renwu"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

        self.viewControllers = @[homeNAVI,myNAVI];

    }

}
//添加中间圆形btn
-(void) addCenterButtonWithImage:(UIImage*)buttonImage selectedImage:(UIImage*)selectedImage
{
    button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.tag = 101010;
    [button addTarget:self action:@selector(pressChange:) forControlEvents:UIControlEventTouchUpInside];
    button.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin;
    
    //  设定button大小为适应图片
    button.frame = CGRectMake(0.0, 0.0, 65, 65);
    [button setImage:buttonImage forState:UIControlStateNormal];
    [button setImage:selectedImage forState:UIControlStateSelected];
    
    //  这个比较恶心  去掉选中button时候的阴影
    button.adjustsImageWhenHighlighted=NO;
    
    
    /*
     *  核心代码：设置button的center 和 tabBar的 center 做对齐操作， 同时做出相对的上浮
     */
    CGFloat heightDifference = buttonImage.size.height - self.tabBar.frame.size.height;
    if (heightDifference < 0){
//        button.center = self.tabBar.center;
        button.center = CGPointMake(self.tabBar.center.x, self.tabBar.center.y+20);
    }
    else
    {
        CGPoint center = self.tabBar.center;
        center.y = center.y - heightDifference/2.0+15;
        button.center = center;
    }
    
    [self.view addSubview:button];
}

//-(void)viewWillDisappear:(BOOL)animated
//{
//    [button removeFromSuperview];
//}

-(void)pressChange:(id)sender
{
    TeamViewController *teamVC = [[TeamViewController alloc] init];
    [self presentViewController:teamVC animated:YES completion:nil];
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
