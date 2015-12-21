//
//  FinishViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/18.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "FinishViewController.h"
#import "Header.h"
#import "AppDelegate.h"
#import "FinishTableViewCell.h"
#import "UIUtils.h"
#import "Model.h"

@implementation FinishViewController
{
    BOOL hidden;
    UIButton *button;
    int pageNum;
    NSString *search;
    MJRefreshFooterView *footView;
    MJRefreshHeaderView *headView;
}

-(void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"历史任务";
    self.view.backgroundColor = MakeColor(241, 241, 241);
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    hidden = NO;
    self.dataArr = [NSMutableArray array];
    self.searchDataArr = [NSMutableArray array];
    self.filteredArray = [NSMutableArray array];
    self.telArray = [NSMutableArray array];
    [self comeBack:nil];
    search = @"no";
    pageNum = 1;
    
    UIBarButtonItem *r = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"newshaixuan"] landscapeImagePhone:[UIImage imageNamed:@"newshaixuan"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickRight:)];
    

    
    r.tintColor = [UIColor grayColor];
    self.navigationItem.rightBarButtonItem = r;
    [self getMessage:nil];
    [self initTableView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    UIButton *barBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    barBtn.tag = 11111;
    //    barBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    barBtn.frame = CGRectMake(kUIScreenWidth-90, 6, 60, 30);
    [barBtn setTitle:@"    全 部" forState:UIControlStateNormal];
    [barBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didClickRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:barBtn];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self.navigationController.navigationBar viewWithTag:11111] removeFromSuperview];
}

-(void)initTableView
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 44)];
    [self.searchBar.layer setBorderColor:MakeColor(241, 241, 241).CGColor];
    [self.searchBar.layer setBorderWidth:1.0];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入用户手机号搜索";
    [self.searchBar setBarTintColor:MakeColor(241, 241, 241)];
    
    self.finishTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height)];
    self.finishTableView.backgroundColor = MakeColor(241, 241, 241);
    self.status = @"";
    self.finishTableView.delegate = self;
    self.finishTableView.dataSource = self;
    UIView *foot = [[UIView alloc] init];
    self.finishTableView.tableFooterView = foot;
    self.finishTableView.tableHeaderView = self.searchBar;
    self.finishTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.finishTableView];
    [self showHUD:@"正在加载"];

    footView = [[MJRefreshFooterView alloc] init];
    footView.delegate = self;
    footView.scrollView = self.finishTableView;
    
//    headView = [[MJRefreshHeaderView alloc] init];
//    headView.delegate = self;
//    headView.scrollView = self.finishTableView;
}

#pragma mark -- searchbarDelegate

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self getMessage:nil];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    [self getMessage:searchBar.text];
}

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        
    }else{
        pageNum += 1;
        [self getMessage:nil];
    }
   
}

