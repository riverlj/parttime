//
//  AllocatingTaskViewController.m
//  RedScarf
//
//  Created by lishipeng on 15/12/31.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "AllocatingTaskViewController.h"
#import "Model.h"

@implementation AllocatingTaskViewController
{
    Model *indexModel;
    NSMutableArray *normalArray;
    NSMutableArray *filterArray;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"分配任务";
    self.url = @"/task/fuzzyUser";
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 44)];
    [self.searchBar.layer setBorderColor:color242.CGColor];
    [self.searchBar.layer setBorderWidth:1.0];
    [self.searchBar setBarTintColor:color242];
    self.searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchDisplay.searchResultsDelegate = self;
    self.searchDisplay.searchResultsDataSource = self;
    self.searchDisplay.delegate = self;
    self.searchDisplay.searchResultsTableView.backgroundColor = color_gray_f3f5f7;
    self.searchDisplay.searchResultsTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.searchBar.keyboardType = UIKeyboardTypePhonePad;
    self.searchBar.backgroundColor = color_gray_f3f5f7;
    
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self beginHttpRequest];
    normalArray = [NSMutableArray array];
    filterArray = [NSMutableArray array];
}



-(void) beforeHttpRequest
{
    self.params = [NSMutableDictionary dictionary];
    [self.params setObject:self.searchBar.text forKey:@"name"];
    [self showHUD:@"加载中"];
}


-(void) afterHttpSuccess:(NSDictionary *)data
{
    for (NSMutableDictionary *dic in [data objectForKey:@"msg"]) {
        Model *model = [[Model alloc] init];
        model.username = [dic objectForKey:@"username"];
        model.tasksArr = [dic objectForKey:@"apartments"];
        model.mobile = [dic objectForKey:@"mobile"];
        model.userId = [dic objectForKey:@"userId"];
        model.present = [[dic objectForKey:@"present"] boolValue];
        model.cellClassName = @"DistributionCell";
        model.cellHeight = 40;
        [normalArray addObject:model];
    }
    self.models = normalArray;
    [super afterHttpSuccess:data];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexModel = [self.models objectAtIndex:indexPath.row];
    [self fenPei];
}


-(void) fenPei
{
    NSString *msg = @"";
    if(indexModel && !indexModel.present) {
        msg = @"该同学当天不出勤，你确定分配给他么？";
    }
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消分配" otherButtonTitles:@"确认分配", nil];
    alertView.delegate = self;
    [alertView show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 1){
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setValue:indexModel.userId forKey:@"userId"];
        [params setValue:self.aId forKey:@"aId"];
        NSString *url = @"/task/waitAssignTask/updateTask";
            
        if (self.room.length) {
            [params setValue:self.room forKey:@"room"];
        }
        //已分配跳过来的界面
        if ([self.userId integerValue] != 0) {
            [params setValue:self.userId forKey:@"indexUserId"];
            url = @"/task/assignTask/updateTask";
        }
        [RSHttp requestWithURL:url params:params httpMethod:@"PUT" success:^(NSDictionary *data) {
            [self showToast:@"分配成功"];
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSInteger code, NSString *errmsg) {
            [self showToast:errmsg];
        }];
    }
}

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [filterArray removeAllObjects];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchText];
    for(Model *model in normalArray) {
        if([pred  evaluateWithObject:model.mobile]) {
            [filterArray addObject:[model copy]];
        }
    }
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // 当用户改变搜索范围时，让列表的数据来源重新加载数据
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    // 返回YES，让table view重新加载。
    return YES;
}

-(void) searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller
{
    self.models = filterArray;
    
}

-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    self.models = normalArray;
}
@end
