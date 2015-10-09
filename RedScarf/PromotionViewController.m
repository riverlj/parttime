//
//  PromotionViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/25.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "PromotionViewController.h"
#import "Header.h"
#import "OrderCountsViewController.h"
#import "FunsViewController.h"
#import "TotalMoneyViewController.h"
#import "ListCell.h"
#import "RecommendViewController.h"
#import "MyFunsViewController.h"
#import "RuleOfActive.h"

@implementation PromotionViewController
{
    NSMutableArray *dataArray;
    NSMutableArray *nameArray;
    NSMutableArray *orderArray;
    NSMutableArray *countArray;
    NSMutableArray *photoArray;
    NSMutableArray *telArray;


}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:101010].hidden = YES;
    [self comeBack:nil];
}

-(void)viewDidLoad
{
    self.title = @"推广活动";
    self.view.backgroundColor = [UIColor whiteColor];

    self.navigationController.navigationBar.hidden = NO;
//    self.navigationController.navigationBar.barTintColor = MakeColor(32, 102, 208);
    self.tabBarController.tabBar.hidden = YES;
    dataArray = [NSMutableArray array];
    nameArray = [NSMutableArray array];
    orderArray = [NSMutableArray array];
    countArray = [NSMutableArray array];
    telArray = [NSMutableArray array];

    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 140, kUIScreenWidth, 1)];
    lineView.backgroundColor = MakeColor(240, 240, 240);
    [self.view addSubview:lineView];
    [self getMessage];
    [self navigationBar];
    [self initBtn];
    [self initTableView];
}

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:30] forKey:@"pageSize"];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    
    [RedScarf_API requestWithURL:@"/promotionActivity/index" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
//            for (NSMutableDictionary *dic in [result objectForKey:@"msg"]) {
            NSMutableDictionary *dic = [result objectForKey:@"msg"];
                NSLog(@"dic = %@",dic);
                dataArray = [dic objectForKey:@"otherUsers"];
                for (NSMutableDictionary *dic1 in [dic objectForKey:@"otherUsers"]) {
                    [nameArray addObject:[dic1 objectForKey:@"otherUserName"]];
                    [telArray addObject:[dic1 objectForKey:@"otherUserPhone"]];
                    [orderArray addObject:[dic1 objectForKey:@"otherUserYestdayOrder"]];
                    [countArray addObject:[dic1 objectForKey:@"otherUserTotalOrder"]];
                }
                for (int i = 0; i < 3; i++) {
                    UILabel *label = (UILabel *)[self.view viewWithTag:1000+i];
                    if (i==0) {
                        label.text = [dic objectForKey:@"fansTotal"];
                    }
                    if (i==1) {
                        label.text = [dic objectForKey:@"promoteAccount"];
                    }
                    if (i==2) {
                        label.text = [dic objectForKey:@"orderTotal"];
                    }
                }
            [self initArray];

//            }
            
        }
    }];
}

-(void)initBtn
{
    NSArray *pictureArr = [NSArray arrayWithObjects:@"tuijian@2x",@"fensi@2x",@"guize@2x", nil];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*kUIScreenWidth/3, 80, kUIScreenWidth/3, 25)];
        label.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:label];

        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.view addSubview:btn];
        [btn setTitleColor:MakeColor(75, 75, 75) forState:UIControlStateNormal];
        btn.frame = CGRectMake(i*kUIScreenWidth/3, 105, kUIScreenWidth/3, 25);
        btn.titleLabel.font = [UIFont systemFontOfSize:13];
        
        UIImageView *picture = [[UIImageView alloc] initWithFrame:CGRectMake((kUIScreenWidth-40)/3*i+10*(i+1), 150, (kUIScreenWidth-40)/3, 75)];
        picture.userInteractionEnabled = YES;
        [self.view addSubview:picture];
        
        if (i == 0) {
            [btn setTitle:@"推荐粉丝总数" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didClickFunsBtn:) forControlEvents:UIControlEventTouchUpInside];
            label.tag = 1000+i;
            label.text = @"0";
            
            picture.image = [UIImage imageNamed:pictureArr[i]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickRecommend)];
            tap.numberOfTapsRequired = 1;
            [picture addGestureRecognizer:tap];
        }
        if (i == 1) {
            [btn setTitle:@"推广费总金额" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didClickTotalMoneyBtn:) forControlEvents:UIControlEventTouchUpInside];
            
            label.text = @"0";
            label.tag = 1000+i;
            picture.image = [UIImage imageNamed:pictureArr[i]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickMyFuns)];
            tap.numberOfTapsRequired = 1;
            [picture addGestureRecognizer:tap];
        }
        if (i == 2) {
            [btn setTitle:@"推广总下单数" forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(didClickOrderCount:) forControlEvents:UIControlEventTouchUpInside];
            
            label.text = @"0";
            label.tag = 1000+i;
            picture.image = [UIImage imageNamed:pictureArr[i]];
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickRuleOfActive)];
            tap.numberOfTapsRequired = 1;
            [picture addGestureRecognizer:tap];
        }
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake((i+1)*kUIScreenWidth/3, 80, 1, 45)];
        line.backgroundColor = MakeColor(240, 240, 240);
        [self.view addSubview:line];
        
    }
}

