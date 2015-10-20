//
//  OrderRangeViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/17.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "OrderRangeViewController.h"
#import "RedScarf_API.h"

@interface OrderRangeViewController ()

@end

@implementation OrderRangeViewController
{
    NSMutableArray *addressArray;
    NSMutableArray *idArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"配送范围";
    self.view.backgroundColor = color242;
    self.tabBarController.tabBar.hidden = YES;
    addressArray = [NSMutableArray array];
    idArray = [NSMutableArray array];
    [self navigationBar];
    [self initTableView];
    [self getMessage];
}

-(void)navigationBar
{
    //隐藏tabbar上的按钮
    UIButton *barBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [barBtn removeFromSuperview];
}

-(void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 15, kUIScreenWidth-30, kUIScreenHeigth)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *foot = [[UIView alloc] init];
    self.tableView.tableFooterView = foot;
    self.tableView.backgroundColor = color242;
    [self.view addSubview:self.tableView];
}

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    
    [RedScarf_API requestWithURL:@"/user/setting/addr" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
    
            addressArray = [[result objectForKey:@"msg"] objectForKey:@"apartments"];
            [idArray addObject:[[result objectForKey:@"msg"] objectForKey:@"selectedApartments"]];
            
        }else
        {
            [self alertView:[result objectForKey:@"msg"]];
        }
        [self.tableView reloadData];
    }];
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
    return addressArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    NSMutableDictionary *dic = [addressArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dic objectForKey:@"name"];
    
    UIImageView *finishImage = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth-80, 0, 50, 50)];
    [cell.contentView addSubview:finishImage];
    finishImage.image = [UIImage imageNamed:@"peisong2x"];
    
    for (NSString *str in idArray) {
        if ([str isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]]) {
            cell.backgroundColor = MakeColor(32, 190, 251);
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
