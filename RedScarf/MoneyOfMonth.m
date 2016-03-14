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
#import "RuleOfActive.h"

@implementation MoneyOfMonth
{
    
    NSString *dateStr;
    NSString *string;
    NSMutableArray *eveydayArray;
    NSMutableArray *salayArray;
    NSMutableArray *settledDateArray;
    NSMutableArray *settleArray;
    int tag;
    UILabel *dateLabel;
    NSString *settledSum,*unsettledSum;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的工资";
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"说明" style:UIBarButtonItemStylePlain target:self action:@selector(clickShow)];
    self.navigationItem.rightBarButtonItem = right;
    
    settleArray = [NSMutableArray array];
    settledDateArray = [NSMutableArray array];
    eveydayArray = [NSMutableArray array];
    salayArray = [NSMutableArray array];
    tag = 0;
    
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    string = [formatter stringFromDate:now];
    
    dateStr = @"";

    dateStr = [NSString stringWithFormat:@"%@-01",string];
    [self getMessage];
    
    [self navigationBar];
    [self initTableView];
}

-(void)getMessage
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:dateStr forKey:@"date"];
    [RSHttp requestWithURL:@"/salary/month/v2" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [eveydayArray removeAllObjects];
        [settleArray removeAllObjects];
        [salayArray removeAllObjects];
        [settledDateArray removeAllObjects];
        settledSum = [NSString stringWithFormat:@"%@",[[data objectForKey:@"body"] objectForKey:@"settledSum"]];
        UILabel *money = (UILabel *)[self.view viewWithTag:6666];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已结算金额\n%@",settledSum]];
        [str addAttribute:NSForegroundColorAttributeName value:color155 range:NSMakeRange(0,5)];
        money.attributedText = str;
                
        unsettledSum = [NSString stringWithFormat:@"%@",[[data objectForKey:@"body"] objectForKey:@"unsettledSum"]];
        UILabel *money1 = (UILabel *)[self.view viewWithTag:7777];
        money1.text = [NSString stringWithFormat:@"未结算金额\n%@",unsettledSum];
        
        for (NSMutableDictionary *dic in [[data objectForKey:@"body"] objectForKey:@"list"]) {
            NSLog(@"dic = %@",dic);
            [eveydayArray addObject:[dic objectForKey:@"date"]];
            [salayArray addObject:[dic objectForKey:@"sum"]];
            [settledDateArray addObject:[dic objectForKey:@"settledDate"]];
            [settleArray addObject:[dic objectForKey:@"settled"]];
        }
        [self.tableView reloadData];

    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
    }];
    [RSHttp requestWithURL:@"/salary/month/v2" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [eveydayArray removeAllObjects];
        [settleArray removeAllObjects];
        [salayArray removeAllObjects];
        [settledDateArray removeAllObjects];
        settledSum = [NSString stringWithFormat:@"%@",[[data objectForKey:@"body"] objectForKey:@"settledSum"]];
        UILabel *money = (UILabel *)[self.view viewWithTag:6666];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"已结算金额\n%@",settledSum]];
        [str addAttribute:NSForegroundColorAttributeName value:color155 range:NSMakeRange(0,5)];
        money.attributedText = str;
        
        unsettledSum = [NSString stringWithFormat:@"%@",[[data objectForKey:@"body"] objectForKey:@"unsettledSum"]];
        UILabel *money1 = (UILabel *)[self.view viewWithTag:7777];
        money1.text = [NSString stringWithFormat:@"未结算金额\n%@",unsettledSum];
        
        for (NSMutableDictionary *dic in [[data objectForKey:@"body"] objectForKey:@"list"]) {
            NSLog(@"dic = %@",dic);
            [eveydayArray addObject:[dic objectForKey:@"date"]];
            [salayArray addObject:[dic objectForKey:@"sum"]];
            [settledDateArray addObject:[dic objectForKey:@"settledDate"]];
            [settleArray addObject:[dic objectForKey:@"settled"]];
        }
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
    }];
}

