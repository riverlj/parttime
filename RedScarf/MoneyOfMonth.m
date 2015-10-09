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
    UIPickerView *pickerView;
    NSArray *monthArray;
    NSArray *yearArray;
    
    NSString *dateStr;
    
    NSMutableArray *eveydayArray;
    NSMutableArray *salayArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    NSDate *now = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM:"];
    NSString *string = [formatter stringFromDate:now];
    string = [string stringByReplacingOccurrencesOfString:@"-" withString:@"年"];
    string = [string stringByReplacingOccurrencesOfString:@":" withString:@"月"];

    [btn setTitle:string forState:UIControlStateNormal];
    btn.tag = 30001;
    [btn addTarget:self action:@selector(initDatePickerView) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    btn.frame = CGRectMake(kUIScreenWidth/2-50, 0, 100, 40);
    [self.navigationController.navigationBar addSubview:btn];
    
    dateStr = @"";
    dateStr = [string stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    dateStr = [dateStr stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    dateStr = [NSString stringWithFormat:@"%@01",dateStr];
    [self getMessage];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[self.navigationController.navigationBar viewWithTag:30001] removeFromSuperview];
    
}

-(void)viewDidLoad
{
    monthArray = [NSArray arrayWithObjects:@"01月",@"02月",@"03月",@"04月",@"05月",@"06月",@"07月",@"08月",@"09月",@"10月",@"11月",@"12月", nil];
    yearArray = [NSArray arrayWithObjects:@"2015年",@"2016年",@"2017年",@"2018年",@"2019年",@"2020年",@"2021年",@"2022年",@"2023年",@"2024年",@"2025年",@"2026年", nil];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = NO;
    
    eveydayArray = [NSMutableArray array];
    salayArray = [NSMutableArray array];
    
//    self.navigationController.navigationBar.barTintColor = MakeColor(32, 102, 208);
    self.tabBarController.tabBar.hidden = YES;
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
    [RedScarf_API requestWithURL:@"/salary/month" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            
            for (NSMutableDictionary *dic in [result objectForKey:@"msg"]) {
                NSLog(@"dic = %@",dic);
                [eveydayArray addObject:[dic objectForKey:@"date"]];
                [salayArray addObject:[dic objectForKey:@"sum"]];
            }
            [self.tableView reloadData];
        }
    }];
}


-(void)initDatePickerView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-100, self.view.frame.size.height/2-120, 200, 240)];
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, 0, view.frame.size.width, 40)];
    head.backgroundColor = MakeColor(32, 102, 208);
    [view addSubview:head];
    
    view.backgroundColor = [UIColor whiteColor];
    view.layer.masksToBounds = YES;
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = MakeColor(75, 75, 75).CGColor;
    view.tag = 101;
    view.layer.cornerRadius = 5;
    [self.view addSubview:view];
    
    pickerView = [[UIPickerView alloc] init];
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.frame = CGRectMake(0, -20, 200, 240);
    [view addSubview:pickerView];
    
    UIButton *makeSureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    makeSureBtn.frame = CGRectMake(70, 200, 60, 30);
    makeSureBtn.layer.cornerRadius = 3;
    makeSureBtn.layer.masksToBounds = YES;
    makeSureBtn.layer.borderColor = MakeColor(32, 102, 208).CGColor;
    makeSureBtn.layer.borderWidth = 1.0;
    [makeSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [makeSureBtn addTarget:self action:@selector(didClickMakeSureBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:makeSureBtn];
    
}

-(void)didClickMakeSureBtn
{
    NSInteger yearRow = [pickerView selectedRowInComponent:0];
    NSInteger monthRow = [pickerView selectedRowInComponent:1];
    
    UIButton *btn = (UIButton *)[self.navigationController.navigationBar viewWithTag:30001];
    [btn setTitle:[NSString stringWithFormat:@"%@%@",yearArray[yearRow],monthArray[monthRow]] forState:UIControlStateNormal];
    btn.titleLabel.text = [btn.titleLabel.text stringByReplacingOccurrencesOfString:@"年" withString:@"-"];
    btn.titleLabel.text = [btn.titleLabel.text stringByReplacingOccurrencesOfString:@"月" withString:@"-"];
    
    dateStr = @"";
    dateStr = [NSString stringWithFormat:@"%@01",btn.titleLabel.text];
    [self getMessage];
    [[self.view viewWithTag:101] removeFromSuperview];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return yearArray.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return yearArray[row];
    }
    if (component == 1) {
        return monthArray[row];
    }
    
    return nil;
}


-(void)initTableView
{
    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 64, kUIScreenWidth, 40)];
    countLabel.text = [NSString stringWithFormat:@"本月工资：%@",self.salary];
    countLabel.textColor = MakeColor(87, 87, 87);
    countLabel.font = [UIFont systemFontOfSize:12];
    [self.view addSubview:countLabel];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(15, 104, kUIScreenWidth-30, kUIScreenHeigth-5)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
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

    
        UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,(kUIScreenWidth-30)/2 , 40)];
        dateLabel.text = [eveydayArray objectAtIndex:indexPath.row];
        dateLabel.font = [UIFont systemFontOfSize:13];
        dateLabel.textAlignment = NSTextAlignmentCenter;
        dateLabel.textColor = MakeColor(75, 75, 75);
        [cell.contentView addSubview:dateLabel];

        UIButton *totalCount = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        totalCount.frame = CGRectMake((kUIScreenWidth-30)/2, 0, (kUIScreenWidth-30)/2, 40);
        [totalCount setTitle:[NSString stringWithFormat:@"%@",salayArray[indexPath.row]] forState:UIControlStateNormal];
        [totalCount setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        totalCount.tag = indexPath.row;
        [totalCount addTarget:self action:@selector(DetailMoneyOfMonth:) forControlEvents:UIControlEventTouchUpInside];
        [cell.contentView addSubview:totalCount];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

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



@end
