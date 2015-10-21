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
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分餐点";
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = color242;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[defaults objectForKey:@"count"] containsString:@"8"]) {
        [self initSeparateBtn];
        
    }else{
        [self initTableView];
        [self initBtn];
    }
    [self initView];
}

-(void)initTableView
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    headTableView.tag = 999;
    if ([[defaults objectForKey:@"count"] containsString:@"8"]) {
         headTableView = [[HeadDisTableView alloc] initWithFrame:CGRectMake(10, 124,kUIScreenWidth-20, kUIScreenHeigth-245)];
    }else{
         headTableView = [[HeadDisTableView alloc] initWithFrame:CGRectMake(10, 20,kUIScreenWidth-20, kUIScreenHeigth-130)];
    }
    
//    headTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 114,kUIScreenWidth-20, kUIScreenHeigth-130)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = color242;
    self.dataArray = [NSMutableArray array];
    [self.view addSubview:self.tableView];
    [self getMessage];
}

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    
    [RedScarf_API requestWithURL:@"/task/meals" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            [self.dataArray removeAllObjects];
            for (NSMutableDictionary *dic in [[result objectForKey:@"msg"] objectForKey:@"list"]) {
                NSLog(@"dic = %@",dic);
                [self.dataArray addObject:dic];
                
            }
            [self.tableView reloadData];
        }
    }];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth-20, 30)];
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-20)/3*i, 0, (kUIScreenWidth-20)/3, 30)];
        [view addSubview:label];
        label.backgroundColor = color234;
        label.textColor = color155;
        label.font = textFont14;
        label.textAlignment = NSTextAlignmentCenter;
        if (i == 0) {
            label.frame = CGRectMake(0, 0, (kUIScreenWidth-20)/5*2, 30);
            label.text = @"套餐编号";
        }
        if (i == 1) {
            label.frame = CGRectMake((kUIScreenWidth-20)/5*2, 0, (kUIScreenWidth-20)/5*2, 30);
            label.text = @"菜品名称";
        }
        if (i == 2) {
            label.frame = CGRectMake((kUIScreenWidth-20)/5*4, 0, (kUIScreenWidth-20)/5, 30);
            label.text = @"数量";
        }
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    return cell.frame.size.height;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier3";
    SeparateTableViewCell *cell = [[SeparateTableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    NSMutableDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];

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
    btn.frame = CGRectMake(kUIScreenWidth/2-39.5, kUIScreenHeigth-87.5, 70, 70);
    [btn setBackgroundImage:[UIImage imageNamed:@"qupeisong2x"] forState:UIControlStateNormal];
    [self.view addSubview:btn];
}

-(void)didClickPeiSong
{
    GoPeiSongViewController *goPeiSongVC = [[GoPeiSongViewController alloc] init];
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
