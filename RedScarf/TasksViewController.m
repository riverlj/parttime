//
//  TasksViewController.m
//  RedScarf
//
//  Created by lishipeng on 15/12/30.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "TasksViewController.h"
#import "Model.h"
#import "RSRadioGroup.h"
#import "RSSubTitleView.h"
#import "RoomTaskTableViewCell.h"
#import "UserTaskTableViewCell.h"

@implementation TasksViewController
{
    RSRadioGroup *group;
    NSArray *btnArr;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.searchType = self.searchType;
    [super viewDidAppear:animated];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"任务";
    self.useFooterRefresh = NO;
    self.useHeaderRefresh = YES;
    btnArr = @[
               @{@"title":@"待分配", @"url":@"/task/waitAssignTask"},
               @{@"title":@"已分配", @"url":@"/task/assignTask/user"},
            ];
    [self initButton];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(18, 15, kUIScreenWidth, 63)];
    self.searchBar.delegate = self;
    [self.searchBar.layer setBorderColor:color242.CGColor];
    [self.searchBar.layer setBorderWidth:1.0];
    self.searchBar.placeholder = @"根据姓名／手机号码搜索";
    self.searchBar.backgroundColor = color_gray_f3f5f7;
    self.searchBar.barTintColor = color_gray_f3f5f7;

    
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [self.tableView addTapAction:@selector(searchBarCancelButtonClicked:) target:self];
}


-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
        self.searchBar.text = @"";
        [self setSearchType:self.searchType];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self setSearchType:self.searchType];
    [self.searchBar resignFirstResponder];
}

-(void)initButton
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 40)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.layer.borderColor = color_gray_e8e8e8.CGColor;
    view.layer.borderWidth = 1.0;
    group = [[RSRadioGroup alloc] init];
    
    NSInteger i = 0;
    for (NSDictionary *dic in btnArr) {
        RSSubTitleView *title = [[RSSubTitleView alloc] initWithFrame:CGRectMake(0, 0, view.width/[btnArr count], view.height)];
        title.left = i*title.width;
        [title setTitle:[dic valueForKey:@"title"] forState:UIControlStateNormal];
        [title addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
        title.tag = i;
        [view addSubview:title];
        [group addObj:title];
        i ++;
    }
    [group setSelectedIndex:0];
    _searchType = 0;
    self.tableView.top = view.height ;
    self.tableView.height = kUIScreenHeigth - view.height + 64;
}

-(void) didClickBtn:(id)sender
{
    if([sender isKindOfClass:[RSSubTitleView class]]) {
        RSSubTitleView *title = (RSSubTitleView *) sender;
        [group setSelectedIndex:title.tag];
        self.searchType = [group selectedIndex];
        [self.tips removeFromSuperview];
    }
}

-(void) setSearchType:(NSInteger)searchType
{
    _searchType = searchType;
    self.params = [NSMutableDictionary dictionary];
    self.url = [[btnArr objectAtIndex:searchType] objectForKey:@"url"];
    if(searchType == 0) {
        self.tableView.tableHeaderView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    } else {
        self.tableView.tableHeaderView = self.searchBar;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    self.models = [NSMutableArray array];
    [self.tableView.mj_header beginRefreshing];

}

-(void) beforeHttpRequest
{
    [super beforeHttpRequest];
    if(_searchType == 1) {
        [self.params setValue:self.searchBar.text forKey:@"name"];
    }
}

-(void) afterHttpSuccess:(NSDictionary *)data
{
    for (NSMutableDictionary *dic in [data objectForKey:@"body"]) {
        Model *model = [[Model alloc] init];
        model.username = [dic objectForKey:@"username"];
        model.tasksArr = [dic objectForKey:@"tasks"];
        model.mobile = [dic objectForKey:@"mobile"];
        model.userId = [dic objectForKey:@"userId"];
        model.apartmentName = [dic objectForKey:@"apartmentName"];
        model.taskNum = [dic objectForKey:@"taskNum"];
        model.aId = [dic objectForKey:@"apartmentId"];
        if(model.username) {
            model.cellClassName = @"UserTaskTableViewCell";
        } else {
            model.cellClassName = @"RoomTaskTableViewCell";
        }
        [self.models addObject:model];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if([cell isKindOfClass:[RoomTaskTableViewCell class]]) {
        ((RoomTaskTableViewCell *)cell).delegate = (UITableViewController *)self;
    }
    if([cell isKindOfClass:[UserTaskTableViewCell class]]) {
        ((UserTaskTableViewCell *)cell).delegate = (UITableViewController *)self;
    }
    return cell;
}
@end