-(void)didClickRecommend
{
    RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
    [self.navigationController pushViewController:recommendVC animated:YES];
}

-(void)didClickMyFuns
{
    MyFunsViewController *myFunsVC = [[MyFunsViewController alloc] init];
    [self.navigationController pushViewController:myFunsVC animated:YES];
}

-(void)didClickRuleOfActive
{
    RuleOfActive *ruleOfActiveVC = [[RuleOfActive alloc] init];
    [self.navigationController pushViewController:ruleOfActiveVC animated:YES];
}

-(void)initTableView
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-50, 250, 100, 10)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = MakeColor(87, 87, 87);
    label.text = @"推广大比拼";
    label.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:label];
    
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.origin.x+5, 250, 5, 10)];
    headView.image = [UIImage imageNamed:@"juxing@2x"];
    [self.view addSubview:headView];
    
    if (kUIScreenHeigth == 480) {
        self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 275, kUIScreenWidth-30, kUIScreenHeigth-275)];

    }else{
        self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 275, kUIScreenWidth-30, kUIScreenHeigth-150)];

    }
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    UIView *view = [[UIView alloc] init];
    self.listTableView.tableFooterView = view;
    [self.view addSubview:self.listTableView];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(LoopPlayback) userInfo:nil repeats:YES];
}

-(void)initArray
{
    photoArray = [NSMutableArray arrayWithObjects:@"1@2x",@"2@2x",@"3@2x", nil];

    for (int i = 3; i < nameArray.count; i++) {
        [photoArray addObject:[NSString stringWithFormat:@"%d",i+1]];
    }
}
//循环播放
-(void)LoopPlayback
{
    if (photoArray.count>5) {
        [photoArray addObject:[photoArray objectAtIndex:0]];
        [photoArray removeObjectAtIndex:0];
        [nameArray addObject:[nameArray objectAtIndex:0]];
        [nameArray removeObjectAtIndex:0];
        [orderArray addObject:[orderArray objectAtIndex:0]];
        [orderArray removeObjectAtIndex:0];
        [countArray addObject:[countArray objectAtIndex:0]];
        [countArray removeObjectAtIndex:0];
        [telArray addObject:[telArray objectAtIndex:0]];
        [telArray removeObjectAtIndex:0];
    }

    [self.listTableView reloadData];
}

-(void)didClickFunsBtn:(id)sender
{
    FunsViewController *funsVC = [[FunsViewController alloc] init];
    [self.navigationController pushViewController:funsVC animated:YES];
}

-(void)didClickTotalMoneyBtn:(id)sender
{
    TotalMoneyViewController *totalMoneyVC = [[TotalMoneyViewController alloc] init];
    [self.navigationController pushViewController:totalMoneyVC animated:YES];
}

-(void)didClickOrderCount:(id)sender
{
    OrderCountsViewController *orderCountVC = [[OrderCountsViewController alloc] init];
    [self.navigationController pushViewController:orderCountVC animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kUIScreenWidth-30, 30)];
    view.backgroundColor = MakeColor(240, 240, 240);
    for (int i = 0; i < 4; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*view.frame.size.width/4, 0, view.frame.size.width/4, 30)];
        [view addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = MakeColor(87, 87, 87);
        label.font = [UIFont systemFontOfSize:14];
        if (i == 0) {
            label.text = @"姓名";
        }
        if (i == 1) {
            label.text = @"电话号";
        }
        if (i == 2) {
            label.text = @"昨日下单";
        }
        if (i == 3) {
            label.text = @"推广总数";
        }
    }
    
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return nameArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    ListCell *cell = [[ListCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    if ([photoArray[indexPath.row] isEqualToString:@"1@2x"]||[photoArray[indexPath.row] isEqualToString:@"2@2x"]||[photoArray[indexPath.row] isEqualToString:@"3@2x"]) {
        cell.photoView.hidden = NO;
        cell.sort.hidden = YES;
        cell.photoView.image = [UIImage imageNamed:photoArray[indexPath.row]];

    }else
    {
        cell.photoView.hidden = YES;
        cell.sort.hidden = NO;
        cell.sort.text = photoArray[indexPath.row];

    }
    cell.name.text = nameArray[indexPath.row];
    cell.telLabel.text = telArray[indexPath.row];
    cell.order.text = orderArray[indexPath.row];
    cell.totalCount.text = countArray[indexPath.row];
    
    return cell;
}

-(void)navigationBar
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comeback"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
