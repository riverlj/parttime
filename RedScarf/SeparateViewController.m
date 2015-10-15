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

@interface SeparateViewController ()

@end

@implementation SeparateViewController
{
    HeadDisTableView *headTableView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"分餐点";
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = color242;
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    if ([app.count containsString:@"8"]) {
        [self initSeparateBtn];
        
    }else{
        [self initTableView];
        [self initBtn];
    }
    [self initView];
}

-(void)initTableView
{
     AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    headTableView.tag = 999;
    if ([app.count containsString:@"8"]) {
         headTableView = [[HeadDisTableView alloc] initWithFrame:CGRectMake(10, 124,kUIScreenWidth-20, kUIScreenHeigth-130)];
    }else{
         headTableView = [[HeadDisTableView alloc] initWithFrame:CGRectMake(10, 20,kUIScreenWidth-20, kUIScreenHeigth-130)];
    }
    
    headTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
            label.frame = CGRectMake((kUIScreenWidth-20)/3*i, 0, (kUIScreenWidth-20)/3-30, 30);
            label.text = @"套餐编号";
        }
        if (i == 1) {
            label.frame = CGRectMake((kUIScreenWidth-20)/3*i-30, 0, (kUIScreenWidth-20)/3+60, 30);
            label.text = @"菜品名称";
        }
        if (i == 2) {
            label.frame = CGRectMake((kUIScreenWidth-20)/3*i+30, 0, (kUIScreenWidth-20)/3-30, 30);
            label.text = @"数量";
        }
    }
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier3";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    NSMutableDictionary *dic = [self.dataArray objectAtIndex:indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILabel *typeLabel;
    
    typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (kUIScreenWidth-20)/3-30, 35)];
    typeLabel.textAlignment = NSTextAlignmentCenter;
    typeLabel.textColor = MakeColor(50, 122, 255);
    typeLabel.text = [dic objectForKey:@"tag"];
    typeLabel.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:typeLabel];
    
    NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"content"]];
    CGSize size = CGSizeMake((kUIScreenWidth-20)/3, 35);
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/3, 0, 0, 0)];
    CGSize labelSize = [str sizeWithFont:addressLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    UILabel *taskNum;
    addressLabel.textAlignment = NSTextAlignmentCenter;
    addressLabel.frame = CGRectMake(kUIScreenWidth/3-30, 0, (kUIScreenWidth-20)/3+60, 35);
    taskNum = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-20)/3*2+30, 14, (kUIScreenWidth-20)/3-30, 15)];
    taskNum.textAlignment = NSTextAlignmentCenter;
    addressLabel.text = str;
    addressLabel.font = [UIFont systemFontOfSize:12];
    addressLabel.textColor = MakeColor(75, 75, 75);
    [cell.contentView addSubview:addressLabel];
    
    taskNum.font = [UIFont systemFontOfSize:13];
    taskNum.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]];
    taskNum.textColor = MakeColor(75, 75, 75);
    [cell.contentView addSubview:taskNum];
    
    UIView *midLineView = [[UIView alloc] initWithFrame:CGRectMake((kUIScreenWidth-20)/3-30, 0, 0.5, 35)];
    midLineView.backgroundColor = color234;
    [cell.contentView addSubview:midLineView];
    UIView *midLineView1 = [[UIView alloc] initWithFrame:CGRectMake((kUIScreenWidth-20)/3*2+30, 0, 0.5, 35)];
    midLineView1.backgroundColor = color234;
    [cell.contentView addSubview:midLineView1];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 34.5, kUIScreenWidth-20, 0.5)];
    lineView.backgroundColor = color234;
    [cell.contentView addSubview:lineView];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}



-(void)initBtn
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-30, kUIScreenHeigth-125, 60, 15)];
    label.textAlignment = NSTextAlignmentCenter;
    label.tag = 666;
    label.font  =textFont12;
    label.textColor = color155;
    label.text = @"早餐领完?";
    [self.view addSubview:label];
    
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-42, kUIScreenHeigth-100, 84, 84)];
    image.backgroundColor = MakeColor(195, 224, 250);
    image.tag = 777;
    image.layer.cornerRadius = 40;
    image.layer.masksToBounds = YES;
    [self.view addSubview:image];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [btn addTarget:self action:@selector(didClickPeiSong) forControlEvents:UIControlEventTouchUpInside];
    btn.tag = 888;
    btn.frame = CGRectMake(kUIScreenWidth/2-40, kUIScreenHeigth-98, 80, 80);
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
