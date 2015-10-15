//
//  HomePageViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/9.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "HomePageViewController.h"
#import "TaskViewController.h"
#import "FinishViewController.h"
#import "TeamMembersViewController.h"
#import "CheckTaskViewController.h"
#import "PromotionViewController.h"
#import "TeamViewController.h"
#import "AllocatingTaskVC.h"
#import "GoPeiSongViewController.h"
#import "SeparateViewController.h"
#import "OrderRangeViewController.h"
#import "OrderTimeViewController.h"

@interface HomePageViewController ()

@end

@implementation HomePageViewController
{
    NSMutableArray *titleArray;
    NSArray *imageArray;
    NSArray *array;
    UIPageControl *control;
    UIScrollView *scroll;
}

-(void)viewWillDisappear:(BOOL)animated
{
//    [self.tabBarController.view viewWithTag:11011].hidden = YES;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:11011].hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgcolor;
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    if ([app.count containsString:@"8"]) {
        titleArray = [NSMutableArray arrayWithObjects:@"任务分配",@"分餐点",@"历史任务",@"管理成员",@"查看排班",@"我的推广", nil];
        imageArray = [NSArray arrayWithObjects:@"rwfp@2x",@"fencan@2x",@"lishi@2x",@"guanlichengyuan@2x",@"ckpaiban@2x",@"tuiguang2x", nil];
    }else{
        titleArray = [NSMutableArray arrayWithObjects:@"分餐点",@"历史任务",@"配送时间",@"配送范围",@"我的推广",@"敬请期待", nil];
        imageArray = [NSArray arrayWithObjects:@"fencan@2x",@"lishi@2x",@"shijian2x",@"fanwei2x",@"tuiguang2x",@"qidai2x", nil];
    }

    array = [NSArray arrayWithObjects:@"banner", nil];
    self.title = @"首页";
    //圆形
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-25, kUIScreenHeigth-80, 60, 60)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(pressChange:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 30;
    btn.tag = 11011;
    [btn setBackgroundImage:[UIImage imageNamed:@"去送餐2x"] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    [self.tabBarController.view addSubview:btn];
    
    [self initHomeView];
}

-(void)pressChange:(id)sender
{
    GoPeiSongViewController *goVC = [[GoPeiSongViewController alloc] init];
    [self.navigationController pushViewController:goVC animated:YES];
    
}

-(void)initHomeView
{
    
    scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 150)];
    scroll.scrollEnabled = YES;
    scroll.userInteractionEnabled = YES;
    scroll.contentSize = CGSizeMake(kUIScreenWidth*array.count, 100);
//    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //循环  一张图片先不放
    control = [[UIPageControl alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-50, 110, 100, 30)];
    [self.view addSubview:control];
    control.backgroundColor = [UIColor redColor];
    control.currentPage=0;
    control.numberOfPages = array.count;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer) userInfo:nil repeats:YES];

//    scroll.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scroll];
    for (int i = 0; i<[array count]; i++) {
        CGRect frame;
        frame.origin.x = scroll.frame.size.width*i;
        frame.origin.y = 0;
        frame.size = scroll.frame.size;
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:frame];
        view.image = [UIImage imageNamed:array[i]];
        [scroll addSubview:view];
        //        controll.currentPage = i;
        //        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
        
    }
    
    int wight;
    int imageY;
    if (kUIScreenWidth == 320) {
        wight = 100;
        imageY = 25;
    }else{
        wight = 120;
        imageY = 35;
    }

    UIScrollView *listScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 214, kUIScreenWidth, kUIScreenHeigth-214)];
    listScroll.userInteractionEnabled = YES;
