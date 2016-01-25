//
//  ModifyMemberViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/23.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "ModifyMemberViewController.h"
#import "ListCell.h"
#import "LoginViewController.h"

@interface ModifyMemberViewController ()

@end

@implementation ModifyMemberViewController
{
    NSMutableArray *apartmentsArray;
    NSMutableArray *selectedArray;
    UITextField *modifyTf;
    NSMutableArray *indexArr;
    UIImageView *finishImage;
    
    BOOL userEnable;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    apartmentsArray = [NSMutableArray array];
    selectedArray = [NSMutableArray array];
    indexArr = [NSMutableArray array];
    [self comeBack:nil];
    [self initView];
}

-(void)initView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([self.title isEqualToString:@"修改电话"]) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDone)];
        self.navigationItem.rightBarButtonItem = right;
        [self modifyPhone];
    }
    if ([self.title isEqualToString:@"修改配送时间"]) {
        [self modifyTime];
    }
    if ([self.title isEqualToString:@"修改配送范围"]) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(didClickSave)];
        self.navigationItem.rightBarButtonItem = right;
        [self getMessage];
        [self modifyRange];
    }
}

-(void)modifyPhone
{
    UILabel *phoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 75, kUIScreenWidth-50, 40)];
    phoneLabel.text = [NSString stringWithFormat:@"当前号码:%@",self.phoneString];
    phoneLabel.textColor = color155;
    phoneLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:phoneLabel];
    
    modifyTf = [[UITextField alloc] initWithFrame:CGRectMake(40, 120, kUIScreenWidth-80, 40)];
    modifyTf.placeholder = @"输入电话号码";
    modifyTf.layer.borderColor = color155.CGColor;
    modifyTf.layer.borderWidth = 1.0;
    modifyTf.layer.masksToBounds = YES;
    modifyTf.layer.cornerRadius = 5;
    modifyTf.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:modifyTf];
}

-(void)modifyTime
{
    
}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.username forKey:@"username"];
    [self showHUD:@"正在加载"];
    [RSHttp requestWithURL:@"/team/user/setting/addr" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        apartmentsArray = [[data objectForKey:@"msg"] objectForKey:@"apartments"];
        NSString *selectedApartments = [[data objectForKey:@"msg"] objectForKey:@"selectedApartments"];
        selectedArray = [[selectedApartments componentsSeparatedByString:@","] copy];
        [self.tableView reloadData];
        [self hidHUD];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
        [self hidHUD];
    }];
}

-(void)modifyRange
{
    userEnable = NO;
}

#pragma mark -- tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return apartmentsArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    ListCell *cell = [[ListCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    if (userEnable) {
        cell.userInteractionEnabled = YES;
    }else{
        cell.userInteractionEnabled = NO;
    }
    NSMutableDictionary *dic = [apartmentsArray objectAtIndex:indexPath.row];
    cell.photoView.hidden = YES;
    cell.name.hidden = YES;
    cell.order.hidden = YES;
    cell.telLabel.hidden = YES;
    cell.sort.hidden = YES;
    cell.totalCount.hidden = YES;
    
    cell.textLabel.text = [dic objectForKey:@"name"];
    cell.finishImage = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth-50, 0, 50, 50)];
    [cell.contentView addSubview:cell.finishImage];
    cell.finishImage.hidden = YES;
    cell.finishImage.image = [UIImage imageNamed:@"peisong2x"];
    for (NSString *str in selectedArray) {
        if ([str isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]]) {
            cell.backgroundColor = MakeColor(254, 254, 254);
            cell.finishImage.hidden = NO;
            [indexArr addObject:[dic objectForKey:@"id"]];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ListCell *cell = (ListCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *dic = [apartmentsArray objectAtIndex:indexPath.row];

    if ([cell.backgroundColor isEqual:MakeColor(254, 254, 254)]) {
        [indexArr removeObject:[dic objectForKey:@"id"]];
        cell.finishImage.hidden = YES;
        cell.backgroundColor = [UIColor whiteColor];
    }else{
        cell.backgroundColor = MakeColor(254, 254, 254);
        [indexArr addObject:[dic objectForKey:@"id"]];
        cell.finishImage.hidden = NO;
    }
    NSLog(@"indexArr = %@",indexArr);
}

-(void)didClickDone
{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:self.phoneString forKey:@"username"];
    [params setValue:modifyTf.text forKey:@"mobilePhone"];
    [self showHUD:@"正在加载"];
    [RSHttp requestWithURL:@"/team/user" params:params httpMethod:@"PUT" success:^(NSDictionary *data) {
        [self alertView:@"修改成功"];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if ([[defaults objectForKey:@"username"] isEqualToString:self.phoneString]) {
            [defaults removeObjectForKey:@"token"];
            [defaults synchronize];
            
            LoginViewController *loginVC = [[LoginViewController alloc] init];
            [app setRootViewController:loginVC];
        }
        
        [self.delegate1 returnNumber:modifyTf.text];
        [self.navigationController popViewControllerAnimated:YES];
        [self hidHUD];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
        [self hidHUD];
    }];
}

-(void)didClickSave
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
        self.navigationItem.rightBarButtonItem.title = @"保存";
        userEnable = YES;
        [self.tableView reloadData];
    }else{
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        NSString *addrs = [indexArr componentsJoinedByString:@","];
        [params setObject:addrs forKey:@"addrs"];
        [params setObject:self.username forKey:@"username"];
        [self showHUD:@"正在加载"];
        [RSHttp requestWithURL:@"/team/user/setting/addr" params:params httpMethod:@"PUT" success:^(NSDictionary *data) {
            [self alertView:@"修改成功"];
            [self hidHUD];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSInteger code, NSString *errmsg) {
            [self alertView:errmsg];
            [self hidHUD];
        }];
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        userEnable = NO;
        [self.tableView reloadData];
    }
}
@end
