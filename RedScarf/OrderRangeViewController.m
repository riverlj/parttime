//
//  OrderRangeViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/17.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "OrderRangeViewController.h"

@interface OrderRangeViewController ()

@end

@implementation OrderRangeViewController
{
    NSMutableArray *addressArray;
    NSMutableArray *idArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"配送范围";
    addressArray = [NSMutableArray array];
    idArray = [NSMutableArray array];
    [self initTableView];
    [self getMessage];
}

-(void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 15, kUIScreenWidth-30, kUIScreenHeigth)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *foot = [[UIView alloc] init];
    self.tableView.tableFooterView = foot;
    [self.view addSubview:self.tableView];
}

-(void)getMessage
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    if (self.username.length) {
        [params setObject:self.username forKey:@"username"];
    }
    
    [RSHttp requestWithURL:@"/user/setting/addr" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        addressArray = [[data objectForKey:@"msg"] objectForKey:@"apartments"];
        [idArray addObject:[[data objectForKey:@"msg"] objectForKey:@"selectedApartments"]];
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
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
    
    NSString *select = idArray[0];
    NSArray *arr = [select componentsSeparatedByString:@","];
    for (NSString *str in arr) {
        if ([str isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]]) {
            UIImageView *finishImage = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth-50, 0, 50, 50)];
            [cell.contentView addSubview:finishImage];
            finishImage.image = [UIImage imageNamed:@"peisong2x"];
        }
    }
    
    return cell;
}
@end