//    listScroll.scrollEnabled = YES;
    listScroll.contentSize = CGSizeMake(0, (kUIScreenHeigth-214)*1.2);
    [self.view addSubview:listScroll];
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.tag = 100*i+j;
            if ([app.count containsString:@"8"]) {
                [btn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
            }else{
                [btn addTarget:self action:@selector(didClickPartTime:) forControlEvents:UIControlEventTouchUpInside];
            }
            
            btn.frame = CGRectMake(kUIScreenWidth/3*j, i*wight, kUIScreenWidth/3, wight);
            [listScroll addSubview:btn];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kUIScreenWidth/3*j, 0, 1, wight*2)];
            line.backgroundColor = color232;
            [listScroll addSubview:line];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, j*wight, kUIScreenWidth, 1)];
            lineView.backgroundColor = color232;
            [listScroll addSubview:lineView];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width/2-20, imageY, 40, 40)];
            [btn addSubview:image];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/3*j, btn.frame.size.height+btn.frame.origin.y-35, kUIScreenWidth/3, 35)];
            if (i == 0) {
                titleLabel.text = titleArray[j];
                image.image = [UIImage imageNamed:imageArray[j]];
            }
            if (i == 1) {
                titleLabel.text = titleArray[j+3];
                image.image = [UIImage imageNamed:imageArray[j+3]];
            }
            titleLabel.font = textFont14;
            titleLabel.textColor = color155;
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [listScroll addSubview:titleLabel];
        }
        
    }
    
}

-(void)timer
{
    if (control.currentPage== array.count-1) {
        control.currentPage=0;
        //        [UIView animateWithDuration:1.0 animations:^{
        CGPoint offset = CGPointMake(kUIScreenWidth*control.currentPage, -64);
        [scroll setContentOffset:offset animated:NO];
        //        }];
        
        
        
    }else{
        control.currentPage+=1;
        CGPoint offset = CGPointMake(kUIScreenWidth*control.currentPage, -64);
        [scroll setContentOffset:offset animated:NO];
        
    }
}

-(void)didClickPartTime:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"btn.tag = %ld",(long)btn.tag);
    if (btn.tag == 0) {
        
    }
    switch (btn.tag) {
        case 0:
        {
            SeparateViewController *separateVC = [[SeparateViewController alloc] init];
            [self.navigationController pushViewController:separateVC animated:YES];
        }
            break;
        case 1:
        {
            FinishViewController *finishVC = [[FinishViewController alloc] init];
            [self.navigationController pushViewController:finishVC animated:YES];
        }
            break;
        case 2:
        {
            
            OrderTimeViewController *orderTimeVC = [[OrderTimeViewController alloc] init];
//            NSMutableDictionary *userInfo = [infoDic objectForKey:@"userInfo"];
//            orderTimeVC.username = [userInfo objectForKey:@"username"];
            [self.navigationController pushViewController:orderTimeVC animated:YES];
            
        }
            break;
        case 100:
        {
            OrderRangeViewController *orderRangeVC = [[OrderRangeViewController alloc] init];
            [self.navigationController pushViewController:orderRangeVC animated:YES];
        }
            break;
        case 101:
        {
            PromotionViewController *promotionVC = [[PromotionViewController alloc] init];
            [self.navigationController pushViewController:promotionVC animated:YES];
        }
            break;
        case 102:
        {
            
        }
            break;
            
        default:
            break;
    }

}

-(void)didClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"btn.tag = %ld",(long)btn.tag);
    if (btn.tag == 0) {
        
    }
    switch (btn.tag) {
        case 0:
        {
            TaskViewController *taskVC = [[TaskViewController alloc] init];
            [self.navigationController pushViewController:taskVC animated:YES];
        }
            break;
        case 1:
        {
            SeparateViewController *separateVC = [[SeparateViewController alloc] init];
            [self.navigationController pushViewController:separateVC animated:YES];
        }
            break;
        case 2:
        {
            
            FinishViewController *finishVC = [[FinishViewController alloc] init];
            [self.navigationController pushViewController:finishVC animated:YES];

        }
            break;
        case 100:
        {
            TeamMembersViewController *teamMemberVC = [[TeamMembersViewController alloc] init];
            [self.navigationController pushViewController:teamMemberVC animated:YES];
        }
            break;
        case 101:
        {
            CheckTaskViewController *checkTaskVC = [[CheckTaskViewController alloc] init];
            [self.navigationController pushViewController:checkTaskVC animated:YES];
        }
            break;
        case 102:
        {
            PromotionViewController *promotionVC = [[PromotionViewController alloc] init];
            [self.navigationController pushViewController:promotionVC animated:YES];
        }
            break;
            
        default:
            break;
    }
    
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
