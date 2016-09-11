//
//  MsgViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/27.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "MsgViewController.h"
#import "SuggestionViewController.h"
#import "GoPeiSongViewController.h"

@interface MsgViewController ()

@end

@implementation MsgViewController
{
    NSArray *titleArray;
    NSMutableArray *msgArray,*statusArray,*idArray;
    int pageNum;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    msgArray = [NSMutableArray array];
    statusArray = [NSMutableArray array];
    idArray = [NSMutableArray array];
    pageNum = 1;
    [self getMessage];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self comeBack:nil];
    self.title = @"消息中心";
    [self initTableView];
    
}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    [params setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [RSHttp requestWithURL:@"/user/message" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        pageNum ++;
        NSArray *list = [[data objectForKey:@"body"] objectForKey:@"list"];
        for (NSDictionary *dic in list) {
            [msgArray addObject:dic];
            [statusArray addObject:[dic objectForKey:@"status"]];
            [idArray addObject:[dic objectForKey:@"id"]];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView reloadData];
        if([list count] < 10) {
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSInteger code, NSString *errmsg) {
        [self.tableView.mj_footer endRefreshing];
        [self showToast:errmsg];
    }];
}


-(void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
    self.tableView.height += 64;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = color242;
    [self.view addSubview:self.tableView];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(getMessage)];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"MsgCell_Identifier";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

     NSDictionary *dic = msgArray[indexPath.row];
    UIImageView *icon = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, 60, 60)];
    [cell.contentView addSubview:icon];
    
    UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth-130, 5, 125, 20)];
    timeLabel.textColor = color155;
    timeLabel.text = [dic objectForKey:@"time"];
    timeLabel.font = textFont12;
    [cell.contentView addSubview:timeLabel];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x+icon.frame.size.width+15, 15, kUIScreenWidth-80, 25)];
    [cell.contentView addSubview:title];
    title.textColor = color102;
    title.font = textFont14;
    title.text = [dic objectForKey:@"title"];
    if ([title.text isEqualToString:@"任务变更通知"]) {
        icon.image = [UIImage imageNamed:@"biangeng2x"];
        if ([[NSString stringWithFormat:@"%@",statusArray[indexPath.row]] isEqualToString:@"1"]) {
            cell.backgroundColor = color234;
            cell.userInteractionEnabled = NO;
            icon.image = [UIImage imageNamed:@"huibiangeng2x"];
        }
    }
    if ([title.text isEqualToString:@"任务操作提醒"]) {
        icon.image = [UIImage imageNamed:@"caozuo2x"];
        if ([[NSString stringWithFormat:@"%@",statusArray[indexPath.row]] isEqualToString:@"1"]) {
            cell.backgroundColor = color234;
            cell.userInteractionEnabled = NO;
            icon.image = [UIImage imageNamed:@"huicaozuo2x"];
        }
    }
    if ([title.text isEqualToString:@"配送任务通知"]) {
        icon.image = [UIImage imageNamed:@"peisongrenwu2x"];
        if ([[NSString stringWithFormat:@"%@",statusArray[indexPath.row]] isEqualToString:@"1"]) {
            cell.backgroundColor = color234;
            cell.userInteractionEnabled = NO;
            icon.image = [UIImage imageNamed:@"huipeisong2x"];
        }
    }
    if ([title.text isEqualToString:@"反馈回复通知"]) {
        icon.image = [UIImage imageNamed:@"fankuihuifu2x"];
        if ([[NSString stringWithFormat:@"%@",statusArray[indexPath.row]] isEqualToString:@"1"]) {
            cell.backgroundColor = color234;
            cell.userInteractionEnabled = NO;
            icon.image = [UIImage imageNamed:@"huifankui2x"];
        }
    }
    if ([title.text isEqualToString:@"系统消息提醒"]) {
        icon.image = [UIImage imageNamed:@"xitongxiaoxi"];
        if ([[NSString stringWithFormat:@"%@",statusArray[indexPath.row]] isEqualToString:@"1"]) {
            cell.backgroundColor = color234;
            cell.userInteractionEnabled = NO;
            icon.image = [UIImage imageNamed:@"huixitongxiaoxi"];
        }
    }
    
    UILabel *detailTitle = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x+icon.frame.size.width+15, title.frame.size.height+title.frame.origin.y, kUIScreenWidth-120, 35)];
    detailTitle.font = textFont12;
    detailTitle.numberOfLines = 0;
    detailTitle.textColor = color155;
    detailTitle.text = [dic objectForKey:@"content"];
    [cell.contentView addSubview:detailTitle];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return msgArray.count;
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     NSDictionary *dic = msgArray[indexPath.row];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[defaults objectForKey:@"token"] forKey:@"token"];
    [params setObject:[NSString stringWithFormat:@"%@",idArray[indexPath.row]] forKey:@"messageId"];
    
    [RSHttp requestWithURL:@"/user/message/status" params:params httpMethod:@"POST" success:^(NSDictionary *data) {
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
    }];
    
    if ([[dic objectForKey:@"title"] isEqualToString:@"任务变更通知"] || [[dic objectForKey:@"title"] isEqualToString:@"任务操作提醒"]) {
        GoPeiSongViewController *taskVC = [[GoPeiSongViewController alloc] init];
        [self.navigationController pushViewController:taskVC animated:YES];
    }
    if ([[dic objectForKey:@"title"] isEqualToString:@"反馈回复通知"]) {
        SuggestionViewController *suggestVC = [[SuggestionViewController alloc] init];
        [self.navigationController pushViewController:suggestVC animated:YES];
    }
    if ([[dic objectForKey:@"title"] isEqualToString:@"配送任务通知"]) {
        GoPeiSongViewController *peisongVC = [[GoPeiSongViewController alloc] init];
        [self.navigationController pushViewController:peisongVC animated:YES];
    }
}
@end
