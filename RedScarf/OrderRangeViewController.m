//
//  OrderRangeViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/17.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "OrderRangeViewController.h"
#import "RSCatchLine.h"
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
    UIView *foot = [[UIView alloc] init];
    self.tableView.tableFooterView = foot;
    self.tableView.left = 18;
    self.tableView.width = kUIScreenWidth - 36;
    self.tableView.top = 10;
    self.tableView.layer.cornerRadius = 10;
    self.tableView.clipsToBounds = YES;
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
    return 49;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];

    if (cell == nil) {
        cell =[[UITableViewCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    NSMutableDictionary *dic = [addressArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dic objectForKey:@"name"];
    cell.textLabel.left = 13;
    cell.textLabel.textColor = color_black_666666;
    
    NSString *select = idArray[0];
    NSArray *arr = [select componentsSeparatedByString:@","];
    for (NSString *str in arr) {
        if ([str isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]]) {
            RSCatchline *cacheLine = [[RSCatchline alloc] initWithFrame:CGRectMake(kUIScreenWidth-50 - 36, 0, 49, 49)];
            [cacheLine setTitle:@" 配送" withBgColor:color_blue_287dd8];
            [cell.contentView addSubview:cacheLine];
        }
    }
    
    return cell;
}
@end
