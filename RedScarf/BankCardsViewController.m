//
//  BankCardsViewController.m
//  RedScarf
//
//  Created by lishipeng on 15/12/29.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "BankCardsViewController.h"
#import "RSSingleTitleModel.h"
#import "MyBankCardVC.h"
#import "RSBankCardModel.h"

@implementation BankCardsViewController
{
    NSArray *bankCards;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMessage];
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.title = @"银行卡列表";
    self.tableView.tableFooterView = [UIView new];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"新增" style:UIBarButtonItemStylePlain target:self action:@selector(didClickRight)];
    [self.navigationItem setRightBarButtonItem:right];
}

-(void) getMessage
{
    [self showHUD:@"加载中..."];
    [RSHttp payRequestWithURL:@"/account/queryBankCard" params:@{} httpMethod:@"GET" success:^(NSDictionary *data) {
        [self hidHUD];
        self.models = [NSMutableArray array];
        bankCards = [NSMutableArray array];
        if([data objectForKey:@"body"]) {
            NSError *error;
            bankCards = [NSArray arrayWithArray:[MTLJSONAdapter modelsOfClass:[RSBankCardModel class] fromJSONArray:[data objectForKey:@"body"] error:&error]];
            for(RSBankCardModel *bankcard in bankCards) {
                RSSingleTitleModel *model = [RSSingleTitleModel new];
                model.str = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@:%@", bankcard.bankName, bankcard.cardNum]];
                [self.models addObject:model];
            }
            if([self.models count] == 0) {
                [self showToast:@"您现在还没有银行卡"];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self showToast:errmsg];
    }];
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyBankCardVC *vc = [MyBankCardVC new];
    if ([bankCards objectAtIndex:indexPath.row]) {
        vc.bankcard = [bankCards objectAtIndex:indexPath.row];
    }
    [self.navigationController pushViewController:vc animated:YES];
}

-(void) didClickRight
{
    MyBankCardVC *vc = [MyBankCardVC new];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
