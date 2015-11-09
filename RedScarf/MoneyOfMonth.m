//
//  MoneyOfMonth.m
//  RedScarf
//
//  Created by zhangb on 15/8/26.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "MoneyOfMonth.h"
#import "FourRowsCell.h"
#import "ThreeRowsCell.h"
#import "DetailMoneyOfMonth.h"

@implementation MoneyOfMonth
{
    
    NSString *dateStr;
    NSString *string;
    NSMutableArray *eveydayArray;
    NSMutableArray *salayArray;
    int tag;
    UILabel *dateLabel;
    NSString *settledSum,*unsettledSum;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
    [self comeBack:nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[self.navigationController.navigationBar viewWithTag:30001] removeFromSuperview];
    
}

-(void)viewDidLoad
{
    self.title = @"我的工资";
    
    self.view.backgroundColor = color242;
    
    self.navigationController.navigationBar.hidden = NO;
    
    eveydayArray = [NSMutableArray array];
    salayArray = [NSMutableArray array];
    tag = 0;
    self.tabBarController.tabBar.hidden = YES;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM:"];
    string = [formatter stringFromDate:now];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    string = [string stringByReplacingOccurrencesOfString:@":" withString:@"月"];
    
    dateStr = @"";
    dateStr = [string stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    dateStr = [NSString stringWithFormat:@"%@01",dateStr];
    [self getMessage];
    
    [self navigationBar];
    [self initTableView];
    
}

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [params setObject:dateStr forKey:@"date"];
    [RedScarf_API requestWithURL:@"/salary/month/v2" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            [eveydayArray removeAllObjects];
            settledSum = [NSString stringWithFormat:@"%@",[[result objectForKey:@"msg"] objectForKey:@"settledSum"]];
            UILabel *money = (UILabel *)[self.view viewWithTag:6666];
            money.text = settledSum;
            
            unsettledSum = [NSString stringWithFormat:@"%@",[[result objectForKey:@"msg"] objectForKey:@"unsettledSum"]];
            UILabel *money1 = (UILabel *)[self.view viewWithTag:7777];
            money1.text = unsettledSum;
            
            for (NSMutableDictionary *dic in [[result objectForKey:@"msg"] objectForKey:@"list"]) {
                NSLog(@"dic = %@",dic);
                [eveydayArray addObject:[dic objectForKey:@"date"]];
                [salayArray addObject:[dic objectForKey:@"sum"]];
            }
            [self.tableView reloadData];
        }else{
            [self alertView:[result objectForKey:@"msg"]];
        }
    }];
}

