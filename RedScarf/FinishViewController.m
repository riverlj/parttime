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
#import "RedScarf_API.h"
#import "Model.h"

@implementation FinishViewController
{
    BOOL hidden;
    UIButton *button;
    int pageNum;
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
    self.filteredArray = [NSMutableArray array];
    self.telArray = [NSMutableArray array];
    [self comeBack:nil];
    
    pageNum = 1;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"newshaixuan"] style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem *r = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"newshaixuan"] landscapeImagePhone:[UIImage imageNamed:@"newshaixuan"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickRight:)];
    
    UIButton *barBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    barBtn.tag = 11111;
//    barBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    barBtn.frame = CGRectMake(kUIScreenWidth-90, 6, 60, 30);
    [barBtn setTitle:@"    全 部" forState:UIControlStateNormal];
    [barBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didClickRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:barBtn];
    
    r.tintColor = [UIColor grayColor];
    self.navigationItem.rightBarButtonItem = r;
    [self getMessage:nil];
    [self initTableView];
}

-(void)initTableView
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 44)];
    [self.searchBar.layer setBorderColor:MakeColor(241, 241, 241).CGColor];
    [self.searchBar.layer setBorderWidth:1.0];
    [self.searchBar setBarTintColor:MakeColor(241, 241, 241)];
    self.searchaDisplay = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchaDisplay.searchResultsDelegate = self;
    self.searchaDisplay.searchResultsDataSource = self;
    self.searchaDisplay.delegate = self;
    
   self.finishTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, self.view.frame.size.height)];
    self.status = @"";
    self.finishTableView.delegate = self;
    self.finishTableView.dataSource = self;
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

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [self.filteredArray removeAllObjects];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchText];
    NSArray *tempArray = [self.telArray filteredArrayUsingPredicate:pred];
    
    self.filteredArray = [NSMutableArray arrayWithArray:tempArray];
    
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
//    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    [self getMessage:searchString];
    return YES;
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // 当用户改变搜索范围时，让列表的数据来源重新加载数据
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // 返回YES，让table view重新加载。
    return YES;
}

//~~~~~~~~
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
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [params setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    [params setObject:[NSNumber numberWithInt:pageNum] forKey:@"pageNum"];
    if (self.status.length) {
        [params setObject:self.status forKey:@"status"];
        
    }
    
    if (phone.length) {
        [params setObject:phone forKey:@"phoneKey"];
    }
    [RedScarf_API requestWithURL:@"/task/taskByStatus" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
           
            for (NSMutableDictionary *dic in [[result objectForKey:@"msg"] objectForKey:@"list"]) {
                NSLog(@"dic = %@",dic);
                Model *model = [[Model alloc] init];
                model.nameStr = [dic objectForKey:@"username"];
                model.chuLiStr = [dic objectForKey:@"username"];
                model.buyerStr = [dic objectForKey:@"customername"];
                model.telStr = [dic objectForKey:@"mobile"];
                [self.telArray addObject:model.telStr];
                model.addressStr = [dic objectForKey:@"apartmentname"];
                model.foodStr = [dic objectForKey:@"content"];
                model.dateStr = [dic objectForKey:@"endDate"];
                model.numberStr = [dic objectForKey:@"sn"];
                model.status = [dic objectForKey:@"status"];
                [self.dataArr addObject:model];
            }
            
            [self.finishTableView reloadData];
        }else{
            [self alertView:[result objectForKey:@"msg"]];
        }
        [footView endRefreshing];
        [headView endRefreshing];
        [self hidHUD];
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
   
//    if ([tableView isEqual:self.searchaDisplay.searchResultsTableView]) {
//        return self.filteredArray.count;
//        
//    }else{
         return self.dataArr.count;
//    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 12;
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
    return 160;
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
//    
//    if ([tableView isEqual:self.searchaDisplay.searchResultsTableView]) {
//        
//        NSString *tel = [self.telArray objectAtIndex:indexPath.section];
//        for (Model *m in self.dataArr) {
//            if ([m.telStr isEqualToString:tel]) {
//                model = m;
//            }
//        }
//        
//    }else{
        model = [self.dataArr objectAtIndex:indexPath.section];
//    }
    
    cell.nameLabel.text = [NSString stringWithFormat:@"配送人:%@",model.nameStr];
    cell.chuLiLabel.text = [NSString stringWithFormat:@"处理：%@",model.dateStr];
    cell.buyerLabel.text = [NSString stringWithFormat:@"收货人：%@",model.buyerStr];
    cell.telLabel.text = [NSString stringWithFormat:@"%@",model.telStr];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@",model.addressStr];
    cell.foodLabel.text = [NSString stringWithFormat:@"%@",model.foodStr];
//        cell.dateLabel.text = [NSString stringWithFormat:@"下单：%@",model.dateStr];
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

-(void)viewWillDisappear:(BOOL)animated
{
    [[self.navigationController.navigationBar viewWithTag:11111] removeFromSuperview];
    [self.tabBarController.view viewWithTag:11011].hidden = NO;
    [self.tabBarController.view viewWithTag:22022].hidden = NO;
    [[self.navigationController.navigationBar viewWithTag:2020] removeFromSuperview];


}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
