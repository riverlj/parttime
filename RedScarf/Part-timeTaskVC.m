//
//  Part-timeTaskVC.m
//  RedScarf
//
//  Created by zhangb on 15/8/13.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "Part-timeTaskVC.h"
#import "DistributionTableView.h"
#import "Header.h"
#import "HeadDisTableView.h"
#import "FinishViewController.h"

@implementation Part_timeTaskVC
{
    int count;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = NO;
    //隐藏tabbar上的按钮
    UIButton *barBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [barBtn removeFromSuperview];
    [self initTableView];
    [self judgeRoundView];
    [self comeBack:nil];
    [super viewWillAppear:animated];
}

-(void)viewDidLoad
{
    self.title = @"待配送";
  
    self.view.backgroundColor = MakeColor(244, 245, 246);
    self.navigationController.navigationBar.hidden = NO;
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"已处理"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickFinish)];
    self.navigationItem.rightBarButtonItem = right;
    right.tintColor = [UIColor whiteColor];
//    [self initTableView];
//    [self judgeRoundView];
}

-(void)judgeRoundView
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    count = 0;
    __block int peisong;
    [RSHttp requestWithURL:@"/task/assignedTask/content" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        for (NSMutableDictionary *dic in [data objectForKey:@"msg"]) {
            peisong = [[dic objectForKey:@"count"] intValue];
            count += peisong;
            if (count) {
                UILabel *label = (UILabel *)[[self.view viewWithTag:100006] viewWithTag:100008];
                label.text = [NSString stringWithFormat:@"—总计:%d份—",count];
            }
            [self initTableView];
        }
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
    [RSHttp requestWithURL:@"/task/assignedTask/content" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        for (NSMutableDictionary *dic in [data objectForKey:@"msg"]) {
            peisong = [[dic objectForKey:@"count"] intValue];
            count += peisong;
            if (count) {
                UILabel *label = (UILabel *)[[self.view viewWithTag:100006] viewWithTag:100008];
                label.text = [NSString stringWithFormat:@"—总计:%d份—",count];
            }
            [self initTableView];
        }

    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}


-(void)initTableView
{
    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 64, kUIScreenWidth-80, kUIScreenHeigth/2-65)];
    [self.view addSubview:backgroundView];
    backgroundView.tag = 100006;
    //    backgroundView.contentMode = UIViewContentModeScaleAspectFit;
    backgroundView.image = [UIImage imageNamed:@"beijing@2x"];
    backgroundView.userInteractionEnabled = YES;
    
    HeadDisTableView *headTableView = [[HeadDisTableView alloc] initWithFrame:CGRectMake(10, 0,backgroundView.frame.size.width-30, backgroundView.frame.size.height-10)];
    headTableView.tag = 100005;
    [backgroundView addSubview:headTableView];
    
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(backgroundView.frame.size.width/2-80, backgroundView.frame.size.height-40, 160, 10)];
    countLabel.text = [NSString stringWithFormat:@"—共计:%d份—",count];
    countLabel.tag = 100008;
    countLabel.font = [UIFont systemFontOfSize:12];
    countLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:countLabel];
    
    
    DistributionTableView *disTableView = [[DistributionTableView alloc] initWithFrame:CGRectMake(0, kUIScreenHeigth/2+10, kUIScreenWidth,kUIScreenHeigth/2-10)];
    disTableView.backgroundColor = MakeColor(244, 245, 246);
    disTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:disTableView];

}

-(void)didClickFinish
{
    
    FinishViewController *finishVC = [[FinishViewController alloc] init];
    [self.navigationController pushViewController:finishVC animated:YES];
}



@end
