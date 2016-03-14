//
//  RoomViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RoomViewController.h"
#import "RoomTableViewCell.h"
#import "Header.h"
#import "UIUtils.h"
#import "AppDelegate.h"
#import "RoomMissionModel.h"

@implementation RoomViewController
{
    NSArray *reasonArr;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [super viewWillAppear:animated];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = self.titleStr;
    self.dataArray = [NSMutableArray array];
    _models = [NSMutableArray array];
    [self initTableView];
    [self initFootBtn];
    [self getMessage];
}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.aId forKey:@"aId"];
    [params setObject:self.room forKey:@"room"];
    [params setObject:@"2" forKey:@"source"];
    [RSHttp requestWithURL:@"/task/assignedTask/customerDetail" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        for (NSMutableDictionary *dic in [data objectForKey:@"body"]) {
            NSError *error = nil;
            RoomMissionModel *model = [MTLJSONAdapter modelOfClass:[RoomMissionModel class] fromJSONDictionary:dic error:&error];
            if(model) {
                [self.models addObject:model];
                model.content = [dic objectForKey:@"content"];
                model.checked = NO;
            }
        }
        [self.tableView reloadData];
        [self refreshBtn];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

-(void)initTableView
{
    self.tableView.backgroundColor = color242;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoomTableViewCell *cell = (RoomTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoomMissionModel *model = (RoomMissionModel *)[self.models objectAtIndex:indexPath.row];
    model.checked = !model.checked;
    [self.tableView reloadData];
    [self refreshBtn];
}

//刷新底下的按钮组
-(void) refreshBtn
{
    UIButton *btn = (UIButton *)[self.view viewWithTag:1234];
    UIButton *btn1 = (UIButton *)[self.view viewWithTag:2234];
    BOOL enable = NO;
    for(RoomMissionModel *model in self.models) {
        if(model.checked) {
            enable = YES;
            break;
        }
    }
    if (enable){
        [btn setEnabled: YES];
        [btn1 setEnabled:YES];
    } else {
        [btn setEnabled:NO];
        [btn1 setEnabled:NO];
    }
}

-(void)initFootBtn
{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kUIScreenHeigth-45.5, kUIScreenWidth, 0.5)];
    line.backgroundColor = MakeColor(169, 169, 169);
    [self.view addSubview:line];
    
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kUIScreenWidth/2*i, kUIScreenHeigth-45, kUIScreenWidth/2, 45)];
        [btn setTitleColor:color155 forState:UIControlStateDisabled];
        [btn setEnabled:NO];
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = textFont14;
        [self.view addSubview:btn];
        if (i == 0) {
            btn.tag = 1234;
            [btn setTitle:@"遇到问题" forState:UIControlStateNormal];
            [btn setTitleColor:colorrede5 forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didClickNotBtn) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 1) {
            btn.tag = 2234;
            [btn setTitle:@"已送达" forState:UIControlStateNormal];
            [btn setTitleColor:colorblue forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didClickDoBtn) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kUIScreenWidth/2, kUIScreenHeigth-38, 0.5, 30)];
    lineView.backgroundColor = MakeColor(169, 169, 169);
    [self.view addSubview:lineView];
    [self refreshBtn];
}

-(void)didClickDoBtn
{
    [[BaiduMobStat defaultStat] logEvent:@"已送达" eventLabel:@"button4"];
    [self alertView:@"请确认所有商品都已送到，点击后将提示用户领取"];
}

-(void)alertView:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
    return;
}

-(void)didClickNotBtn
{
    [[BaiduMobStat defaultStat] logEvent:@"遇到问题" eventLabel:@"button5"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择未送达的原因" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"餐品不够",@"送错或漏送",@"餐品腐坏",@"餐品破损",@"其它", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *reason;
    reasonArr = [NSArray arrayWithObjects:@"餐品不够",@"送错或漏送",@"餐品腐坏",@"餐品破损",@"其它", nil];
    if(buttonIndex < [reasonArr count]) {
        reason = [reasonArr objectAtIndex:buttonIndex];
        [[BaiduMobStat defaultStat] logEvent:reason eventLabel:@"button"];
    } else {
        return;
    }
    if([reason isEqualToString:@"其它"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请输入未送达的原因" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView setAlertViewStyle:UIAlertViewStylePlainTextInput];
        alertView.tag =1;
        [alertView show];
    } else {
        [self sendUndeliverReason:reason];
    }
}

-(void) sendUndeliverReason:(NSString *) reason
{
    if([reason isEqualToString:@""]) {
        [self showToast:@"未送达原因不能为空"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:reason forKey:@"reason"];
    NSMutableArray *tempArr = [NSMutableArray array];
    NSString *sns = @"";
    for(RoomMissionModel *model in self.models) {
        if(model.checked) {
            [tempArr addObject:model];
            sns = [sns append:[NSString stringWithFormat:@"%@,", model.snid]];
        }
    }
    [params setObject:sns forKey:@"sns"];
    [self showHUD:@"处理中"];
    [RSHttp requestWithURL:@"/task/assignedTask/batchUndelivereReason" params:params httpMethod:@"PUT" success:^(NSDictionary *data) {
        [self hidHUD];
        for(RoomMissionModel *model in tempArr) {
            [self.models removeObject:model];
        }
        [self.tableView reloadData];
        [self refreshBtn];
        [self showToast:@"发送成功"];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self showToast:errmsg];
    }];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(!alertView.tag && buttonIndex == 0) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"2" forKey:@"source"];
        NSMutableArray *tempArr = [NSMutableArray array];
        NSString *sns = @"";
        for(RoomMissionModel *model in self.models) {
            if(model.checked) {
                [tempArr addObject:model];
                sns = [sns append:[NSString stringWithFormat:@"%@,", model.snid]];
            }
        }
        [params setObject:sns forKey:@"sns"];
        [self showHUD:@"送达中"];
        [RSHttp requestWithURL:@"/task/assignedTask/batchFinish" params:params httpMethod:@"PUT" success:^(NSDictionary *data){
            [self hidHUD];
            for(RoomMissionModel *model in tempArr) {
                [self.models removeObject:model];
            }
            [self.tableView reloadData];
            [self refreshBtn];
            [self showToast:@"提交成功"];
        } failure:^(NSInteger code, NSString *errmsg) {
            [self hidHUD];
            [self showToast:errmsg];
        }];
    }
    if(alertView.tag == 1 && buttonIndex == 1) {
        UITextField *textField = [alertView textFieldAtIndex:0];
        NSString *reason = textField.text;
        [self sendUndeliverReason:reason];
    }
}

@end
