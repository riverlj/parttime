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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
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
    if (kUIScreenWidth == 320) {
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 10, 38, 25)];
    }else{
        typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 10, 38, 25)];
    }
    typeLabel.textColor = MakeColor(50, 122, 255);
    typeLabel.text = [dic objectForKey:@"tag"];
    typeLabel.font = [UIFont systemFontOfSize:12];
    [cell.contentView addSubview:typeLabel];
    
    NSString *str = [NSString stringWithFormat:@"－%@",[dic objectForKey:@"content"]];
    CGSize size = CGSizeMake(kUIScreenWidth-100, 1000);
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    CGSize labelSize = [str sizeWithFont:addressLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    UILabel *taskNum;
    if (kUIScreenWidth == 320) {
        addressLabel.frame = CGRectMake(40, 12, labelSize.width-40, labelSize.height);
        taskNum = [[UILabel alloc] initWithFrame:CGRectMake(addressLabel.frame.size.width+addressLabel.frame.origin.x+5, 14, 25, 15)];
    }else{
        addressLabel.frame = CGRectMake(60, 12, labelSize.width-40, labelSize.height);
        taskNum = [[UILabel alloc] initWithFrame:CGRectMake(addressLabel.frame.size.width+addressLabel.frame.origin.x+5, 14, 25, 15)];
    }
    
    addressLabel.text = str;
    addressLabel.font = [UIFont systemFontOfSize:12];
    addressLabel.textColor = MakeColor(75, 75, 75);
    [cell.contentView addSubview:addressLabel];
    
    taskNum.font = [UIFont systemFontOfSize:13];
    taskNum.text = [NSString stringWithFormat:@"(%@)",[dic objectForKey:@"count"]];
    taskNum.textColor = [UIColor redColor];
    [cell.contentView addSubview:taskNum];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
