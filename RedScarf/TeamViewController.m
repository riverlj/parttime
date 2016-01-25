//
//  TeamViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "TeamViewController.h"
#import "TeamMembersViewController.h"
#import "CheckTaskViewController.h"
#import "BaseTabbarViewController.h"

@interface TeamViewController ()

@end

@implementation TeamViewController
{
    NSMutableArray *titleArray;
    NSMutableArray *imgArray;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self comeBack:nil];
    self.title = @"团队";
    titleArray = [NSMutableArray arrayWithObjects:@"团队成员",@"查看排班", nil];
    imgArray = [NSMutableArray arrayWithObjects:@"chengyuan2x",@"paiban2x", nil];
    [self initTableView];
}

-(void)initTableView
{
    self.teamTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height)];
    self.teamTableView.delegate = self;
    self.teamTableView.dataSource = self;
    [self.view addSubview:self.teamTableView];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 23, 20)];
    [cell.contentView addSubview:headView];
    headView.image = [UIImage imageNamed:imgArray[indexPath.row]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 100, 50)];
    label.text = [titleArray objectAtIndex:indexPath.row];
    [cell.contentView addSubview:label];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        TeamMembersViewController *teamMemberVC = [[TeamMembersViewController alloc] init];
        [self.navigationController pushViewController:teamMemberVC animated:YES];
    }
    if (indexPath.row == 1) {
        CheckTaskViewController *checkTaskVC = [[CheckTaskViewController alloc] init];
        [self.navigationController pushViewController:checkTaskVC animated:YES];

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
