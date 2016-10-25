//
//  GoPeiSongViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "GoPeiSongViewController.h"
#import "DistributionTableView.h"

#import "roomTaskCell.h"
#import "BuildingTaskModel.h"
#import "RSRadioGroup.h"
#import "RSSubTitleView.h"

@interface GoPeiSongViewController ()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation GoPeiSongViewController
{
    UITableView *_goPSTableView;
    NSMutableArray *_dataSource;
    NSMutableArray *_sectionDataSource;
    __weak GoPeiSongViewController *_selfWeak;
    NSInteger _selectedSection;
    
    NSArray *_businesslist;
    RSRadioGroup *group;
    
    AppBusiness *_selectedAppBusiness;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"开始配送";
    _selectedSection = -1;
    _selfWeak = self;
    
    [self initTableView];
    
    _dataSource = [[NSMutableArray alloc] init];
    _sectionDataSource = [[NSMutableArray alloc] init];
    
    AppSettingModel *appSettingModel = [AppConfig getAPPDelegate].appSettingModel;
    _businesslist = appSettingModel.businesslist;
    if (![AppConfig getAPPDelegate].appSettingModel.businesslist ) {
        [[RSToastView shareRSToastView] showToast:@"获取配置信息失败"];
    }
    
    // 已经获取到了配置信息
    if (appSettingModel.businesslist.count > 1) {
        //需要显示Tab
        [self setTypeTitle];
        _selectedAppBusiness = _businesslist[0];
        [self getBuildingTaskInfo:[NSString stringWithFormat:@"%@",_selectedAppBusiness.type]];
        _goPSTableView.y = 40;
        
    }else {
        //不需要显示Tab
        _selectedAppBusiness = _businesslist[0];
        [self getBuildingTaskInfo:[NSString stringWithFormat:@"%@",_selectedAppBusiness.type]];
        
    }
}

-(void)initTableView
{
    _goPSTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _goPSTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _goPSTableView.delegate = self;
    _goPSTableView.dataSource = self;
    _goPSTableView.tableFooterView = [UIView new];
    
    [self.view addSubview:_goPSTableView];
}

/**
 *
 *  设置标题，配送类型
 **/