-(void)initTableView
{
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 54)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 53, kUIScreenWidth, 1)];
    line.backgroundColor = color232;
    [bgView addSubview:line];
    
    dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-60, 0, 120, 54)];
    dateLabel.textAlignment = NSTextAlignmentCenter;
    dateLabel.text = string;
    [bgView addSubview:dateLabel];
    dateLabel.textColor = colorblue;
    
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [leftBtn addTarget:self action:@selector(leftBtn) forControlEvents:UIControlEventTouchUpInside];
    leftBtn.frame = CGRectMake(kUIScreenWidth/4-30, 12, 30, 30);
    [leftBtn setBackgroundImage:[UIImage imageNamed:@"zuo"] forState:UIControlStateNormal];
    [bgView addSubview:leftBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [rightBtn addTarget:self action:@selector(rightBtn) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.frame = CGRectMake(kUIScreenWidth/4*3, 12, 30, 30);
    [rightBtn setBackgroundImage:[UIImage imageNamed:@"newyou"] forState:UIControlStateNormal];
    [bgView addSubview:rightBtn];
    
    
    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(15, bgView.frame.size.height+bgView.frame.origin.y+15, kUIScreenWidth-30, 54)];
    midView.backgroundColor = [UIColor whiteColor];
    midView.layer.cornerRadius = 5;
    midView.layer.masksToBounds = YES;
    midView.layer.borderColor = color232.CGColor;
    midView.layer.borderWidth = 0.5;
    [self.view addSubview:midView];
    
    UIView *midLineView = [[UIView alloc] initWithFrame:CGRectMake(midView.frame.size.width/2, 10, 1, 34)];
    midLineView.backgroundColor = color232;
    [midView addSubview:midLineView];
    
    UILabel *yijisuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(midView.frame.size.width/4-50, 0, 100, 54)];
    yijisuanLabel.textColor = colorblue;
    yijisuanLabel.numberOfLines = 2;
    yijisuanLabel.tag = 6666;
    yijisuanLabel.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已结算金额\n%@",settledSum]];
    [str addAttribute:NSForegroundColorAttributeName value:color155 range:NSMakeRange(0,5)];
    yijisuanLabel.attributedText = str;
    yijisuanLabel.font = textFont14;
    [midView addSubview:yijisuanLabel];
    
    UILabel *weijisuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(midView.frame.size.width/4*3-50, 0, 100, 54)];
    weijisuanLabel.text = [NSString stringWithFormat:@"未结算金额\n%@",unsettledSum];
    weijisuanLabel.numberOfLines = 2;
    weijisuanLabel.tag = 7777;
    weijisuanLabel.textAlignment = NSTextAlignmentCenter;
    weijisuanLabel.textColor = color155;
    weijisuanLabel.font = textFont14;
    [midView addSubview:weijisuanLabel];
    
    if (kUIScreenWidth == 320) {
         self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, midView.frame.size.height+midView.frame.origin.y+15, kUIScreenWidth-30, kUIScreenHeigth/2)];
    }else{
         self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, midView.frame.size.height+midView.frame.origin.y+15, kUIScreenWidth-30, kUIScreenHeigth/2+50)];
    }
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.borderColor = color242.CGColor;
    self.tableView.backgroundColor = color242;
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return eveydayArray.count;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(15, 0, kUIScreenWidth-30, 30)];
    view.backgroundColor = MakeColor(240, 240, 240);
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*view.frame.size.width/2, 0, view.frame.size.width/2, 30)];
        [view addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = MakeColor(87, 87, 87);
        label.font = [UIFont systemFontOfSize:12];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = MakeColor(229, 229, 229);
        [view addSubview:line];
        if (i == 0) {
            label.text = @"处理日期";
        }
        if (i == 1) {
            label.text = @"金额";
            line.frame = CGRectMake(i*view.frame.size.width/2, 0, 1, 30);
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    for (int i = 1; i < 2; i++) {
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = MakeColor(229, 229, 229);
        line.frame = CGRectMake(i*((kUIScreenWidth-30)/2), 0, 1, 40);
        [cell.contentView addSubview:line];
        
    }
    //点击没有选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    
        UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,(kUIScreenWidth-30)/2 , 40)];
        date.text = [NSString stringWithFormat:@"%@",[eveydayArray objectAtIndex:indexPath.row]];
        date.font = [UIFont systemFontOfSize:13];
        date.textAlignment = NSTextAlignmentCenter;
        date.textColor = MakeColor(75, 75, 75);
        [cell.contentView addSubview:date];

        UIButton *totalCount = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        totalCount.frame = CGRectMake((kUIScreenWidth-30)/2, 0, (kUIScreenWidth-30)/2-35, 40);
        [totalCount setTitle:[NSString stringWithFormat:@"%@",salayArray[indexPath.row]] forState:UIControlStateNormal];
        [totalCount setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
        [cell.contentView addSubview:totalCount];
    
    UIButton *detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(totalCount.frame.origin.x+totalCount.frame.size.width, 12, 15, 15)];
    [cell.contentView addSubview:detailBtn];
    [detailBtn setBackgroundImage:[UIImage imageNamed:@"xiangqin"] forState:UIControlStateNormal];
     detailBtn.tag = indexPath.row;
    [detailBtn addTarget:self action:@selector(DetailMoneyOfMonth:) forControlEvents:UIControlEventTouchUpInside];
    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
}

-(void)DetailMoneyOfMonth:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"btn.tag = %ld",(long)btn.tag);
    
    DetailMoneyOfMonth *detailVC = [[DetailMoneyOfMonth alloc] init];
    detailVC.deatilSalary = [eveydayArray objectAtIndex:btn.tag];
    
    
    [self.navigationController pushViewController:detailVC animated:YES];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)leftBtn
{
    NSDate *date = [NSDate date];
    tag--;
    NSTimeInterval interval = 30*24*60*60*tag;
    NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM:"];
    NSString *Str = [formatter stringFromDate:date1];
    Str = [Str stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    Str = [Str stringByReplacingOccurrencesOfString:@":" withString:@"月"];
    
    dateLabel.text = Str;
    dateStr = [Str stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    dateStr = [NSString stringWithFormat:@"%@01",dateStr];
    [self getMessage];
}

-(void)rightBtn
{
    NSDate *date = [NSDate date];
    tag++;
    NSTimeInterval interval = 30*24*60*60*tag;
    NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM:"];
    NSString *Str = [formatter stringFromDate:date1];
    Str = [Str stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    Str = [Str stringByReplacingOccurrencesOfString:@":" withString:@"月"];
    
    
    dateStr = [Str stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    
    //判断月份是否大于当前月
    NSString *dateString = dateStr;
    dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"年" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"月" withString:@""];
    if ([dateString intValue] > [string intValue]) {
        tag--;
        [self alertView:@"查询月份不能大于当前月"];
        return;
    }else{
        dateLabel.text = Str;
        dateStr = [NSString stringWithFormat:@"%@01",dateStr];
        [self getMessage];
    }
    
}


@end
