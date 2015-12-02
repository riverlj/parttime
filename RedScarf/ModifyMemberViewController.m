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
    // Do any additional setup after loading the view.
    
    apartmentsArray = [NSMutableArray array];
    selectedArray = [NSMutableArray array];
    indexArr = [NSMutableArray array];
    [self comeBack:nil];
    [self initView];
}

-(void)initView
{
    if ([self.title isEqualToString:@"修改电话"]) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDone)];
//        right.tintColor = [UIColor whiteColor];
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
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:app.tocken forKey:@"token"];
//    self.username = [self.username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [params setObject:self.username forKey:@"username"];
    [self showHUD:@"正在加载"];
    [RedScarf_API requestWithURL:@"/team/user/setting/addr" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            apartmentsArray = [[result objectForKey:@"msg"] objectForKey:@"apartments"];
            NSString *selectedApartments = [[result objectForKey:@"msg"] objectForKey:@"selectedApartments"];
            selectedArray = [selectedApartments componentsSeparatedByString:@","];
            [self.tableView reloadData];
        }else
        {
            [self alertView:[result objectForKey:@"msg"]];
        }
        [self hidHUD];
    }];
}

-(void)modifyRange
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, kUIScreenHeigth-64)];
//    self.tableView.userInteractionEnabled = NO;
    userEnable = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
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
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:app.tocken forKey:@"token"];
    [params setObject:self.phoneString forKey:@"username"];
    [params setValue:modifyTf.text forKey:@"mobilePhone"];
    [self showHUD:@"正在加载"];
    [RedScarf_API requestWithURL:@"/team/user" params:params httpMethod:@"PUT" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            [self alertView:@"修改成功"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([[defaults objectForKey:@"username"] isEqualToString:self.phoneString]) {
                [defaults removeObjectForKey:@"token"];
                [defaults synchronize];
                
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                [app setRoorViewController:loginVC];
            }
            
            [self.delegate returnNumber:modifyTf.text];
            [self.navigationController popViewControllerAnimated:YES];
            
        }else
        {
            [self alertView:[result objectForKey:@"msg"]];
        }
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
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:app.tocken forKey:@"token"];
        NSString *addrs = [indexArr componentsJoinedByString:@","];
        [params setObject:addrs forKey:@"addrs"];
        [params setObject:self.username forKey:@"username"];
        [self showHUD:@"正在加载"];
        [RedScarf_API requestWithURL:@"/team/user/setting/addr" params:params httpMethod:@"PUT" block:^(id result) {
            NSLog(@"result = %@",result);
            if ([[result objectForKey:@"success"] boolValue]) {
                [self alertView:@"修改成功"];
                
                [self.navigationController popViewControllerAnimated:YES];
                
            }else
            {
                [self alertView:[result objectForKey:@"msg"]];
                return ;
            }
            [self hidHUD];
        }];

        self.navigationItem.rightBarButtonItem.title = @"编辑";
        userEnable = NO;
        [self.tableView reloadData];
    }
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
