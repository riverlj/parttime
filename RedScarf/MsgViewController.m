//
//  MsgViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/27.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "MsgViewController.h"
#import "TaskViewController.h"
#import "SuggestionViewController.h"
#import "GoPeiSongViewController.h"

@interface MsgViewController ()

@end

@implementation MsgViewController
{
    NSArray *titleArray;
    NSMutableArray *msgArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    msgArray = [NSMutableArray array];
    [self comeBack:nil];
    self.title = @"消息中心";
    [self initTableView];
    [self getMessage];
}

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];
    [params setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    
    [RedScarf_API requestWithURL:@"/user/message" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if (![[result objectForKey:@"code"] boolValue]) {
            
            for (NSDictionary *dic in [[result objectForKey:@"body"] objectForKey:@"list"]) {
                [msgArray addObject:dic];
            }
            
            NSUserDefaults *defauls = [NSUserDefaults standardUserDefaults];
            NSMutableArray *statusArray = [NSMutableArray array];
            for (int i = 0; i < msgArray.count; i++) {
                
            }
        }
        
        [self.tableView reloadData];
    }];

}

-(void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenWidth)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
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
    }
    if ([title.text isEqualToString:@"任务操作提醒"]) {
        icon.image = [UIImage imageNamed:@"caozuo2x"];
    }
    if ([title.text isEqualToString:@""]) {
        icon.image = [UIImage imageNamed:@""];
    }
    
    UILabel *detailTitle = [[UILabel alloc] initWithFrame:CGRectMake(icon.frame.origin.x+icon.frame.size.width+15, title.frame.size.height+title.frame.origin.y, kUIScreenWidth-110, 35)];
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



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
     NSDictionary *dic = msgArray[indexPath.row];
    if ([[dic objectForKey:@"title"] isEqualToString:@"任务变更通知"]) {
        TaskViewController *taskVC = [[TaskViewController alloc] init];
        [self.navigationController pushViewController:taskVC animated:YES];
    }
    if ([[dic objectForKey:@"title"] isEqualToString:@"任务操作提醒"]) {
        TaskViewController *taskVC = [[TaskViewController alloc] init];
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
