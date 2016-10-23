//
//  GoPeiSongViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "GoPeiSongViewController.h"
#import "DistributionTableView.h"

#import "BuildingTaskModel.h"

@interface GoPeiSongViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation GoPeiSongViewController
{
    UITableView *_goPSTableView;
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开始配送";
    
    [self initTableView];
    
    AppSettingModel *appSettingModel = [AppConfig getAPPDelegate].appSettingModel;
    
    if (![AppConfig getAPPDelegate].appSettingModel) {
    
    }
    // 已经获取到了配置信息
//    if (appSettingModel.businesslist.count > 1) {
        //需要显示Tab
//    }else {
        //不需要显示Tab
        [BuildingTaskModel getBuildingTaskSuccess:^(NSArray *buildingTaskModels) {
           //楼栋信息
            NSLog(@"%@", buildingTaskModels);
        } failure:^{
            
        }];
        
//    }
    
}

-(void)initTableView
{
    _goPSTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _goPSTableView.delegate = self;
    _goPSTableView.dataSource = self;
    _goPSTableView.tableFooterView = [UIView new];
    
    [self.view addSubview:_goPSTableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 0;
}

@end
