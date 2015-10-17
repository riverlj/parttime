//
//  GoPeiSongViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "GoPeiSongViewController.h"
#import "DistributionTableView.h"

@interface GoPeiSongViewController ()

@end

@implementation GoPeiSongViewController
{
    DistributionTableView *disTableView;
}


-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
    [self comeBack:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:22022].hidden = NO;
    [self.tabBarController.view viewWithTag:11011].hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"开始配送";
    [self initTableView];
}

-(void)initTableView
{
    disTableView = [[DistributionTableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
    [self.view addSubview:disTableView];
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
