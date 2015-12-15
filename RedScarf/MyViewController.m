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

@interface MyViewController ()
{
    NSArray *cellArr;
    NSArray *imageArr;
    NSMutableDictionary *infoDic;
    UIImageView *headImage;
}

@end

@implementation MyViewController

-(void)viewWillAppear:(BOOL)animated
{
    //改变navigationbar的颜色
    self.navigationController.navigationBar.barTintColor = MakeColor(26, 30, 37);
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.tableView reloadData];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = bgcolor;
    self.title = @"我的";
    infoDic = [NSMutableDictionary dictionary];
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    NSString *net = [self stringFromStatus:status];
    if ([net isEqualToString:@"not"]) {
        [self alertView:@"当前没有网络"];
    }
    cellArr = [NSArray arrayWithObjects:@"配送时间",@"配送范围", nil];
    imageArr = [NSArray arrayWithObjects:@"time",@"anwei", nil];
    [self getMessage];
    [self initTableView];
}


-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [RSHttp requestWithURL:@"/user/info" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        infoDic = [data objectForKey:@"msg"];
        NSError *error = nil;
        RSAccountModel *model = [MTLJSONAdapter modelOfClass:[RSAccountModel class] fromJSONDictionary:infoDic error:&error];
        [model save];
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

-(void)initTableView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 100)];
    self.tableView.tableFooterView = view;
    self.tableView.backgroundColor = bgcolor;
    
    self.models = [NSMutableArray array];
    
    NSMutableArray *innerItems1 = [NSMutableArray array];
    MyprofileModel *model = [[MyprofileModel alloc] initWithTitle:@"test" icon:@"test" vcName:@"PersonMsgViewController"];
    model.cellHeight = 170;
    model.cellClassName = @"HeadProfileCell";
    [innerItems1 addObject:model];
    [self.models addObject:innerItems1];
    
    NSMutableArray *innerItems2 = [NSMutableArray array];
    model = [[MyprofileModel alloc] initWithTitle:@"我的工资" icon:@"Wallet3x" vcName:@"MoneyOfMonth"];
    [innerItems2 addObject:model];
    model = [[MyprofileModel alloc] initWithTitle:@"红领巾钱包" icon:@"yinhang2x" vcName:@"WalletViewController"];
    [innerItems2 addObject:model];
    [self.models addObject:innerItems2];
    
    NSMutableArray *innerItems3 = [NSMutableArray array];
    model = [[MyprofileModel alloc] initWithTitle:@"等级" icon:@"rank" vcName:@"LevelViewController"];
    [innerItems3 addObject:model];
    [self.models addObject:innerItems3];
    
    NSMutableArray *innerItems4 = [NSMutableArray array];
    model = [[MyprofileModel alloc] initWithTitle:@"配送时间" icon:@"time" vcName:@"OrderTimeViewController"];
    [innerItems4 addObject:model];
    model = [[MyprofileModel alloc] initWithTitle:@"配送范围" icon:@"anwei" vcName:@"OrderRangeViewController"];
    [innerItems4 addObject:model];
    [self.models addObject:innerItems4];
    
    NSMutableArray *innerItems5 = [NSMutableArray array];
    model = [[MyprofileModel alloc] initWithTitle:@"版本管理" icon:@"banbenguanli" vcName:@"VersionViewController"];
    [innerItems5 addObject:model];
    model = [[MyprofileModel alloc] initWithTitle:@"意见反馈" icon:@"fankui2x" vcName:@"SuggestionViewController"];
    [innerItems5 addObject:model];
    [self.models addObject:innerItems5];
    self.sections = [NSMutableArray array];
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section < 2) {
        return 0;
    }
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyprofileModel *model = [[self.models objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    if(model.vcName && ![model.vcName isEqualToString:@""]) {
        UIViewController *vc = [[NSClassFromString(model.vcName) alloc] init];
        //下一个页面依赖本页面的数据，下次重构
        if([model.vcName isEqualToString:@"PersonMsgViewController"]) {
            PersonMsgViewController *personVC = (PersonMsgViewController *)vc;
            personVC.personMsgArray = [NSMutableArray array];
            NSMutableDictionary *info = [infoDic objectForKey:@"userInfo"];
            if (info) {
                personVC.headUrl =  [info objectForKey:@"url"];
                
                [personVC.personMsgArray addObject:[info objectForKey:@"realName"]];
                NSMutableDictionary *apartmentDic = [info objectForKey:@"apartment"];
                //地址
                [personVC.personMsgArray addObject:[apartmentDic objectForKey:@"name"]];
                //学校
                [personVC.personMsgArray addObject:[[apartmentDic objectForKey:@"school"] objectForKey:@"name"]];
                personVC.schoolId = [[apartmentDic objectForKey:@"school"] objectForKey:@"id"];
                
                [personVC.personMsgArray addObject:[info objectForKey:@"mobilePhone"]];
                [personVC.personMsgArray addObject:[info objectForKey:@"idCardNo"]];
                [personVC.personMsgArray addObject:[info objectForKey:@"studentIdCardNo"]];
                [personVC.personMsgArray addObject:@"密码"];
                [personVC.personMsgArray addObject:[info objectForKey:@"sex"]];
                [personVC.personMsgArray addObject:[info objectForKey:@"idCardUrl1"]];
                
                if ([info objectForKey:@"idCardUrl2"] != nil) {
                    [personVC.personMsgArray addObject:[info objectForKey:@"idCardUrl2"]];
                }else{
                    [personVC.personMsgArray addObject:@""];
                }
                
                [personVC.personMsgArray addObject:[info objectForKey:@"studentIdCardUrl1"]];
                if ([info objectForKey:@"studentIdCardUrl2"] != nil) {
                    [personVC.personMsgArray addObject:[info objectForKey:@"studentIdCardUrl2"]];
                }else{
                    [personVC.personMsgArray addObject:@""];
                }
                
                if (![[info objectForKey:@"position"] isEqualToString:@"校园兼职"]) {
                    personVC.position = @"ceo";
                }
            }
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}
@end
