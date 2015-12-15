//
//  RoomViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RoomViewController.h"
#import "Header.h"
#import "RoomTableViewCell.h"
#import "Header.h"
#import "UIUtils.h"
#import "AppDelegate.h"

@implementation RoomViewController
{
    UIButton *doBtn;
    UIButton *notBtn;
    NSMutableArray *numArr;
    NSString *yesOrNo;
    
    NSString *judgeAlterView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [super viewWillAppear:animated];
}

-(void)viewDidLoad
{
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = color242;
    self.tabBarController.tabBar.hidden = YES;
    judgeAlterView = @"yes";
    self.title = self.titleStr;
    numArr = [NSMutableArray array];
    self.dataArray = [NSMutableArray array];
    [self initNavigation];
    [self initTableView];
    [self initFootBtn];
    [self getMessage];
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

-(void)getMessage
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:self.aId forKey:@"aId"];
    self.room = [self.room stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [params setObject:self.room forKey:@"room"];
    [params setObject:@"2" forKey:@"source"];
    [RSHttp requestWithURL:@"/task/assignedTask/customerDetail" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [self.dataArray removeAllObjects];
        for (NSMutableDictionary *dic in [data objectForKey:@"msg"]) {
            NSLog(@"dic = %@",dic);
            [self.dataArray addObject:dic];
        }
        [self.detailTableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}


-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initTableView
{
    self.detailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth-50)];
    self.detailTableView.delegate = self;
    self.detailTableView.dataSource = self;
    self.detailTableView.backgroundColor = color242;
    self.detailTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.detailTableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RoomTableViewCell *cell = (RoomTableViewCell *)[self tableView:self.detailTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    RoomTableViewCell *cell = [[RoomTableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = color242;
    NSMutableDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    
    cell.nameLabel.text = [NSString stringWithFormat:@"%@:%@",[dic objectForKey:@"customerName"],[dic objectForKey:@"mobile"]];
    //content是个数组
    NSString *contentStr = @"";
    NSMutableArray *lengthArr = [NSMutableArray array];
    NSMutableArray *tagArr = [NSMutableArray array];
    for (NSDictionary *content in [dic objectForKey:@"content"]) {
        contentStr = [contentStr stringByAppendingFormat:@"%@  %@  (%@份)\n",[content objectForKey:@"tag"],[content objectForKey:@"content"],[content objectForKey:@"count"]];
        
        NSString *tagStr = [NSString stringWithFormat:@"%@",[content objectForKey:@"tag"] ];
        [tagArr addObject:[NSNumber numberWithUnsignedInteger:tagStr.length]];
        
        [lengthArr addObject:[NSNumber numberWithUnsignedInteger:contentStr.length]];
        NSLog(@"str length = %lu",(unsigned long)contentStr.length);
    }
    //数量和餐品颜色
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    for (int i = 0; i < lengthArr.count; i++) {
        //份数颜色
        int tagLength = [[tagArr objectAtIndex:i] intValue];
        NSRange tagRange;
        if (i == 0) {
            tagRange = NSMakeRange(0, tagLength);
        }else{
            tagRange = NSMakeRange([[lengthArr objectAtIndex:i-1] intValue], tagLength);
        }
        
        [noteStr addAttribute:NSForegroundColorAttributeName value:colorblue range:tagRange];
        
    }
    
    [cell setIntroductionText:noteStr];
    cell.numberLabel.text = [NSString stringWithFormat:@"任务编号:%@",[dic objectForKey:@"sn"]];
    cell.dateLabel.text = [dic objectForKey:@"date"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    RoomTableViewCell *cell = (RoomTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    self.sn = [dic objectForKey:@"sn"];

    
    if (cell.roundBtn.image == nil) {
        [cell.roundBtn setImage:[UIImage imageNamed:@"xuanzhong"]];
        UIButton *btn = (UIButton *)[self.view viewWithTag:1234];
        UIButton *btn1 = (UIButton *)[self.view viewWithTag:2234];
        [btn setTitleColor:colorrede5 forState:UIControlStateNormal];
        [btn1 setTitleColor:colorblue forState:UIControlStateNormal];
        btn1.userInteractionEnabled = YES;
        btn.userInteractionEnabled = YES;
        [numArr addObject:[NSNumber numberWithInteger:indexPath.row]];

    }else{
        [cell.roundBtn setImage:nil];
       
        [numArr removeObject:[NSNumber numberWithInteger:indexPath.row]];
        
        if (numArr.count == 0) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:1234];
            UIButton *btn1 = (UIButton *)[self.view viewWithTag:2234];
            [btn setTitleColor:color155 forState:UIControlStateNormal];
            [btn1 setTitleColor:color155 forState:UIControlStateNormal];
            btn.userInteractionEnabled = NO;
            btn1.userInteractionEnabled = NO;
            notBtn.userInteractionEnabled = NO;
            doBtn.userInteractionEnabled = NO;
        }
    }

}

-(void)initFootBtn
{
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kUIScreenHeigth-45.5, kUIScreenWidth, 0.5)];
    line.backgroundColor = MakeColor(169, 169, 169);
    [self.view addSubview:line];
    
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kUIScreenWidth/2*i, kUIScreenHeigth-45, kUIScreenWidth/2, 45)];
        [btn setTitleColor:color155 forState:UIControlStateNormal];
        btn.userInteractionEnabled = NO;
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = textFont14;
        [self.view addSubview:btn];
        if (i == 0) {
            btn.tag = 1234;
            [btn setTitle:@"遇到问题" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didClickNotBtn) forControlEvents:UIControlEventTouchUpInside];
        }
        if (i == 1) {
            btn.tag = 2234;
            [btn setTitle:@"已送达" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didClickDoBtn) forControlEvents:UIControlEventTouchUpInside];
        }
    }

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(kUIScreenWidth/2, kUIScreenHeigth-38, 0.5, 30)];
    lineView.backgroundColor = MakeColor(169, 169, 169);
    [self.view addSubview:lineView];
}

