//
//  CheckTaskViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/22.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "CheckTaskViewController.h"
#import "TeamModel.h"

@interface CheckTaskViewController ()

@end

@implementation CheckTaskViewController
{
    NSMutableArray *apartmentArray;
    NSMutableArray *userArray;
    NSMutableArray *dateArray;
    int tag;
    UILabel *dateLabel;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:101010].hidden = NO;
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:101010].hidden = YES;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"查看排班";
    [self comeBack:nil];
    self.view.backgroundColor = bgcolor;
    self.tabBarController.tabBar.hidden = YES;
    apartmentArray = [NSMutableArray array];
    userArray = [NSMutableArray array];
    dateArray = [NSMutableArray array];
    tag = 0;
    [self navigationBar];
    [self initTableView];
    [self getMessage];

}

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:app.tocken forKey:@"token"];
    [params setObject:dateLabel.text forKey:@"date"];
    [params setObject:@"-1" forKey:@"pageSize"];
    [params setObject:@"-1" forKey:@"pageNum"];
    [self showHUD:@"正在加载"];
    [RedScarf_API requestWithURL:@"/team/schedule/" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            [dateArray removeAllObjects];
            for (NSMutableDictionary *dic in [[result objectForKey:@"msg"] objectForKey:@"list"]) {
                TeamModel *model = [[TeamModel alloc] init];
                model.users = [dic objectForKey:@"users"];
                model.apartmentName = [dic objectForKey:@"apartmentName"];
                
                [dateArray addObject:model];
            }
            [self.tableView reloadData];
        }else
        {
            [self alertView:[result objectForKey:@"msg"]];
        }
        [self hidHUD];
    }];
    
}

-(void)initTableView
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 45)];
    headView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:headView];
    
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
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/3, 0, kUIScreenWidth/3,45)];
    //获取日期
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];

    dateLabel.text = dateStr;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:dateLabel];

    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 119, kUIScreenWidth-30, kUIScreenHeigth-120)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.cornerRadius = 5;
    self.tableView.layer.masksToBounds = YES;
    UIView *foot = [[UIView alloc] init];
    self.tableView.tableFooterView = foot;
    [self.view addSubview:self.tableView];
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
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kUIScreenWidth-30, 10)];
    footerView.backgroundColor = bgcolor;
    
    return footerView;
    
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    TeamModel *model = [[TeamModel alloc] init];
    model = [dateArray objectAtIndex:section];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 45)];
    headView.backgroundColor = [UIColor whiteColor];
    headView.userInteractionEnabled = YES;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth-80, 0, 50, 45)];
    [headView addSubview:img];
    if (model.users.count) {
        img.image = [UIImage imageNamed:@"youren2x"];

    }else{
        img.image = [UIImage imageNamed:@"wurn2x"];

    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 44, kUIScreenWidth-30, 0.6)];
    line.backgroundColor = MakeColor(188, 188, 193);
    [headView addSubview:line];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kUIScreenWidth, 45)];
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
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
