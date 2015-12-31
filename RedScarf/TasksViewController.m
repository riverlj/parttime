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
    self.useFooterRefresh = YES;
    self.useHeaderRefresh = YES;
    btnArr = @[
               @{@"title":@"待分配", @"url":@"/task/waitAssignTask"},
               @{@"title":@"已分配", @"url":@"/task/assignTask/user"},
            ];
    [self initButton];
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 115, kUIScreenWidth, 51)];
    self.searchBar.delegate = self;
    [self.searchBar setBarTintColor:color242];
    [self.searchBar.layer setBorderColor:color242.CGColor];
    [self.searchBar.layer setBorderWidth:1.0];
    self.searchBar.placeholder = @"搜索配送人";
    
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
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
}

-(void)initButton
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 51)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.layer.borderColor = MakeColor(187, 186, 193).CGColor;
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
    self.tableView.height = kUIScreenHeigth - view.height;
}

-(void) didClickBtn:(id)sender
{
    if([sender isKindOfClass:[RSSubTitleView class]]) {
        RSSubTitleView *title = (RSSubTitleView *) sender;
        [group setSelectedIndex:title.tag];
        self.searchType = [group selectedIndex];
    }
}

-(void) setSearchType:(NSInteger)searchType
{
    _searchType = searchType;
    self.params = [NSMutableDictionary dictionary];
    self.url = [[btnArr objectAtIndex:searchType] objectForKey:@"url"];
    if(searchType == 0) {
        self.tableView.tableHeaderView = nil;
    } else {
        [self.params setValue:self.searchBar.text forKey:@"name"];
        self.tableView.tableHeaderView = self.searchBar;
    }
    [self.tableView.mj_header beginRefreshing];

}

-(void) afterHttpSuccess:(NSDictionary *)data
{
    for (NSMutableDictionary *dic in [data objectForKey:@"msg"]) {
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
