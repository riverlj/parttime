//
//  DistributionVC.m
//  RedScarf
//
//  Created by zhangb on 15/8/12.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "DistributionVC.h"
#import "Header.h"
#import "DistributionCell.h"
#import "RoomViewController.h"
#import "RedScarf_API.h"
#import "Header.h"
#import "AppDelegate.h"
#import "UIUtils.h"

@implementation DistributionVC
{
    NSString *roomNum;
}

-(void)viewWillAppear:(BOOL)animated
{
    //刷新tableview
    [self getMessage];
}

-(void)viewDidLoad
{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.navigationController.navigationBar.barTintColor = MakeColor(32, 102, 208);
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.titleStr;
    self.dataArray = [NSMutableArray array];
    [self getMessage];
    [self initNavigation];
    [self initTableView];
    
}

-(void)initNavigation
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comeback"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    
    //隐藏tabbar上的按钮
    UIButton *barBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [barBtn removeFromSuperview];

}

-(void)didClickLeft
{
    [self.delegate returnNameOfTableView:@"peisong"];

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initTableView
{
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0,kUIScreenWidth , kUIScreenHeigth)];
//    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
//    self.detailTableView.rowHeight = 30;
    UIView *footView = [[UIView alloc] init];
    self.detailTableView.tableFooterView = footView;
    [self.view addSubview:self.detailTableView];
}


-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [params setObject:self.aId forKey:@"aId"];
    
    
    [RedScarf_API requestWithURL:@"/task/assignedTask/roomDetail" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            [self.dataArray removeAllObjects];
            for (NSMutableDictionary *dic in [result objectForKey:@"msg"]) {
                NSLog(@"dic = %@",dic);
                [self.dataArray addObject:dic];
                
            }
            [self.detailTableView reloadData];

        }
    }];
}

//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    if (section == 0) {
//        return 0;
//    }
//    return 10;
//}
//
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(-2, -0.4, kUIScreenWidth+4, 10)];
//    view.backgroundColor = MakeColor(240, 240, 240);
//    
//    return view;
//}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    DistributionCell *cell = (DistributionCell *)[self tableView:self.detailTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    DistributionCell *cell = [[DistributionCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.btn.layer.borderColor = [UIColor redColor].CGColor;
    cell.btn.layer.borderWidth = 1.0;
    cell.btn.layer.cornerRadius = 5;
    cell.btn.layer.masksToBounds = YES;
    [cell.btn setTitle:@"送达" forState:UIControlStateNormal];
    [cell.btn addTarget:self action:@selector(didClickSongDaBtn) forControlEvents:UIControlEventTouchUpInside];
    NSMutableDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    NSMutableArray *array = [dic objectForKey:@"content"];
//    NSMutableDictionary *foodDic = [array objectAtIndex:indexPath.row];
    NSMutableString *foodStr = @"";
    for (NSMutableDictionary *foodDic in array) {
        foodStr = [foodStr stringByAppendingFormat:@"%@ (%@)\n",[foodDic objectForKey:@"content"],[foodDic objectForKey:@"count"]];
    }
    roomNum = [dic objectForKey:@"room"];

//    dicTitle = [self.dataArray objectAtIndex:indexPath.row];
    cell.addLabel.text = [NSString stringWithFormat:@"%@  (%@)",[dic objectForKey:@"room"],[dic objectForKey:@"taskNum"]];
    [cell setIntroductionText:[NSString stringWithFormat:@"%@",foodStr]];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DistributionCell *cell = (DistributionCell *)[tableView cellForRowAtIndexPath:indexPath];
    RoomViewController *roomVC = [[RoomViewController alloc] init];
    roomVC.titleStr = cell.addLabel.text;
    roomVC.aId = self.aId;
    roomVC.sn = 
    roomVC.room = [dic objectForKey:@"room"];
    [self.navigationController pushViewController:roomVC animated:YES];
}

-(void)didClickSongDaBtn
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"取消确认" otherButtonTitles:@"确认送达", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            app.tocken = [UIUtils replaceAdd:app.tocken];
            [params setObject:app.tocken forKey:@"token"];
            [params setObject:self.aId forKey:@"aId"];
            [params setObject:roomNum forKey:@"room"];
            
            [RedScarf_API requestWithURL:@"/task/assignedTask/finishRoom" params:params httpMethod:@"PUT" block:^(id result) {
                NSLog(@"result = %@",result);
                if ([[result objectForKey:@"success"] boolValue]) {
                    [self alertView:@"成功送达"];
                    [self didClickLeft];
                }else{
                    [self alertView:[result objectForKey:@"msg"]];
                }
                [self getMessage];
                
                
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)alertView:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

@end
