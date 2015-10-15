//
//  HeadDisTableView.m
//  RedScarf
//
//  Created by zhangb on 15/8/12.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "HeadDisTableView.h"
#import "RedScarf_API.h"
#import "AppDelegate.h"
#import "UIUtils.h"
#import "Header.h"

@implementation HeadDisTableView

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.delegate = self;
        self.dataSource = self;
        [self getMessage];
    }
    
    
    return self;
}

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    
    [RedScarf_API requestWithURL:@"/task/assignedTask/content" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            [self.dataArray removeAllObjects];
            for (NSMutableDictionary *dic in [result objectForKey:@"msg"]) {
                NSLog(@"dic = %@",dic);
                [self.dataArray addObject:dic];
                
            }
            [self reloadData];
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


@end