-(void)getMessage:(NSString *)phone
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [params setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    if (self.status.length) {
        [params setObject:self.status forKey:@"status"];
        
    }
    
    if (phone.length) {
        [params setObject:phone forKey:@"phoneKey"];
    }
    [RSHttp requestWithURL:@"/task/taskByStatus" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSArray *arr = [NSArray arrayWithArray:[[data objectForKey:@"msg"] objectForKey:@"list"]];
        if (![arr count]) {
            [self.view addSubview:[self named:@"kongrenwu" text:@"任务"]];
        }else{
            [[self.view viewWithTag:666] removeFromSuperview];
            [self.searchDataArr removeAllObjects];
            for (NSMutableDictionary *dic in [[data objectForKey:@"msg"] objectForKey:@"list"]) {
                NSLog(@"dic = %@",dic);
                NSLog(@"[dic objectForKey:@conten] = %@",[dic objectForKey:@"content"]);
                Model *model = [[Model alloc] init];
                model.nameStr = [dic objectForKey:@"username"];
                model.chuLiStr = [dic objectForKey:@"username"];
                model.buyerStr = [dic objectForKey:@"customername"];
                model.telStr = [dic objectForKey:@"mobile"];
                [self.telArray addObject:model.telStr];
                model.addressStr = [dic objectForKey:@"apartmentname"];
                model.foodArr = [dic objectForKey:@"content"];
                model.dateStr = [dic objectForKey:@"endDate"];
                model.numberStr = [dic objectForKey:@"sn"];
                model.status = [dic objectForKey:@"status"];
                model.room = [dic objectForKey:@"room"];
                if (phone.length) {
                    [self.searchDataArr addObject:model];
                    search = @"yes";
                }else{
                    search = @"no";
                    [self.dataArr addObject:model];
                }
            }
            
            [self.finishTableView reloadData];
        }
        [footView endRefreshing];
        [headView endRefreshing];
        [self hidHUD];
    } failure:^(NSInteger code, NSString *errmsg) {
        [footView endRefreshing];
        [headView endRefreshing];
        [self hidHUD];
        [self alertView:errmsg];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
    if ([search isEqualToString:@"yes"]) {
        return self.searchDataArr.count;
    }else{
         return self.dataArr.count;
    }


}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section != 0) {
        return 10;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 15)];
    view.backgroundColor = MakeColor(241, 241, 241);
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    FinishTableViewCell *cell = (FinishTableViewCell *)[self tableView:self.finishTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height+45 ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier3";
    FinishTableViewCell *cell = [[FinishTableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
   
    UIImageView *statusImage = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth-65, 0, 45, 45)];

    [cell.contentView addSubview:statusImage];
    
    Model *model = [[Model alloc] init];

    if ([search isEqualToString:@"yes"]) {
         model = [self.searchDataArr objectAtIndex:indexPath.section];
    }else{
         model = [self.dataArr objectAtIndex:indexPath.section];
    }
    
    cell.nameLabel.text = [NSString stringWithFormat:@"配送人:%@",model.nameStr];
    cell.chuLiLabel.text = [NSString stringWithFormat:@"处理：%@",model.dateStr];
    cell.buyerLabel.text = [NSString stringWithFormat:@"收货人：%@",model.buyerStr];
    cell.telLabel.text = [NSString stringWithFormat:@"%@",model.telStr];
    cell.telLabel.textColor = MakeColor(0x27, 0x7d, 0xd7);
    [cell.telLabel addTapAction:@selector(callPerson:) target:self];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@ - %@",model.addressStr,model.room];
    
    NSString *contentStr = @"";
    for (NSDictionary *dic in model.foodArr) {
        contentStr = [contentStr stringByAppendingFormat:@"%@  %@  (%@份)\n",[dic objectForKey:@"tag"],[dic objectForKey:@"content"],[dic objectForKey:@"count"]];
        NSLog(@"contentStr = %@",contentStr);
        NSLog(@"food = %@",[dic objectForKey:@"content"]);
    }
    [cell setIntroductionText:[NSString stringWithFormat:@"%@",contentStr]];
    cell.numberLabel.text = [NSString stringWithFormat:@"任务编号：%@",model.numberStr];
    if ([model.status isEqualToString:@"FINISHED"]) {
        statusImage.image = [UIImage imageNamed:@"yiwan@2x"];

    }if ([model.status isEqualToString:@"UNDELIVERED"]) {
        statusImage.image = [UIImage imageNamed:@"weiwan@2x"];
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//~~~~~~~~

-(void)didClickRight:(id)sender
{
    
    if (hidden == NO) {
        for (int i=0; i<3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(kUIScreenWidth-100, 64+i*40, 90, 40);
            btn.backgroundColor = [UIColor grayColor];
            btn.tag = 100+i;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor whiteColor];
            line.frame = CGRectMake(5, 39, 80, 1);
            
            if (i == 0) {
                [btn addSubview:line];
                [btn setTitle:@"全 部" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(all) forControlEvents:UIControlEventTouchUpInside];
            }else
                if (i == 1) {
                [btn addSubview:line];
                [btn setTitle:@"已完成" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(success) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                [btn setTitle:@"未完成" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(fail) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.view addSubview:btn];
        }
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth-35, 35, 10, 10)];
        [self.navigationController.navigationBar addSubview:img];
        img.tag = 2020;
        img.image = [UIImage imageNamed:@"sanjiao@2x"];
        
        hidden = YES;
    }else{
        [[self.view viewWithTag:100] removeFromSuperview];
        [[self.view viewWithTag:101] removeFromSuperview];
        [[self.view viewWithTag:102] removeFromSuperview];

        hidden = NO;

        [[self.navigationController.navigationBar viewWithTag:2020] removeFromSuperview];
    }
}

-(void)all
{
    [[self.navigationController.navigationBar viewWithTag:2020] removeFromSuperview];

    [self.dataArr removeAllObjects];
    [button setTitle:@"" forState:UIControlStateNormal];
    UIButton *btn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn setTitle:@"   全 部" forState:UIControlStateNormal];
    self.status = @"";
    [self getMessage:nil];
    hidden = NO;
    [[self.view viewWithTag:100] removeFromSuperview];
    [[self.view viewWithTag:101] removeFromSuperview];
    [[self.view viewWithTag:102] removeFromSuperview];
}

-(void)success
{
    [[self.navigationController.navigationBar viewWithTag:2020] removeFromSuperview];

    [self.dataArr removeAllObjects];
    [button setTitle:@"" forState:UIControlStateNormal];
    UIButton *btn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [btn setTitle:@"已送达" forState:UIControlStateNormal];
    self.status = @"FINISHED";
    [self getMessage:nil];
    hidden = NO;
    [[self.view viewWithTag:100] removeFromSuperview];
    [[self.view viewWithTag:101] removeFromSuperview];
    [[self.view viewWithTag:102] removeFromSuperview];
}

-(void)fail
{
    [[self.navigationController.navigationBar viewWithTag:2020] removeFromSuperview];

    [self.dataArr removeAllObjects];
    [button setTitle:@"" forState:UIControlStateNormal];
    UIButton *btn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [btn setTitle:@"未送达" forState:UIControlStateNormal];
    self.status = @"UNDELIVERED";
    [self getMessage:nil];
    hidden = NO;
    [[self.view viewWithTag:100] removeFromSuperview];
    [[self.view viewWithTag:101] removeFromSuperview];
    [[self.view viewWithTag:102] removeFromSuperview];
}


-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) callPerson:(UITapGestureRecognizer *)tap
{
    if([tap.view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *) tap.view;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", label.text]]];
    }
}
@end
