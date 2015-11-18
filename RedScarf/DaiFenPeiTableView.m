//
//  DaiFenPeiTableView.m
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "DaiFenPeiTableView.h"
#import "ModTableViewCell.h"
#import "DaiFenPeiVC.h"
#import "UIView+ViewController.h"
#import "AppDelegate.h"
#import "UIUtils.h"
#import "RedScarf_API.h"
#import "AllocatingTaskVC.h"
#import "MBProgressHUD.h"
#import "Header.h"

@implementation DaiFenPeiTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.dataArray = [NSMutableArray array];
        self.aIdArray = [NSMutableArray array];
        [self getMessage];

        self.delegate = self;
        self.dataSource = self;
    }
    return self;
}

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [self showHUD:@"正在加载"];
    [RedScarf_API requestWithURL:@"/task/waitAssignTask" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            [self hidHUD];
            NSArray *arr = [NSArray arrayWithArray:[result objectForKey:@"msg"]];
            if (![arr count]) {
                [self addSubview:[self named:@"kongrenwu" text:@"任务"]];
            }
            for (NSMutableDictionary *dic in [result objectForKey:@"msg"]) {
                NSLog(@"dic = %@",dic);
                [self.dataArray addObject:dic];

                [self reloadData];
                [self hidHUD];
            }
            
        }
    }];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier4";
    ModTableViewCell *cell = [[ModTableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }

    NSMutableDictionary *dic = self.dataArray[indexPath.row];
    NSString *str = [NSString stringWithFormat:@"%@",[dic objectForKey:@"apartmentName"]];
    CGSize size = CGSizeMake(kUIScreenWidth-125, 30);
    CGSize labelSize = [str sizeWithFont:cell.addressLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    cell.addressLabel.frame = CGRectMake(20, 12, labelSize.width, labelSize.height);
    cell.addressLabel.text = str;
    
    UILabel *taskNum = [[UILabel alloc] initWithFrame:CGRectMake(cell.addressLabel.frame.size.width+cell.addressLabel.frame.origin.x+5, 14, 30, 15)];
    taskNum.font = [UIFont systemFontOfSize:13];
    taskNum.text = [NSString stringWithFormat:@"%@份",[dic objectForKey:@"taskNum"]];
    taskNum.textColor = [UIColor grayColor];
    [cell.contentView addSubview:taskNum];
    
    [cell.modifyBtn setTitle:@"分配" forState:UIControlStateNormal];
    cell.modifyBtn.tag = indexPath.row;
    [cell.modifyBtn addTarget:self action:@selector(didClickFenPeiBtn:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ModTableViewCell *cell = (ModTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSMutableDictionary *dic = self.dataArray[indexPath.row];

    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    DaiFenPeiVC *daiFenPeiVC = [[DaiFenPeiVC alloc] init];
    daiFenPeiVC.delegate = self;
    daiFenPeiVC.number = 1;
    daiFenPeiVC.aId = [dic objectForKey:@"apartmentId"];
    daiFenPeiVC.titleStr = cell.addressLabel.text;
    [self.viewController.navigationController pushViewController:daiFenPeiVC animated:YES];
    
}

-(void)didClickFenPeiBtn:(id)sender
{
    [[BaiduMobStat defaultStat] logEvent:@"分配" eventLabel:@"button4"];
    
    UIButton *btn = (UIButton *)sender;
    NSLog(@"btn.tag = %ld",(long)btn.tag);
    //传aid
    NSMutableDictionary *dic = self.dataArray[btn.tag];

    AllocatingTaskVC *allocaVC = [[AllocatingTaskVC alloc] init];
    allocaVC.delegate = self;
    allocaVC.aId = [dic objectForKey:@"apartmentId"];
    allocaVC.num = 1;
    allocaVC.number = 1;
    [self.viewController.navigationController pushViewController:allocaVC animated:YES];
}

-(void)returnNameOfTableView:(NSString *)name
{
    self.nameTableView = name;
}

@end
