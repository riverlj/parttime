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
    self.title = @"已处理";

    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    hidden = NO;
    self.dataArr = [NSMutableArray array];

    [self comeBack:nil];
    
    pageNum = 1;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"xiangxia@2x"] style:UIBarButtonItemStylePlain target:self action:nil];
    UIButton *barBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    barBtn.tag = 11111;
//    barBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    barBtn.frame = CGRectMake(kUIScreenWidth-90, 6, 60, 30);
    [barBtn setTitle:@"    全 部" forState:UIControlStateNormal];
    [barBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [barBtn addTarget:self action:@selector(didClickRight:) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:barBtn];
    
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
    [self getMessage];
    [self initTableView];
}

-(void)initTableView
{
   self.finishTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.status = @"";
    self.finishTableView.delegate = self;
    self.finishTableView.dataSource = self;
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

//~~~~~~~~
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    if ([refreshView isKindOfClass:[MJRefreshHeaderView class]]) {
        
    }else{
        pageNum += 1;
        [self getMessage];
    }
   
}

-(void)getMessage
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
    return self.dataArr.count;
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
    
    Model *model = [[Model alloc] init];
    model = [self.dataArr objectAtIndex:indexPath.section];
    cell.nameLabel.text = [NSString stringWithFormat:@"配送人：%@",model.nameStr];
    cell.chuLiLabel.text = [NSString stringWithFormat:@"处理：%@",model.dateStr];
    cell.buyerLabel.text = [NSString stringWithFormat:@"收货人：%@",model.buyerStr];
    cell.telLabel.text = [NSString stringWithFormat:@"%@",model.telStr];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@",model.addressStr];
    cell.foodLabel.text = [NSString stringWithFormat:@"%@",model.foodStr];
//        cell.dateLabel.text = [NSString stringWithFormat:@"下单：%@",model.dateStr];
    cell.numberLabel.text = [NSString stringWithFormat:@"任务编号：%@",model.numberStr];
    if ([model.status isEqualToString:@"FINISHED"]) {
        [cell.noctionBtn setTitle:@"已送达" forState:UIControlStateNormal];
        cell.noctionBtn.backgroundColor = MakeColor(98, 206, 54);
    }if ([model.status isEqualToString:@"UNDELIVERED"]) {
        [cell.noctionBtn setTitle:@"未失败" forState:UIControlStateNormal];
        cell.noctionBtn.backgroundColor = MakeColor(238, 43, 41);
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
    button = (UIButton *)sender;

    if (hidden == NO) {
        for (int i=0; i<3; i++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(kUIScreenWidth-80, 64+i*40, 80, 40);
            btn.backgroundColor = MakeColor(48, 98, 209);
            btn.tag = 100+i;
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor whiteColor];
            line.frame = CGRectMake(0, 39, 100, 1);
            [btn addSubview:line];
            if (i == 0) {
                [btn setTitle:@"   全 部" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(all) forControlEvents:UIControlEventTouchUpInside];
            }else if (i == 1) {
                [btn setTitle:@"已送达" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(success) forControlEvents:UIControlEventTouchUpInside];
                
            }else{
                [btn setTitle:@"未送达" forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(fail) forControlEvents:UIControlEventTouchUpInside];
            }
            [self.view addSubview:btn];
        }
        
        hidden = YES;
    }else{
        [[self.view viewWithTag:100] removeFromSuperview];
        [[self.view viewWithTag:101] removeFromSuperview];
        [[self.view viewWithTag:102] removeFromSuperview];

        hidden = NO;

    }
}

-(void)all
{
    [self.dataArr removeAllObjects];
    [button setTitle:@"" forState:UIControlStateNormal];
    UIButton *btn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    btn.titleLabel.textAlignment = NSTextAlignmentRight;
    [btn setTitle:@"   全 部" forState:UIControlStateNormal];
    self.status = @"";
    [self getMessage];
    hidden = NO;
    [[self.view viewWithTag:100] removeFromSuperview];
    [[self.view viewWithTag:101] removeFromSuperview];
    [[self.view viewWithTag:102] removeFromSuperview];
}

-(void)success
{
    [self.dataArr removeAllObjects];
    [button setTitle:@"" forState:UIControlStateNormal];
    UIButton *btn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [btn setTitle:@"已送达" forState:UIControlStateNormal];
    self.status = @"FINISHED";
    [self getMessage];
    hidden = NO;
    [[self.view viewWithTag:100] removeFromSuperview];
    [[self.view viewWithTag:101] removeFromSuperview];
    [[self.view viewWithTag:102] removeFromSuperview];
}

-(void)fail
{
    [self.dataArr removeAllObjects];
    [button setTitle:@"" forState:UIControlStateNormal];
    UIButton *btn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [btn setTitle:@"未送达" forState:UIControlStateNormal];
    self.status = @"UNDELIVERED";
    [self getMessage];
    hidden = NO;
    [[self.view viewWithTag:100] removeFromSuperview];
    [[self.view viewWithTag:101] removeFromSuperview];
    [[self.view viewWithTag:102] removeFromSuperview];
}

-(void)viewWillDisappear:(BOOL)animated
{
    UIButton *btn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [btn setTitle:@"" forState:UIControlStateNormal];
    [self.tabBarController.view viewWithTag:101010].hidden = NO;

}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:101010].hidden = YES;
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
