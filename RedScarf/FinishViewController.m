//
//  FinishViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/18.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "FinishViewController.h"
#import "Model.h"
@implementation FinishViewController
{
    UIButton *button;
    int pageNum;
    NSString *search;
    NSString *phone;
    NSArray *statusArr;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.useHeaderRefresh = YES;
    self.useFooterRefresh = YES;
    self.title = @"历史任务";
    self.url = @"/task/taskByStatus";
    self.status = @"";
    statusArr = [NSArray arrayWithObjects:
                @{@"name":@"全  部", @"status":@""},
                @{@"name":@"已送达", @"status":@"FINISHED"},
                @{@"name":@"未送达", @"status":@"UNDELIVERED"}
                 , nil];
    self.hideBtnView = YES;
    
    //设置搜索框
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 44)];
    [self.searchBar.layer setBorderColor:MakeColor(241, 241, 241).CGColor];
    [self.searchBar.layer setBorderWidth:1.0];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"输入姓名、手机号或楼栋";
    self.searchBar.barTintColor = color_gray_f3f5f7;
    self.searchBar.backgroundColor = color_gray_f3f5f7;
    self.searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    UIView *foot = [[UIView alloc] init];
    self.tableView.tableFooterView = foot;
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.height += 64;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView.mj_header beginRefreshing];
    [self.tableView addTapAction:@selector(searchBarCancelButtonClicked:) target:self];
    
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.rightBtn];
    self.navigationItem.rightBarButtonItem = item;
}

-(UIButton *)rightBtn
{
    if(_rightBtn) {
        return _rightBtn;
    }
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(0, 0, 74, 44);
    _rightBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [_rightBtn setTitle:@"全  部" forState:UIControlStateNormal];
    [_rightBtn setTitleColor:color_black_666666 forState:UIControlStateNormal];
    _rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 57, 0, -57);
    _rightBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -17, 0, 17);
    [_rightBtn setImage:[UIImage imageNamed:@"shaixuan"] forState:UIControlStateNormal];
    [_rightBtn addTarget:self action:@selector(didClickRight:) forControlEvents:UIControlEventTouchUpInside];
    return _rightBtn;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [self setHideBtnView:YES];
    _btnView = nil;
    [super viewWillDisappear:animated];
}

-(void) beforeHttpRequest
{
    [super beforeHttpRequest];
    if (self.status.length) {
        [self.params setObject:self.status forKey:@"status"];
    } else {
        if([self.params objectForKey:@"status"]) {
            [self.params removeObjectForKey:@"status"];
        }
    }
    if (phone.length) {
        [self.params setObject:phone forKey:@"phoneKey"];
    } else {
        if([self.params objectForKey:@"phoneKey"]){
            [self.params removeObjectForKey:@"phoneKey"];
        }
    }
}


-(void) afterHttpSuccess:(NSDictionary *)data
{
    NSArray *arr = [NSArray arrayWithArray:[[data objectForKey:@"body"] objectForKey:@"list"]];
    for (NSMutableDictionary *dic in arr) {
        Model *model = [[Model alloc] init];
        model.nameStr = [dic objectForKey:@"username"];
        model.chuLiStr = [dic objectForKey:@"username"];
        model.buyerStr = [dic objectForKey:@"customername"];
        model.telStr = [dic objectForKey:@"mobile"];
        model.addressStr = [dic objectForKey:@"apartmentname"];
        model.foodArr = [dic objectForKey:@"content"];
        model.dateStr = [dic objectForKey:@"endDate"];
        model.numberStr = [dic objectForKey:@"sn"];
        model.status = [dic objectForKey:@"status"];
        model.room = [dic objectForKey:@"room"];
        model.cellClassName = @"FinishTableViewCell";
        model.cellHeight = 10;
        [self.models addObject:model];
    }
    [super afterHttpSuccess:data];
}

-(void) afterProcessHttpData:(NSInteger)before afterCount:(NSInteger)after
{
    [super afterProcessHttpData:before afterCount:after];
 }

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell.height;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    if([self.searchBar isFirstResponder]) {
        [self.searchBar resignFirstResponder];
        self.searchBar.text = @"";
        phone = @"";
        [self.tableView.mj_header beginRefreshing];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.view endEditing:YES];
    phone = self.searchBar.text;
    [self.tableView.mj_header beginRefreshing];
}

-(UIView *)btnView
{
    if(_btnView) {
        return _btnView;
    }
    _btnView = [[UIView alloc] initWithFrame:CGRectMake(kUIScreenWidth-100, 54, 90, 130)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(_btnView.width - 25, 0, 10, 10)];
    img.image = [UIImage imageNamed:@"sanjiao@2x"];
    [_btnView addSubview:img];
    NSInteger i = 0;
    for (NSDictionary *dic in statusArr) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0, img.bottom+i*40, 90, 40);
        btn.backgroundColor = [UIColor grayColor];
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [btn setTitle:[dic objectForKey:@"name"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(statusSelected:) forControlEvents:UIControlEventTouchUpInside];
        if (i != [statusArr count]-1) {
            UIView *line = [[UIView alloc] init];
            line.backgroundColor = [UIColor whiteColor];
            line.frame = CGRectMake(5, 39, 80, 1);
            [btn addSubview:line];
        }
        [_btnView addSubview:btn];
        i++;
    }
    return _btnView;
}

-(void)statusSelected:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [self.rightBtn setTitle:btn.titleLabel.text forState:UIControlStateNormal];
    for(NSDictionary *dic in statusArr) {
        if([[dic objectForKey:@"name"] isEqualToString:btn.titleLabel.text]) {
            self.status = [dic objectForKey:@"status"];
        }
    }
    [self setHideBtnView:!self.hideBtnView];
    [self.tableView.mj_header beginRefreshing];
}

-(void)setHideBtnView:(BOOL)hideBtnView
{
    _hideBtnView = hideBtnView;
    if(hideBtnView) {
        if([self.btnView superview]) {
            [self.btnView removeFromSuperview];
        }
    } else {
        if(![self.btnView superview]) {
            [self.navigationController.view addSubview:self.btnView];
        }
    }
}

-(void)didClickRight:(id)sender
{
    [self setHideBtnView:!self.hideBtnView];
}
@end