-(void)initTableView
{
    UILabel *hintLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 40)];
    hintLabel.text = @"工资提示：从10月26日，薪资以线上数据为准。";
    [self.view addSubview:hintLabel];
    hintLabel.font = textFont14;
    hintLabel.textAlignment = NSTextAlignmentCenter;
    hintLabel.textColor = colorrede5;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 104, kUIScreenWidth, 54)];
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
    yijisuanLabel.textColor = colorgreen65;
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
    //[midView setBackgroundColor:[UIColor redColor]];
    
    self.tableView.frame = CGRectMake(15, midView.bottom - kUITabBarHeight + 15, kUIScreenWidth-30, 0);
    self.tableView.height = kUIScreenHeigth - self.tableView.top;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    /*self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, midView.frame.size.height+midView.frame.origin.y+15, kUIScreenWidth-30, kUIScreenHeigth-242)];
   
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.layer.borderWidth = 0.5;
    self.tableView.layer.borderColor = color242.CGColor;
    UIView *foot = [[UIView alloc] init];
    self.tableView.tableFooterView = foot;
    [self.view addSubview:self.tableView];*/
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
    int wight = 20;
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] init];
        [view addSubview:label];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = MakeColor(87, 87, 87);
        label.font = [UIFont systemFontOfSize:12];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = MakeColor(229, 229, 229);
        [view addSubview:line];
        if (i == 0) {
            label.text = @"日期";
            label.frame = CGRectMake(i*view.frame.size.width/3, 0, view.frame.size.width/3+wight, 30);
        }
        if (i == 1) {
            label.text = @"金额";
            line.frame = CGRectMake(i*view.frame.size.width/3+wight, 0, 1, 30);
            label.frame = CGRectMake(i*view.frame.size.width/3+wight, 0, view.frame.size.width/3-wight*2, 30);
        }
        if (i == 2) {
            label.text = @"结算日期";
            line.frame = CGRectMake(i*view.frame.size.width/3-wight, 0, 1, 30);
            label.frame = CGRectMake(i*view.frame.size.width/3-wight, 0, view.frame.size.width/3+wight, 30);
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
    int wight = 20;
    for (int i = 1; i < 3; i++) {
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = MakeColor(229, 229, 229);
        if (i == 1) {
            line.frame = CGRectMake(i*((kUIScreenWidth-30)/3)+wight, 0, 1, 40);
        }
        if (i == 2) {
            line.frame = CGRectMake(i*((kUIScreenWidth-30)/3)-wight, 0, 1, 40);
        }
        
        [cell.contentView addSubview:line];
        
    }
    //点击没有选中效果
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UILabel *date = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,(kUIScreenWidth-30)/3+wight , 40)];
    date.text = [NSString stringWithFormat:@"%@",[eveydayArray objectAtIndex:indexPath.row]];
    date.font = [UIFont systemFontOfSize:13];
    date.textAlignment = NSTextAlignmentCenter;
    date.textColor = MakeColor(75, 75, 75);
    [cell.contentView addSubview:date];

    UIButton *totalCount = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    totalCount.frame = CGRectMake((kUIScreenWidth-30)/3+wight, 0, (kUIScreenWidth-30)/3-wight*2, 40);
    [totalCount setTitle:[NSString stringWithFormat:@"%.2f",[salayArray[indexPath.row] floatValue]] forState:UIControlStateNormal];
    [totalCount setTitleColor:MakeColor(75, 75, 75) forState:UIControlStateNormal];
    [cell.contentView addSubview:totalCount];
    
    UILabel *jiesuanDate = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-30)/3*2-wight, 0,(kUIScreenWidth-30)/3-30+wight , 40)];
    jiesuanDate.text = [NSString stringWithFormat:@"%@",[settledDateArray objectAtIndex:indexPath.row]];
    jiesuanDate.font = [UIFont systemFontOfSize:13];
    jiesuanDate.textAlignment = NSTextAlignmentCenter;
    jiesuanDate.textColor = MakeColor(75, 75, 75);
    [cell.contentView addSubview:jiesuanDate];
    //判断是不是已结算
    if ([[NSString stringWithFormat:@"%@",[settleArray objectAtIndex:indexPath.row]] isEqualToString:@"1"]) {
        date.textColor = colorgreen65;
        [totalCount setTitleColor:colorgreen65 forState:UIControlStateNormal];
        jiesuanDate.textColor = colorgreen65;
    }
    
    UIButton *detailBtn = [[UIButton alloc] initWithFrame:CGRectMake(jiesuanDate.frame.origin.x+jiesuanDate.frame.size.width+5, 12, 15, 15)];
    [cell.contentView addSubview:detailBtn];
    [detailBtn setBackgroundImage:[UIImage imageNamed:@"icon_info"] forState:UIControlStateNormal];
     detailBtn.tag = indexPath.row;
    [detailBtn addTarget:self action:@selector(DetailMoneyOfMonth:) forControlEvents:UIControlEventTouchUpInside];
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
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *Str = [formatter stringFromDate:date1];
    
    dateLabel.text = Str;
    dateStr = [NSString stringWithFormat:@"%@-01",Str];
    [self getMessage];
}

-(void)rightBtn
{
    NSDate *date = [NSDate date];
    tag++;
    NSTimeInterval interval = 30*24*60*60*tag;
    NSDate *date1 = [date initWithTimeIntervalSinceNow:+interval];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM"];
    NSString *Str = [formatter stringFromDate:date1];
    
    //判断月份是否大于当前月
    NSString *dateString = dateStr;
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"-01" withString:@""];
    dateString = [dateString stringByReplacingOccurrencesOfString:@"-" withString:@""];
   
    if ([dateString intValue] >= [string intValue]) {
        tag--;
        [self alertView:@"查询月份不能大于当前月"];
        return;
    }else{
        dateLabel.text = Str;
        dateStr = [NSString stringWithFormat:@"%@-01",Str];
        [self getMessage];
    }
}

-(void)clickShow
{
    RuleOfActive *ruleVC = [[RuleOfActive alloc] init];
    ruleVC.title = @"工资说明";
    [self.navigationController pushViewController:ruleVC animated:YES];
}

@end
