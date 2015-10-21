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
#import "SeparateTableViewCell.h"

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
    SeparateTableViewCell *cell = (SeparateTableViewCell *)[self tableView:self cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height ;
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
    cell.foodLabel.font = textFont12;
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


@end
