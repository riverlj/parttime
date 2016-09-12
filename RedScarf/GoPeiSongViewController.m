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
    disTableView = [[DistributionTableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth-64)];
    [self.view addSubview:disTableView];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self comeBack:nil];
    self.title = @"开始配送";
    [self initTableView];
}

-(void)initTableView
{
    disTableView = [[DistributionTableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
    [self.view addSubview:disTableView];
}

@end
