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

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:101010].hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgcolor;
    titleArray = [NSMutableArray arrayWithObjects:@"任务分配",@"分餐点",@"历史任务",@"管理成员",@"查看排班",@"我的推广", nil];
    imageArray = [NSArray arrayWithObjects:@"rwfp@2x",@"fencan@2x",@"lishi@2x",@"guanlichengyuan@2x",@"ckpaiban@2x",@"tuiguang2x", nil];
    array = [NSArray arrayWithObjects:@"banner", nil];
    self.title = @"首页";
    [self initHomeView];
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

    
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 3; j++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.tag = 100*i+j;
            [btn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
            btn.frame = CGRectMake(kUIScreenWidth/3*j, i*110+150+64, kUIScreenWidth/3, 120);
            [self.view addSubview:btn];
            UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kUIScreenWidth/3*j, 150+64, 1, 240)];
            line.backgroundColor = color232;
            [self.view addSubview:line];
            
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 214+j*120, kUIScreenWidth, 1)];
            lineView.backgroundColor = color232;
            [self.view addSubview:lineView];
            
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width/2-20, 40, 40, 40)];
            [btn addSubview:image];
            
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/3*j, btn.frame.size.height+btn.frame.origin.y-40, kUIScreenWidth/3, 35)];
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
            [self.view addSubview:titleLabel];
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
