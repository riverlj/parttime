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

@interface MyViewController ()
{
    NSArray *cellArr;
    NSArray *imageArr;
    NSMutableDictionary *infoDic;
    UIImageView *headImage;
    MyprofileModel *clearModel;
}

@end

@implementation MyViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //改变navigationbar的颜色
    self.navigationController.navigationBar.barTintColor = MakeColor(26, 30, 37);
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self.tableView reloadData];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.navigationController.navigationBarHidden = YES;
    self.tableView.top = -20;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    self.navigationController.navigationBarHidden = NO;
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
}

-(UIStatusBarStyle) preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(BOOL) prefersStatusBarHidden
{
    return NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    infoDic = [NSMutableDictionary dictionary];
    cellArr = [NSArray arrayWithObjects:@"配送时间",@"配送范围", nil];
    imageArr = [NSArray arrayWithObjects:@"time",@"anwei", nil];
    [self getMessage];
    [self initTableView];
    [self getUserStatus];
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

-(void) getUserStatus
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [RSHttp requestWithURL:@"/user/identification" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSInteger status = [[[data valueForKey:@"msg"] valueForKey:@"identificationStatus"] integerValue];
        //判断status
        for(NSArray *arr in self.models) {
            for(MyprofileModel *model in arr) {
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
    
    NSMutableArray *innerItems1 = [NSMutableArray array];
    MyprofileModel *model = [[MyprofileModel alloc] initWithTitle:@"我的" icon:@"test" vcName:@"PersonMsgViewController"];
    model.cellHeight = 170 + 64;
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
    model = [[MyprofileModel alloc] initWithTitle:@"实名认证" icon:@"user_certify" vcName:@"UserCertViewController"];
    [innerItems4 addObject:model];
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
    NSInteger size = [[SDImageCache sharedImageCache] getSize];
    model = [[MyprofileModel alloc] initWithTitle:@"清除缓存" icon:@"icon_clearmem" vcName:@""];
    model.subtitle = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%0.2fM", 1.0*size/1000000] attributes:[NSDictionary dictionaryWithObjectsAndKeys:color_black_666666, NSForegroundColorAttributeName, textFont15, NSFontAttributeName, nil]];
    [innerItems5 addObject:model];
    [model setSelectAction:@selector(clearCache:) target:self];
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
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
}

//清空缓存
-(void) clearCache:(MyprofileModel *)model
{
    if([model isKindOfClass:[MyprofileModel class]]) {
        clearModel = (MyprofileModel *)model;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你确定要清空缓存？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1) {
        [[SDImageCache sharedImageCache] clearDisk];
        [self showToast:@"清理成功"];
        if(clearModel) {
            clearModel.subtitle = [[NSAttributedString alloc]initWithString:@"0M" attributes:[NSDictionary dictionaryWithObjectsAndKeys:color_black_666666, NSForegroundColorAttributeName, textFont15, NSFontAttributeName, nil]];
            [self.tableView reloadData];
        }
    }
}
@end

