//
//  CheckTaskViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/22.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "CheckTaskViewController.h"
#import "TeamModel.h"
#import "RSCatchline.h"

@interface CheckTaskViewController ()

@end

@implementation CheckTaskViewController
{
    NSMutableArray *apartmentArray;
    NSMutableArray *userArray;
    NSMutableArray *dateArray;
    int tag;
    UILabel *dateLabel;
    NSDate *curDate;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查看排班";
    [self.tips setTitle:@"排班" withImg:@"meiyoupaiban"];
    apartmentArray = [NSMutableArray array];
    userArray = [NSMutableArray array];
    dateArray = [NSMutableArray array];
    tag = 0;
    [self initTableView];
    [self getMessage];
}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:dateLabel.text forKey:@"date"];
    [params setObject:@"-1" forKey:@"pageSize"];
    [params setObject:@"-1" forKey:@"pageNum"];
    [self showHUD:@"正在加载"];
    [RSHttp requestWithURL:@"/team/schedule/" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [self hidHUD];
        NSArray *arr = [NSArray arrayWithArray:[[data objectForKey:@"body"] objectForKey:@"list"]];
        if (![arr count]) {
            [self.tips setFrame:CGRectMake(0, 0, self.tableView.width, self.tableView.height)];
            [self.tableView addSubview:self.tips];
        } else {
            [self.tips removeFromSuperview];
        }
        
        [dateArray removeAllObjects];
        for (NSMutableDictionary *dic in [[data objectForKey:@"body"] objectForKey:@"list"]) {
            TeamModel *model = [[TeamModel alloc] init];
            model.users = [dic objectForKey:@"users"];
            model.apartmentName = [dic objectForKey:@"apartmentName"];
            
            [dateArray addObject:model];
        }
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self alertView:errmsg];
    }];
}

-(void)initTableView
{
    self.tableView.left = 15;
    self.tableView.width = kUIScreenWidth - 30;
    self.tableView.height += 64;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 45)];
    [headView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton *befBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    befBtn.frame = CGRectMake(0, 0, kUIScreenWidth/3, 45);
    [befBtn addTarget:self action:@selector(didClickBef) forControlEvents:UIControlEventTouchUpInside];
    [befBtn setTitle:@"< 前一天" forState:UIControlStateNormal];
    [headView addSubview:befBtn];
    
    UIButton *afBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    afBtn.frame = CGRectMake(kUIScreenWidth/3*2, 0, kUIScreenWidth/3, 45);
    [afBtn addTarget:self action:@selector(didClickAf) forControlEvents:UIControlEventTouchUpInside];
    [afBtn setTitle:@"后一天 >" forState:UIControlStateNormal];
    [headView addSubview:afBtn];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/3, 0, self.tableView.width/3,45)];
    //获取日期
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];

    dateLabel.text = dateStr;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:dateLabel];
    [self.view addSubview:headView];
    
    self.tableView.top = headView.height;
    self.tableView.height = kUIScreenHeigth - headView.height + 49;
    UIView *foot = [[UIView alloc] init];
    self.tableView.tableFooterView = foot;
}

-(void)didClickBef
{
    NSDate *date = [NSDate date];
    tag--;
    NSTimeInterval interval = 24*60*60*tag;
    NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date1];
    
    dateLabel.text = dateStr;
    [self getMessage];
}

-(void)didClickAf
{
    NSDate *date = [NSDate date];
    tag++;
    NSTimeInterval interval = 24*60*60*tag;
    NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date1];
    
    dateLabel.text = dateStr;
    [self getMessage];

}

#pragma mark -- tableViewDelegate

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return dateArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 55;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TeamModel *model = [[TeamModel alloc] init];
    model = [dateArray objectAtIndex:section];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 55)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.userInteractionEnabled = YES;
    
    UIImageView *sep = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, headView.width, 10)];
    [sep setBackgroundColor:color_gray_f3f5f7];
    [headView addSubview:sep];
    
    RSCatchline *cacheLine = [[RSCatchline alloc] initWithFrame:CGRectMake(self.tableView.width - 50, 10, 50, 45)];
    if(model.users.count) {
        [cacheLine setTitle:@"有人" withBgColor:color_blue_5999f8];
    } else {
        [cacheLine setTitle:@"无人" withBgColor:color_red_e54545];
    }
    [headView addSubview:cacheLine];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, kUIScreenWidth-36 - 15 - cacheLine.width/2, 45)];
    label.text = model.apartmentName;
    [headView addSubview:label];
    
    return headView;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    TeamModel *model = [[TeamModel alloc] init];
    model = [dateArray objectAtIndex:section];
    return model.users.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TeamModel *model = [[TeamModel alloc] init];
    model = [dateArray objectAtIndex:indexPath.section];
    
    NSMutableDictionary *dic = model.users[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"realName"];
    cell.textLabel.textColor = color155;
    cell.textLabel.font = textFont15;
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth-150, 0, 100, 45)];
    [cell.contentView addSubview:phoneLabel];
    phoneLabel.font = textFont14;
    phoneLabel.textColor = color155;
    phoneLabel.text = [dic objectForKey:@"mobilePhone"];
   
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 0.6)];
    line.backgroundColor = color_gray_e8e8e8;
    [cell addSubview:line];
    return cell;
}
@end
