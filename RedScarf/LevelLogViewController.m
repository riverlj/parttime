//
//  LevelLogViewController.m
//  RedScarf
//
//  Created by lishipeng on 15/12/10.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "LevelLogViewController.h"
#import "LevelLogModel.h"

@implementation LevelLogViewController
-(void) viewDidLoad
{
    [super viewDidLoad];
    self.title = @"成长值记录";
    [self comeBack:nil];
    [self getMessage];
}

-(void) getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"token"]) {
        [params setObject:[defaults objectForKey:@"token"] forKey:@"token"];
    }
    [self showHUD:@"加载中"];
    [RSHttp requestWithURL:@"/user/growth/log" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSMutableArray *models = [NSMutableArray array];
        for(NSDictionary *dict in [data valueForKey:@"msg"]) {
            LevelLogModel *model = [MTLJSONAdapter modelOfClass:[LevelLogModel class] fromJSONDictionary:dict error:nil];
            [models addObject:model];
        }
        [self setModels:models];
        [self.tableView reloadData];
        [self hidHUD];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self alertView:errmsg];
    }];
}
@end
