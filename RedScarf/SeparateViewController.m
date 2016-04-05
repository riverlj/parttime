//
//  SeparateViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "SeparateViewController.h"
#import "GoPeiSongViewController.h"
#import "SeparateTableViewCell.h"
#import "RSAccountModel.h"
#import "RSRadioGroup.h"
#import "RSSubTitleView.h"
#import "RSTaskModel.h"

@interface SeparateViewController ()

@end

@implementation SeparateViewController
{
    RSAccountModel *account;
    
    RSRadioGroup *group;
    NSArray *btnArr;
}

-(UIView *)titleView
{
    if(_titleView) {
        return _titleView;
    }
    _titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 40)];
    _titleView.backgroundColor = [UIColor whiteColor];

    _titleView.layer.borderColor = color_gray_e8e8e8.CGColor;
    _titleView.layer.borderWidth = 1.0;
    group = [[RSRadioGroup alloc] init];
    
    NSInteger i = 0;
    for (NSDictionary *dic in btnArr) {
        RSSubTitleView *title = [[RSSubTitleView alloc] initWithFrame:CGRectMake(0, 0, _titleView.width/[btnArr count], _titleView.height)];
        title.left = i*title.width;
        [title setTitle:[dic valueForKey:@"title"] forState:UIControlStateNormal];
        [title addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        title.tag = i;
        [_titleView addSubview:title];
        [group addObj:title];
        if(i == 0) {
            [self didClickBtn:title];
        }
        i ++;
    }
    return _titleView;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.title = @"分餐点";
    [self.tips setTitle:@"暂时没有餐品哦〜" withImg:@"meiyoucanpin"];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    account = [RSAccountModel sharedAccount];
    
    NSMutableDictionary *schoolDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"学校详情", @"title", @"/task/distPointMeals", @"url", @"0", @"refresh", @"1", @"pageNum", [NSMutableArray array], @"models", nil];
    NSMutableDictionary *personDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"个人取餐", @"title", @"/task/assignedTask/content/v2", @"url", @"1", @"refresh", @"1", @"pageNum", [NSMutableArray array], @"models", nil];
   
    if([account isCEO]) {
        btnArr = [NSArray arrayWithObjects:schoolDic, personDic, nil];
    } else {
        btnArr = [NSArray arrayWithObjects:personDic, nil];
    }
    
    if([account isCEO]) {
        if(![self.titleView superview]) {
            [self.view addSubview:self.titleView];
            self.tableView.top = self.titleView.height ;
            self.tableView.height = kUIScreenHeigth - self.titleView.height;
        }
    } else {
        if([self.titleView superview]) {
            [self.titleView removeFromSuperview];
            self.tableView.frame = self.view.bounds;
        }
    }
}

-(void) beforeHttpRequest
{
    [super beforeHttpRequest];
    [self hidHUD];
    [self showHUD:@"加载中"];
}

-(void) afterProcessHttpData:(NSInteger)before afterCount:(NSInteger)after
{
    [super afterProcessHttpData:before afterCount:after];
    [[btnArr objectAtIndex:[group selectedIndex]] setValue:self.models forKey:@"models"];
    [[btnArr objectAtIndex:[group selectedIndex]] setValue:[NSString stringWithFormat:@"%ld", self.pageNum] forKey:@"pageNum"];
}

-(void)didClickBtn:(id)sender
{
    if([sender isKindOfClass:[RSSubTitleView class]]) {
        RSSubTitleView *title = (RSSubTitleView *) sender;
        [group setSelectedIndex:title.tag];
        self.url = [[btnArr objectAtIndex:title.tag] valueForKey:@"url"];
        self.useFooterRefresh = [[[btnArr objectAtIndex:title.tag] valueForKey:@"refresh"] boolValue];
        self.useHeaderRefresh = YES;
        self.models = [[btnArr objectAtIndex:title.tag] valueForKey:@"models"];
        self.pageNum = [[[btnArr objectAtIndex:title.tag] valueForKey:@"pageNum"] integerValue];
        if([self.models count] == 0) {
            self.pageNum = 1;
            [self beginHttpRequest];
        }
        if(title.tag == 1) {
            self.tableView.tableFooterView = self.footView;
        } else {
            self.tableView.tableFooterView = [UIView new];
        }
        if (![account isCEO]) {
            self.tableView.tableFooterView = self.footView;
        }
        [self.tips removeFromSuperview];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    return cell.height;
}

//http成功返回时
-(void) afterHttpSuccess:(NSDictionary *)data
{
    id taskData = [data objectForKey:@"body"];
    if([taskData isKindOfClass:[NSDictionary class]] && [taskData objectForKey:@"date"]) {
        for (NSDictionary *dic in [taskData objectForKey:@"list"]) {
            NSError *error ;
            RSDistributionTaskModel *model = [MTLJSONAdapter modelOfClass:[RSDistributionTaskModel class] fromJSONDictionary:dic error:&error];
            if([model.tasks count] > 0) {
                [model addHeader];
                [self.models addObject:model];
            }
        }
    } else {
        for (NSDictionary *dic in taskData) {
            RSAssignedTaskModel *model = [MTLJSONAdapter modelOfClass:[RSAssignedTaskModel class] fromJSONDictionary:dic error:nil];
            if([model.tasks count]>0) {
                [model addHeader];
                [self.models addObject:model];
            }
        }
    }
}

-(UIView *)footView
{
    if(_footView) {
        return _footView;
    }
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 75, 149)];
    _footView.centerX = kUIScreenWidth/2;
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 54, _footView.width, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.font  =textFont12;
    label.textColor = color155;
    label.text = @"早餐领完?";
    [_footView addSubview:label];
    
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, label.bottom + 5, 75, 75)];
    image.backgroundColor = MakeColor(195, 224, 250);
    image.layer.cornerRadius = 37;
    image.layer.masksToBounds = YES;
    [_footView addSubview:image];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn addTarget:self action:@selector(didClickPeiSong) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"qusongcan2" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(2.5, label.bottom + 7.5, 70, 70);
    [btn setBackgroundImage:[UIImage imageNamed:@"qupeisong2x"] forState:UIControlStateNormal];
    [_footView addSubview:btn];
    return _footView;
}

-(void)didClickPeiSong
{
    GoPeiSongViewController *goPeiSongVC = [[GoPeiSongViewController alloc] init];
    [[BaiduMobStat defaultStat] logEvent:@"qusongcan2" eventLabel:@"button2"];
    
    [self.navigationController pushViewController:goPeiSongVC animated:YES];
}
@end
