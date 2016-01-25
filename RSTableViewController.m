//
//  RSTableViewController.m
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSTableViewController.h"

@implementation RSTableViewController
- (id)initWithStyle:(UITableViewStyle)tableStyle {
    self = [super init];
    self.tableStyle = tableStyle;
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
}
- (void)viewDidUnload {
    self.tableView = nil;
    [super viewDidUnload];
}

-(void) setModels:(NSMutableArray *)models
{
    _models = models;
    [self.tableView reloadData];
}



- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableStyle];
        _tableView.backgroundColor = color_gray_f3f5f7;
        _tableView.backgroundView = nil;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}
#pragma mark -
#pragma mark UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (_sections) {
        return _models.count;
    }
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_sections) {
        NSArray *aSection = [_models objectAtIndex:section];
        return aSection.count;
    }
    return _models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RSModel *model = nil;
    if (_sections) {
        model = [[_models objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else {
        model = [_models objectAtIndex:indexPath.row];
    }
    RSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:model.cellClassName];
    if (cell == nil) {
        cell = [[NSClassFromString(model.cellClassName) alloc] init];
    }
    [cell setModel:model];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_sections.count > section) {
        return [_sections objectAtIndex:section];
    }
    return nil;
}

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, tableView.width, 10)];
    return view;
}

#pragma mark -
#pragma mark UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    RSModel *model = nil;
    if (_sections) {
        model = [[_models objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else {
        model = [_models objectAtIndex:indexPath.row];
    }
    return [model cellHeightWithWidth:tableView.width];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RSModel *model = nil;
    if (_sections) {
        model = [[_models objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    }else {
        model = [_models objectAtIndex:indexPath.row];
    }
    //如果设置了无点击效果,则不做任务处理
    if(!model.isSelectable) {
        return;
    }
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    id target = [model getTarget];
    SEL selectAction = [model getSelectAction];
    if (target  && selectAction && [target respondsToSelector:selectAction]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [target performSelector:selectAction withObject:model withObject:selectedCell];
#pragma clang diagnostic pop
    }else if (_delegate && [_delegate respondsToSelector:@selector(tableController:didSelectRowAtIndexPath:selectedItem:forCell:)]) {
        [_delegate tableController:self didSelectRowAtIndexPath:indexPath selectedItem:model forCell:selectedCell];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

@end
