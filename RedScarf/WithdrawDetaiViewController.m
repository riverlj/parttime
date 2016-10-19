//
//  WithdrawDetaiViewController.m
//  RedScarf
//
//  Created by 李江 on 16/10/14.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "WithdrawDetaiViewController.h"
#import "WithdrawModel.h"

@interface WithdrawDetaiViewController ()

@end

@implementation WithdrawDetaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现详情";
    NSError *error = nil;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [UIView new];
    WithdrawModel *withdrawModel = [MTLJSONAdapter modelOfClass:WithdrawModel.class fromJSONDictionary:self.dic error:&error];
    if (error) {
        NSLog(@"数据转换有误");
    }
    self.models = [NSMutableArray arrayWithCapacity:2];
    WithdrawViewModel *wvm1 = [[WithdrawViewModel alloc] init];
    wvm1.cellClassName = @"WithdrawCell";
    wvm1.lineDown = YES;
    wvm1.cellLineHidden = NO;
    wvm1.statustr = @"提现申请";
    wvm1.image = [UIImage imageNamed:@"icon_withdraw_red"];
    wvm1.status = @([withdrawModel.status integerValue]);
    wvm1.timestr = [NSDate formatTimestamp:withdrawModel.requestTime.integerValue/1000 format:@"yyyy-MM-dd HH:MM:SS"];
    if (withdrawModel.status.integerValue == 0 || withdrawModel.status.integerValue == 1) {
        wvm1.rightText = @"待审核";
        wvm1.rightLabelColor = rs_color_f9443e;
    }else {
        wvm1.rightText = @"审核成功";
    }
    [self.models addObject:wvm1];
    
    WithdrawViewModel *wvm2 = [[WithdrawViewModel alloc] init];
    wvm2.cellClassName = @"WithdrawCell";
    wvm2.statustr = withdrawModel.statusStr;
    wvm2.status = @([withdrawModel.status integerValue]);
    wvm2.cellLineHidden = YES;
    wvm2.timestr = [NSDate formatTimestamp:withdrawModel.resultTime.integerValue/1000 format:@"yyyy-MM-dd HH:MM:SS"];
    if (withdrawModel.status.integerValue == 3) {
        wvm2.rightText = @"已打款";
        wvm2.rightLabelColor = rs_color_f9443e;
        wvm2.image = [UIImage imageNamed:@"icon_withdraw_red"];
    }else {
        wvm2.rightText = @"";
        wvm2.image = [UIImage imageNamed:@"icon_withdraw_gray"];
    }
    if (withdrawModel.status.integerValue == 0 || withdrawModel.status.integerValue == 1) {
        wvm2.statustr = @"提现成功";
        wvm2.timestr = @"";
    }
    
    if (withdrawModel.status.integerValue == 2) {
        wvm2.statustr = @"提现失败";
        wvm2.image = [UIImage imageNamed:@"icon_withdraw_red"];
        wvm2.rightText = @"打款失败";
        wvm2.rightLabelColor = rs_color_f9443e;
    }
    
    [self.models addObject:wvm2];
    [self.tableView reloadData];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.y = 0;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
@end
