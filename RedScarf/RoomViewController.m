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
#import "DetailTroubleViewController.h"

@implementation RoomViewController
{
    NSArray *reasonArr;
    NSArray *detailReasonArr;
    NSMutableArray *_checkedArray;

}

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [super viewWillAppear:animated];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
  
    reasonArr = [NSArray arrayWithObjects:@"餐品不够",@"找不到地址",@"餐品错误",@"早餐破损",@"其他", nil];
    detailReasonArr = [NSArray arrayWithObjects:@"请说明不够的餐品名称和数量，不超过50个字",@"请说明未送达原因，不超过50个字",@"请说明错误的餐品名称和数量，不超过50个字",@"请说明破损的餐品名称和数量，不超过50个字",@"请说明未送达原因，不超过50个字", nil];


    self.title = self.titleStr;
    _models = [NSMutableArray array];
    [self initTableView];
    [self initFootBtn];
//    [self getMessage];
    self.url = @"/task/assignedTask/customerDetail";
    self.httpMethod = @"GET";
    self.useFooterRefresh = NO;
    self.useHeaderRefresh = NO;
    
    [self beginHttpRequest];
    
}

-(void)beforeHttpRequest {
    [super beforeHttpRequest];
    [self.params setValue:self.aId forKey:@"aId"];
    [self.params setValue:self.room forKey:@"room"];
    [self.params setValue:@"2" forKey:@"source"];

}

-(void)afterHttpSuccess:(NSDictionary *)data{
    NSError *error = nil;
    for (NSMutableDictionary *dic in [data objectForKey:@"body"]) {
        RoomMissionModel *model = [MTLJSONAdapter modelOfClass:[RoomMissionModel class] fromJSONDictionary:dic error:&error];
        if(model) {
            model.content = [dic objectForKey:@"content"];
            model.checked = NO;
            model.cellClassName = @"RoomTableViewCell";
            [model setSelectAction:@selector(modelSelected:) target:self];
        }
        [self.models addObject:model];
    }
    [super afterHttpSuccess:data];
}

- (void) modelSelected:(RoomMissionModel *)model {
    model.checked = !model.checked;
    [self.tableView reloadData];
    [self refreshBtn];
}

-(void)initTableView
{
    self.tableView.backgroundColor = color242;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *buttonIndex) {
        NSInteger index = [buttonIndex integerValue];
        if(index == 0) {    //已送达
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:@"2" forKey:@"source"];
            NSMutableArray *tempArr = [NSMutableArray array];
            NSString *sns = @"";
            for(RoomMissionModel *model in self.models) {
                if(model.checked) {
                    [tempArr addObject:model];
                    sns = [sns append:[NSString stringWithFormat:@"%@,", model.snid]];
                }
            }
            [params setValue:sns forKey:@"sns"];
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

    }];
    [alertView show];
    return;
}

-(void)didClickNotBtn
{
    [[BaiduMobStat defaultStat] logEvent:@"遇到问题" eventLabel:@"button5"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"请选择未送达的原因" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"餐品不够",@"找不到地址",@"餐品错误",@"早餐破损",@"其他", nil];
    
    [[actionSheet rac_buttonClickedSignal] subscribeNext:^(NSNumber* clickedIndex) {
        int index = [clickedIndex integerValue];
        if (index != 5) {
            _checkedArray = [NSMutableArray array];
            NSString *sns = @"";
            for(RoomMissionModel *model in self.models) {
                if(model.checked) {
                    [_checkedArray addObject:model];
                    sns = [sns append:[NSString stringWithFormat:@"%@,", model.snid]];
                }
            }
            
            DetailTroubleViewController *detailTroubleVC = [[DetailTroubleViewController alloc]init];
            detailTroubleVC.title = reasonArr[index];
            detailTroubleVC.submitDelegate = self;
            detailTroubleVC.placeholderText = detailReasonArr[index];
            detailTroubleVC.textMaxLength = 50;
            detailTroubleVC.url = @"/task/assignedTask/batchUndelivereReason";
            detailTroubleVC.httpMethod = @"PUT";
            detailTroubleVC.firstReasonCode = [NSString stringWithFormat:@"%d", index+1];
            detailTroubleVC.sns = sns;
            
            UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:detailTroubleVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }];
    
    [actionSheet showInView:self.view];
}

#pragma SubmitSuccessDelegate
- (void)submitSuccess{
    for(RoomMissionModel *model in _checkedArray) {
        [self.models removeObject:model];
    }
    [self.tableView reloadData];
    [self refreshBtn];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoomTableViewCell *cell = (RoomTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}


@end
