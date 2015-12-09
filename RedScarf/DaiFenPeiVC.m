//
//  DaiFenPeiVC.m
//  RedScarf
//
//  Created by zhangb on 15/8/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "DaiFenPeiVC.h"
#import "Header.h"
#import "ModTableViewCell.h"
#import "AddressEditingCell.h"
#import "AllocatingTaskVC.h"
#import "UIView+ViewController.h"
#import "AppDelegate.h"
#import "UIUtils.h"

@implementation DaiFenPeiVC
{
    BOOL userBool;
    UIBarButtonItem *rightBtn;
    UIButton *feipeiBtn;
    NSMutableArray *numArr;
}
-(void)viewWillAppear:(BOOL)animated
{
    //隐藏tabbar上的按钮
    UIButton *barBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [barBtn removeFromSuperview];
    [self comeBack:nil];
    [self getMessage];
    [self comeBack:nil];
    [super viewWillAppear:animated];
}

-(void)viewDidLoad
{
    self.navigationController.navigationBar.hidden = NO;
    self.view.backgroundColor = color242;
//    self.navigationController.navigationBar.barTintColor = MakeColor(32, 102, 208);
    
    userBool = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.dataArray = [NSMutableArray array];
    numArr = [NSMutableArray array];
    self.title = self.titleStr;
    [self initNavigation];
    [self initTableView];
    [self getMessage];
    [self initFootBtn];
    
}

-(void)initNavigation
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comeback"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
   
}

-(void)initFootBtn
{
    feipeiBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    feipeiBtn.frame = CGRectMake(0, kUIScreenHeigth-50, kUIScreenWidth, 50);
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kUIScreenHeigth-51, kUIScreenWidth, 1)];
    line.backgroundColor = color242;
    [self.view addSubview:line];
    
    [feipeiBtn setTitle:@"分配" forState:UIControlStateNormal];
    [feipeiBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    feipeiBtn.backgroundColor = [UIColor whiteColor];
    [feipeiBtn addTarget:self action:@selector(didClickFenPeiBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:feipeiBtn];
    
    UIImageView *footImage = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-37, 16, 20, 18)];
    footImage.image = [UIImage imageNamed:@"fenpei"];
//    [feipeiBtn addSubview:footImage];

}

-(void)initTableView
{
    self.addressTableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 15,kUIScreenWidth-30 , kUIScreenHeigth-50)];
    self.addressTableView.delegate = self;
    self.addressTableView.dataSource = self;
    self.addressTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self viewDidLayoutSubviews];
    self.addressTableView.backgroundColor = color242;
    [self.view addSubview:self.addressTableView];
}

-(void)viewDidLayoutSubviews {
    
    if ([self.addressTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.addressTableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
    if ([self.addressTableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.addressTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

-(void)getMessage
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    NSString *url = nil;
    [params setObject:app.tocken forKey:@"token"];
    [params setObject:self.aId forKey:@"aId"];
    if (self.number == 0) {
        [params setObject:self.userId forKey:@"userId"];
        url = @"/task/assignTaskByRoom";
    }else{
        url = @"/task/waitAssignTaskByRoom";
    }
    [RSHttp requestWithURL:url params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [self.dataArray removeAllObjects];
        for (NSMutableDictionary *dic in [data objectForKey:@"msg"]) {
            NSLog(@"dic = %@",dic);
            [self.dataArray addObject:dic];
        }
        [self.addressTableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    AddressEditingCell *cell = [[AddressEditingCell alloc] init];
    if (cell == nil)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = color242;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = [self.dataArray objectAtIndex:indexPath.row];
    
    NSString *str = [dic objectForKey:@"room"];
    CGSize size = CGSizeMake(kUIScreenWidth-80, 40);
    CGSize labelSize = [str sizeWithFont:cell.nameLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    cell.nameLabel.frame = CGRectMake(40, 0, labelSize.width, 45);
    cell.nameLabel.text = str;
    
    UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(cell.nameLabel.frame.size.width+cell.nameLabel.frame.origin.x+10, 2, 45, 40)];
    count.font = textFont16;
    count.textColor = color155;
    count.text = [NSString stringWithFormat:@"%@份",[dic objectForKey:@"taskNum"]];
    [cell.contentView addSubview:count];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AddressEditingCell *cell = (AddressEditingCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (cell.roundBtn.image == nil) {
        [cell.roundBtn setImage:[UIImage imageNamed:@"xuanzhong"]];
        [numArr addObject:[NSNumber numberWithInteger:indexPath.row]];
        [feipeiBtn setBackgroundColor:colorblue];
        [feipeiBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    }else{
        [numArr removeObject:[NSNumber numberWithInteger:indexPath.row]];

        [cell.roundBtn setImage:nil];

        if (numArr.count == 0) {
            feipeiBtn.backgroundColor = [UIColor whiteColor];
            [feipeiBtn setTitleColor:colorblue forState:UIControlStateNormal];

        }
    }
    
    self.num = indexPath.row;
    
}

-(void)didClickFenPeiBtn
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSString *room = @"";
    NSLog(@"num = %d",self.num);
    //选中的房间号
    for (NSNumber *num in numArr) {
        int index = [num intValue];
        dic = [self.dataArray objectAtIndex:index];
        room = [room stringByAppendingFormat:@"%@,",[dic objectForKey:@"room"]];
    }
    NSLog(@"aid = %@,room = %@",self.aId,room);

    if ([feipeiBtn.backgroundColor isEqual: colorblue]) {
        AllocatingTaskVC *allocatingVC = [[AllocatingTaskVC alloc] init];
        allocatingVC.aId = self.aId;
        allocatingVC.room = room;
        //已分配有userId
        if (self.number == 0)
        {
            allocatingVC.number = 0;
            allocatingVC.userId = self.userId;
        }else{
            allocatingVC.number = 1;
        }
        [self.navigationController pushViewController:allocatingVC animated:YES];

    }
    
}

-(void)didClickLeft
{
    if (self.number == 0) {
        [self.delegate returnNameOfTableView:@"yi"];
    }else{
        [self.delegate returnNameOfTableView:@"wei"];
    }
    
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
