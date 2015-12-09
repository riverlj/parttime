//
//  SeparateViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "SeparateViewController.h"
#import "HeadDisTableView.h"
#import "GoPeiSongViewController.h"
#import "SeparateTableViewCell.h"

@interface SeparateViewController ()

@end

@implementation SeparateViewController
{
    HeadDisTableView *headTableView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分餐点";
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = color242;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"count"] rangeOfString:@"8"].location != NSNotFound) {
        [self initSeparateBtn];
        [self initView];
    }else{
        [self initTableView];
        [self initBtn];
    }
    
}

-(void)initTableView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    headTableView.tag = 999;
    if ([[defaults objectForKey:@"count"] rangeOfString:@"8"].location != NSNotFound) {
         headTableView = [[HeadDisTableView alloc] initWithFrame:CGRectMake(10, 124,kUIScreenWidth-20, kUIScreenHeigth-245)];
    }else{
         headTableView = [[HeadDisTableView alloc] initWithFrame:CGRectMake(10, 20,kUIScreenWidth-20, kUIScreenHeigth-130)];
    }
    
    UIView *foot = [[UIView alloc] init];
    headTableView.tableFooterView = foot;
    headTableView.backgroundColor = color242;
    [self.view addSubview:headTableView];
}

-(void)initSeparateBtn
{
    for (int i = 0; i < 2; i++) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kUIScreenWidth/2*i, 63.5, kUIScreenWidth/2, 40)];
        [self.view addSubview:btn];
        
        btn.layer.borderColor = color232.CGColor;
        btn.layer.borderWidth = 0.5;
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.font = textFont14;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if (i == 0) {
            btn.tag = 100;
            [btn setTitleColor:colorblue forState:UIControlStateNormal];
            [btn setTitle:@"学校详情" forState:UIControlStateNormal];
        }
        if (i == 1) {
            btn.tag = 101;
            [btn setTitle:@"个人取餐" forState:UIControlStateNormal];
        }
        [btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)didClickBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 100) {
        
        UIButton *button = (UIButton *)[self.view viewWithTag:101];
        if ([btn.titleLabel.textColor isEqual:[UIColor blackColor]]) {
            [btn setTitleColor:colorblue forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:colorblue forState:UIControlStateNormal];
        }
        
        [[self.view viewWithTag:666] removeFromSuperview];
        [[self.view viewWithTag:777] removeFromSuperview];
        [[self.view viewWithTag:888] removeFromSuperview];
        [headTableView removeFromSuperview];
        [self initView];
    }
    if (btn.tag == 101) {
        UIButton *button = (UIButton *)[self.view viewWithTag:100];
        if ([btn.titleLabel.textColor isEqual:[UIColor blackColor]]) {
            [btn setTitleColor:colorblue forState:UIControlStateNormal];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [button setTitleColor:colorblue forState:UIControlStateNormal];
        }
        [self.tableView removeFromSuperview];
        [self initTableView];
        [self initBtn];

    }
}

-(void)initView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 104,kUIScreenWidth-20, kUIScreenHeigth-130)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = color242;
    self.dataArray = [NSMutableArray array];
    UIView *foot = [[UIView alloc] init];
    self.tableView.tableFooterView = foot;
    [self.view addSubview:self.tableView];
    [self getMessage];
}

-(void)getMessage
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [RSHttp requestWithURL:@"/task/distPointMeals" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSArray *arr = [NSArray arrayWithArray:[[data objectForKey:@"msg"] objectForKey:@"list"]];
        if (![arr count]) {
            [self.view addSubview:[self named:@"meiyoucanpin" text:@"餐品"]];
        }
        
        [self.dataArray removeAllObjects];
        for (NSMutableDictionary *dic in [[data objectForKey:@"msg"] objectForKey:@"list"]) {
            NSLog(@"dic = %@",dic);
            [self.dataArray addObject:dic];
        }
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableDictionary *dic = [self.dataArray objectAtIndex:section];
    NSMutableArray *contentList = [dic objectForKey:@"contentList"];
    return contentList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSMutableDictionary *dic = [self.dataArray objectAtIndex:section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth-20, 80)];
    view.backgroundColor = color242;
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kUIScreenWidth-20, 30)];
    name.text = [dic objectForKey:@"name"];
    name.textColor = color155;
    name.font = textFont16;
    [view addSubview:name];
    
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-20)/3*i, 30, (kUIScreenWidth-20)/3, 30)];
        [view addSubview:label];
        label.backgroundColor = color234;
        label.textColor = color155;
        label.font = textFont14;
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            label.frame = CGRectMake(0, 50, (kUIScreenWidth-20)/5*2, 30);
            label.text = @"套餐编号";
        }
        if (i == 1) {
            label.frame = CGRectMake((kUIScreenWidth-20)/5*2, 50, (kUIScreenWidth-20)/5*2, 30);
            label.text = @"菜品名称";
        }
        if (i == 2) {
            label.frame = CGRectMake((kUIScreenWidth-20)/5*4, 50, (kUIScreenWidth-20)/5, 30);
            label.text = @"数量";
        }
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SeparateTableViewCell *cell = (SeparateTableViewCell *)[self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier3";
    SeparateTableViewCell *cell = [[SeparateTableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    NSMutableDictionary *contentDic = [self.dataArray objectAtIndex:indexPath.section];
    
    NSMutableArray *contentList = [contentDic objectForKey:@"contentList"];
    
    if (contentList.count) {
        NSMutableDictionary *dic = [contentList objectAtIndex:indexPath.row];
        
        cell.typeLabel.text = [dic objectForKey:@"tag"];
        
        NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
        [cell setIntroductionText:str];
        
        cell.numLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]];
        
        UIView *midLineView = [[UIView alloc] initWithFrame:CGRectMake((kUIScreenWidth-20)/5*2, 0, 0.5, cell.foodLabel.frame.size.height)];
        midLineView.backgroundColor = color234;
        [cell.contentView addSubview:midLineView];
        UIView *midLineView1 = [[UIView alloc] initWithFrame:CGRectMake((kUIScreenWidth-20)/5*4, 0, 0.5, cell.foodLabel.frame.size.height)];
        midLineView1.backgroundColor = color234;
        [cell.contentView addSubview:midLineView1];

    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



-(void)initBtn
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-30, kUIScreenHeigth-110, 60, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = 666;
    label.font  =textFont12;
    label.textColor = color155;
    label.text = @"早餐领完?";
    [self.view addSubview:label];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-42, kUIScreenHeigth-90, 75, 75)];
    image.backgroundColor = MakeColor(195, 224, 250);
    image.tag = 777;
    image.layer.cornerRadius = 37;
    image.layer.masksToBounds = YES;
    [self.view addSubview:image];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn addTarget:self action:@selector(didClickPeiSong) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 888;
    [btn setTitle:@"qusongcan2" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    btn.frame = CGRectMake(kUIScreenWidth/2-39.5, kUIScreenHeigth-87.5, 70, 70);
    [btn setBackgroundImage:[UIImage imageNamed:@"qupeisong2x"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

-(void)didClickPeiSong
{
    GoPeiSongViewController *goPeiSongVC = [[GoPeiSongViewController alloc] init];
    [[BaiduMobStat defaultStat] logEvent:@"qusongcan2" eventLabel:@"button2"];

    [self.navigationController pushViewController:goPeiSongVC animated:YES];
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
