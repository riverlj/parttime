//
//  BuildingTaskViewController.m
//  RedScarf
//
//  Created by lishipeng on 16/1/15.
//  Copyright © 2016年 zhangb. All rights reserved.
//  楼栋详情

#import "BuildingTaskViewController.h"
#import "BuildingTaskModel.h"
#import "BuildingTaskCell.h"
#import "AllocatingTaskViewController.h"
@interface BuildingTaskViewController ()

@end

@implementation BuildingTaskViewController

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self beginHttpRequest];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"楼栋详情";
    self.url = @"/task/waitAssignTaskByRoom";
    if(self.userId != 0) {
        self.url = @"/task/assignTaskByRoom";
    }
    self.tableView.height = self.tableView.height - 44;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 44)];
    btn.bottom = kUIScreenHeigth;
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setTitle:@"分配" forState:UIControlStateNormal];
    [btn setTitleColor:color_blue_287dd8 forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(allocate:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void) beforeHttpRequest
{
    [super beforeHttpRequest];
    [self.params setObject:[NSString stringWithFormat:@"%ld", self.aId] forKey:@"aId"];
    if(self.userId != 0) {
        [self.params setObject:[NSString stringWithFormat:@"%ld", self.userId] forKey:@"userId"];
    }
}

-(void) afterHttpSuccess:(NSDictionary *)data
{
    for(NSDictionary *dic in [data valueForKey:@"body"]) {
        NSError *error;
        BuildingTaskModel *model = [MTLJSONAdapter modelOfClass:[BuildingTaskModel class] fromJSONDictionary:dic error:&error];
        [self.models addObject:model];
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildingTaskModel *model = [self.models objectAtIndex:indexPath.row];
    model.isSelected = !model.isSelected;
    [self.tableView reloadData];
}

-(void) allocate:(id) sender
{
    NSMutableString *room = [NSMutableString stringWithString:@""];
    BOOL canAlloc = NO;
    for(BuildingTaskModel *model in self.models) {
        if(model.isSelected) {
            [room appendString:[NSString stringWithFormat:@"%@,", model.room]];
            canAlloc = YES;
        }
    }
    if(!canAlloc) {
        [self showToast:@"请至少选择一个宿舍进行分配"];
        return;
    }
    AllocatingTaskViewController *vc = [AllocatingTaskViewController new];
    vc.room = [room copy];
    if(self.aId) {
        vc.aId = [NSString stringWithFormat:@"%ld", self.aId];
    }
    if(self.userId) {
        vc.userId = [NSString stringWithFormat:@"%ld", self.userId];
    }
    [self.navigationController pushViewController:vc animated:YES];
}
@end