- (void)setTypeTitle {
    NSMutableArray *_btnArray = [NSMutableArray array];
    for (int i=0; i<_businesslist.count; i++) {
        AppBusiness *appBusiness = _businesslist[i];
        NSDictionary *btn1 = @{
                               @"title":appBusiness.name,
                               @"key":appBusiness.type,
                               @"models":[NSMutableArray array]
                               };
        [_btnArray addObject:btn1];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.layer.borderColor = RS_Line_Color.CGColor;
    view.layer.borderWidth = 1.0;
    group = [[RSRadioGroup alloc] init];
    
    for (int i=0; i<_btnArray.count; i++) {
        NSDictionary *dic = _btnArray[i];
        
        RSSubTitleView *title = [[RSSubTitleView alloc] initWithFrame:CGRectMake(0, 0, self.view.width/[_btnArray count], view.height)];;
        title.titleLabel.font = textFont14;
        title.left = i*title.width;
        title.tag = i;
        title.key = [dic valueForKey:@"key"];
        
        [title setTitle:[dic valueForKey:@"title"] forState:UIControlStateNormal];
        [title addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:title];
        [group addObj:title];
    }
    [group setSelectedIndex:0];
}

/**
 *
 *  根据类型获取楼栋信息
 **/
- (void)getBuildingTaskInfo:(NSString *) typeid {
    
    NSDictionary *params = @{
                             @"type" : typeid
                             };
    [BuildingTaskModel getBuildingTask:params success:^(NSArray *buildingTaskModels) {
        
        if (buildingTaskModels.count == 0) {
            //空数据
            [[RSToastView shareRSToastView] showToast:@"暂无配送任务"];
            return;
        }
        
        //楼栋信息
        for (int i=0; i<buildingTaskModels.count; i++) {
            BuildingTaskModel *buildingTaskModel = buildingTaskModels[i];
            [_sectionDataSource addObject:buildingTaskModel];
            
            [_dataSource addObject:[NSMutableArray array]];
        }
        [_goPSTableView reloadData];
        
        BuildingTaskModel *buildingTaskModel = buildingTaskModels[0];
        buildingTaskModel.isSelected = YES;
        _selectedSection = 0;
        [_selfWeak getRoomInfo:buildingTaskModel.apartmentId];
        
    } failure:^{}];
    
}

/**
 *
 *  获取楼栋下的寝室信息
 **/
-(void)getRoomInfo:(NSString *)roomid{
    
    NSDictionary *params = @{
                          @"aId" : roomid,
                          @"type" : _selectedAppBusiness.type
                          };
    
    [RoomTaskModel getRoomTask:params success:^(NSArray *roomTaskModels) {
        NSMutableArray *mArray = _dataSource[_selectedSection];
        for (int i=0; i<roomTaskModels.count; i++) {
            RoomTaskModel *roomTaskModel = roomTaskModels[i];
            roomTaskModel.cellClassName = @"roomTaskCell";
            [mArray addObject:roomTaskModel];
        }
        
        [_goPSTableView reloadData];
        
    } failure:^{}];
}

/*
 点击楼栋信息折叠
 */
- (void)changeSectionState:(UIGestureRecognizer*)sender {
    _selectedSection = sender.view.tag;
    BuildingTaskModel *buildingTaksModel =  _sectionDataSource[sender.view.tag];
    if (buildingTaksModel.isSelected) {
        [_dataSource[_selectedSection] removeAllObjects];
        [_goPSTableView reloadData];
    }else {
        [self getRoomInfo:buildingTaksModel.apartmentId];
    }
    buildingTaksModel.isSelected  = !buildingTaksModel.isSelected;

}

/*
 点击Hearder type 切换
 */
-(void)didClickBtn:(RSSubTitleView *)sender {
    [group setSelectedIndex:sender.tag];
    
    [_sectionDataSource removeAllObjects];
    [_dataSource removeAllObjects];
    [_goPSTableView reloadData];
    
    [self getBuildingTaskInfo:sender.key];
}

/*
  楼栋信息View
 */
-(UIView*)buildingInfoView:(BuildingTaskModel *)model withTag:(NSInteger )tag {
    
    UIView *buildingInfoView = [[UIView alloc] init];
    buildingInfoView.tag = tag;
    [buildingInfoView addTapAction:@selector(changeSectionState:) target:self];
    
    buildingInfoView.backgroundColor = [UIColor whiteColor];
    buildingInfoView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 45);
    UIImageView *icon_imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_building"]];
    icon_imageView.frame = CGRectMake(15, 0, 15, 45);
    icon_imageView.contentMode = UIViewContentModeCenter;
    [buildingInfoView addSubview:icon_imageView];
    
    UILabel *buildNameLabel = [[UILabel alloc] init];
    buildNameLabel.frame = CGRectMake(icon_imageView.right+4, 0, SCREEN_WIDTH-(icon_imageView.right+4)-60, 45);
    buildNameLabel.text = model.apartmentName;
    buildNameLabel.textColor = rs_color_222222;
    buildNameLabel.font = textFont15;
    [buildingInfoView addSubview:buildNameLabel];
    
    UIImageView *icon_imageView_down = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_building_down"]];
    icon_imageView_down.frame = CGRectMake(SCREEN_WIDTH-15-10, 0, 10, 45);
    icon_imageView_down.contentMode = UIViewContentModeCenter;
    [buildingInfoView addSubview:icon_imageView_down];
    
    UILabel *numLabel = [[UILabel alloc] init];
    numLabel.text = [NSString stringWithFormat:@"%@份", model.taskNum];
    numLabel.font = textFont12;
    numLabel.textColor = rs_color_7d7d7d;
    CGSize numSize = [numLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    numLabel.frame = CGRectMake(SCREEN_WIDTH-15-10-numSize.width-4, 0, numSize.width, 45);
    [buildingInfoView addSubview:numLabel];
    
    UIView *lineview = [RSLineView lineViewHorizontal];
    lineview.y = 45-lineview.height;
    [buildingInfoView addSubview:lineview];
    
    return buildingInfoView;
}

#pragma mark tableView 代理
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomTaskModel *model = _dataSource[indexPath.section][indexPath.row];
    return model.cellHeight;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RoomTaskModel *model = _dataSource[indexPath.section][indexPath.row];
    roomTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"roomTaskCell"];
    if (!cell) {
        cell = [[roomTaskCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"roomTaskCell"];
    }
    
    [cell setModel:model];
    
    return cell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray *array = _dataSource[section];
    return array.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    BuildingTaskModel *model = _sectionDataSource[section];
    UIView *buildView = [self buildingInfoView:model withTag:section];
    return buildView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataSource.count;
}

@end
