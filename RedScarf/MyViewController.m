//
//  MyViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "MyViewController.h"
#import "Header.h"
#import "PromotionViewController.h"
#import "MoneyOfMonth.h"
#import "Model.h"
#import "MyBankCardVC.h"
#import "SuggestionViewController.h"
#import "OrderTimeViewController.h"
#import "OrderRangeViewController.h"
#import "PersonMsgViewController.h"
#import "GoPeiSongViewController.h"
#import "WalletViewController.h"
#import "VersionViewController.h"
#import "LevelViewController.h"
#import "RSAccountModel.h"
#import "MyprofileModel.h"
#import "MyprofileCell.h"
#import "BannerViewController.h"

@interface MyViewController ()
{
    NSMutableDictionary *infoDic;
}

@end

@implementation MyViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    self.tableView.top = -20;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    infoDic = [NSMutableDictionary dictionary];
    
    [self initTableView];
    [self getMyTableData];
    [self getMessage];
}

- (void)getMyTableData{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"9" forKey:@"parentId"];
    [RSHttp requestWithURL:@"/resource/appMenu/child" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSArray *tempArray = [data objectForKey:@"body"];
        NSError *error = nil;
        for (NSDictionary *dic in tempArray) {
            MyprofileModel *model = [MTLJSONAdapter modelOfClass:[MyprofileModel class] fromJSONDictionary:dic error:&error];
            model.cellHeight = 48;
            [self.models addObject:model];
        }
        [self getUserStatus];
//        [self.tableView reloadData];
        } failure:^(NSInteger code, NSString *errmsg) {
    }];
}


-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [RSHttp requestWithURL:@"/user/info" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        infoDic = [data objectForKey:@"body"];
        NSError *error = nil;
        RSAccountModel *model = [MTLJSONAdapter modelOfClass:[RSAccountModel class] fromJSONDictionary:infoDic error:&error];
        [model save];
//        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

-(void) getUserStatus
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [RSHttp requestWithURL:@"/user/identification" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSInteger status = [[[data valueForKey:@"body"] valueForKey:@"identificationStatus"] integerValue];
        //判断status
        for(MyprofileModel *model in self.models) {
            if([model.title isEqualToString:@"实名认证"]) {
                if(status == 1) {
                    model.subtitle = [[NSAttributedString alloc]initWithString:@"待审核" attributes:[NSDictionary dictionaryWithObjectsAndKeys:color_black_666666, NSForegroundColorAttributeName, textFont15, NSFontAttributeName, nil]];
                } else if(status == 3) {
                    model.subtitle = [[NSAttributedString alloc]initWithString:@"未通过" attributes:[NSDictionary dictionaryWithObjectsAndKeys:color_red_e54545, NSForegroundColorAttributeName, textFont15, NSFontAttributeName, nil]];
                } else if(status == 2) {
                    model.subtitle = [[NSAttributedString alloc]initWithString:@"已认证" attributes:[NSDictionary dictionaryWithObjectsAndKeys:color_green_1fc15e, NSForegroundColorAttributeName, textFont15, NSFontAttributeName, nil]];
                } else {
                        model.subtitle = [[NSAttributedString alloc]initWithString:@""];
                }
            }
            
        }
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

-(void)initTableView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 100)];
    self.tableView.tableFooterView = view;
    
    self.models = [NSMutableArray array];

    MyprofileModel *model = [[MyprofileModel alloc] initWithTitle:@"我的" icon:@"test" vcName:@"PersonMsgViewController"];
    model.cellHeight = 170 + 64;
    model.cellClassName = @"HeadProfileCell";
    [self.models addObject:model];
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section < 2) {
        return 0;
    }
    return 0;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyprofileModel *model = [self.models objectAtIndex:indexPath.row];
    if(model.vcName && ![model.vcName isEqualToString:@""]) {
        UIViewController *vc = [[NSClassFromString(model.vcName) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    if(model.url && ![model.url isEqualToString:@""]) {
        if([model.url hasPrefix:@"http://"]) {
            BannerViewController *bannerVC = [[BannerViewController alloc] init];
            bannerVC.title = model.title;
            bannerVC.urlString = model.url;
            [self.navigationController pushViewController:bannerVC animated:YES];
        }
        return;
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
@end