-(void)didClickDoBtn
{
    [[BaiduMobStat defaultStat] logEvent:@"已送达" eventLabel:@"button4"];
    [self alertView:@"确认送达"];
}

-(void)didClickNotBtn
{
    [[BaiduMobStat defaultStat] logEvent:@"遇到问题" eventLabel:@"button5"];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"提示" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"餐品不够",@"送错或漏送",@"餐品腐坏",@"餐品破损",@"其他", nil];
    [actionSheet showInView:self.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *reason;
    switch (buttonIndex) {
        case 0:
        {
            reason = @"餐品不够";
            [[BaiduMobStat defaultStat] logEvent:@"餐品不够" eventLabel:@"button"];
        }
            break;
        case 1:
        {
            reason = @"送错或漏送";
            [[BaiduMobStat defaultStat] logEvent:@"送错或漏送" eventLabel:@"button"];
        }
            break;
        case 2:
        {
            reason = @"餐品腐坏";
            [[BaiduMobStat defaultStat] logEvent:@"餐品腐坏" eventLabel:@"button"];
        }
            break;
        case 3:
        {
            reason = @"餐品破损";
            [[BaiduMobStat defaultStat] logEvent:@"餐品破损" eventLabel:@"button"];
        }
            break;
        case 4:
        {
            reason = @"其他";
            [[BaiduMobStat defaultStat] logEvent:@"其他" eventLabel:@"button"];
        }
            break;
        default:
            break;
    }
    reason = [reason stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:self.sn forKey:@"sn"];
    if (reason.length) {
        [params setObject:reason forKey:@"reason"];
        [RSHttp requestWithURL:@"/task/assignedTask/undelivereReason" params:params httpMethod:@"PUT" success:^(NSDictionary *data) {
            [self alertView:@"提交成功"];
            judgeAlterView = @"no";
        } failure:^(NSInteger code, NSString *errmsg) {
            [self alertView:errmsg];
        }];
    }
    
}

-(void)alertView:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
        {
            if ([judgeAlterView isEqualToString:@"yes"]) {
                judgeAlterView = @"no";
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                app.tocken = [UIUtils replaceAdd:app.tocken];
                [params setObject:self.sn forKey:@"sn"];
                [params setObject:@"2" forKey:@"source"];
                [RSHttp requestWithURL:@"/task/assignedTask/finishSingle" params:params httpMethod:@"PUT" success:^(NSDictionary *data) {
                    yesOrNo = @"yes";
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"成功送达" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                } failure:^(NSInteger code, NSString *errmsg) {
                    yesOrNo = @"yes";
                    [self alertView:errmsg];
                }];
            }else{
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        }
            break;
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        default:
            break;
    }
}


@end
