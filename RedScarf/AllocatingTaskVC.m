//
//  AllocatingTaskVC.m
//  RedScarf
//
//  Created by zhangb on 15/8/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "AllocatingTaskVC.h"
#import "Header.h"
#import "AppDelegate.h"
#import "UIUtils.h"
#import "Model.h"
#import "DistributionCell.h"

@implementation AllocatingTaskVC
{
    Model *indexModel;
    int whichAlertView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [super viewWillAppear:animated];
}

-(void)viewDidLoad
{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.barTintColor = MakeColor(32, 102, 208);
    self.view.backgroundColor = color242;
    self.title = @"分配任务";
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 44)];
    [self.searchBar.layer setBorderColor:color242.CGColor];
    [self.searchBar.layer setBorderWidth:1.0];
    [self.searchBar setBarTintColor:color242];
    self.searchaDisplay = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchaDisplay.searchResultsDelegate = self;
    self.searchaDisplay.searchResultsDataSource = self;
    self.searchaDisplay.delegate = self;
    self.array = [NSMutableArray array];
    self.filteredArray = [NSMutableArray array];
    self.nameArray = [NSMutableArray array];
    [self initNavigation];
    [self getMessage];
    [self initTableView];
    
}

-(void)initNavigation
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comeback"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    
    //隐藏tabbar上的按钮
    UIButton *barBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [barBtn removeFromSuperview];
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getMessage
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setValue:@"" forKey:@"name"];
    [RSHttp requestWithURL:@"/task/fuzzyUser" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [self.array removeAllObjects];
        [self.nameArray removeAllObjects];
        for (NSMutableDictionary *dic in [data objectForKey:@"msg"]) {
            NSLog(@"dic = %@",dic);
            Model *model = [[Model alloc] init];
            model.username = [dic objectForKey:@"username"];
            model.tasksArr = [dic objectForKey:@"apartments"];
            model.mobile = [dic objectForKey:@"mobile"];
            model.userId = [dic objectForKey:@"userId"];
            model.present = [[dic objectForKey:@"present"] boolValue];
            [self.array addObject:model];
            [self.nameArray addObject: model.username];
        }
        [self.taskTableView reloadData];

    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}


-(void)initTableView
{
    self.taskTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
    self.taskTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.taskTableView.backgroundColor = color242;
    self.taskTableView.delegate = self;
    self.taskTableView.dataSource = self;
    self.taskTableView.tableHeaderView = self.searchBar;
    UIView *footView = [[UIView alloc] init];
    self.taskTableView.tableFooterView = footView;
    [self.view addSubview:self.taskTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchaDisplay.searchResultsTableView]) {
        return self.filteredArray.count;
        
    }else{
        return self.array.count;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DistributionCell *cell = (DistributionCell *)[self tableView:self.taskTableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    DistributionCell *cell = [[DistributionCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.backgroundColor = color242;
    Model *model = [[Model alloc] init];
    NSString *str = @"";
    if ([tableView isEqual:self.searchaDisplay.searchResultsTableView]) {
        //根据名字查找对应的数据
        NSString *name = @"";
        name = [self.filteredArray objectAtIndex:indexPath.row];
        for (Model *mod in self.array) {
            if ([mod.username isEqualToString:name]) {
                model = mod;
            }
        }
        for (NSMutableDictionary *dic in model.tasksArr)
        {
            str = [str stringByAppendingFormat:@"%@                                              \n",[dic objectForKey:@"apartmentName"]];
        }
        
    }else{
        model = [self.array objectAtIndex:indexPath.row];

        for (NSMutableDictionary *dic in model.tasksArr) {
            str = [str stringByAppendingFormat:@"\n%@                                              \n",[dic objectForKey:@"apartmentName"]];
        }
    }
    cell.addLabel.text = [NSString stringWithFormat:@"%@:%@",model.username,model.mobile];
    cell.foodLabel.font = [UIFont systemFontOfSize:16];
    [cell setIntroductionText:[NSString stringWithFormat:@"%@",str]];
    
   
    cell.rightLabel.tag = indexPath.row;
    cell.rightLabel.frame = CGRectMake(cell.groundImage.frame.size.width-60, 0, 60, cell.frame.size.height-15);
//    [cell.button addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    indexModel = [[Model alloc] init];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"self.aId = %@ ,self.room = %@",self.aId,self.room);
    if ([tableView isEqual:self.searchaDisplay.searchResultsTableView]) {
        //根据名字查找对应的数据
        NSString *name = @"";
        name = [self.filteredArray objectAtIndex:indexPath.row];
        for (Model *mod in self.array) {
            if ([mod.username isEqualToString:name]) {
                indexModel = mod;
            }
        }

    }else{
        indexModel = [self.array objectAtIndex:indexPath.row];
    }
    
    
    [self alertView:@"" number:1];
   
}

//-(void)clickBtn:(id)sender
//{
//    UITableView *tableView = [[UITableView alloc] init];
//    UIButton *btn = (UIButton *)sender;
//    indexModel = [[Model alloc] init];
//    NSLog(@"self.aId = %@ ,self.room = %@",self.aId,self.room);
//    if ([tableView isEqual:self.searchaDisplay.searchResultsTableView]) {
//        //根据名字查找对应的数据
//        NSString *name = @"";
//        name = [self.filteredArray objectAtIndex:btn.tag];
//        for (Model *mod in self.array) {
//            if ([mod.username isEqualToString:name]) {
//                indexModel = mod;
//            }
//        }
//        
//    }else{
//        indexModel = [self.array objectAtIndex:btn.tag];
//    }
//    
//    
//    [self alertView:@"" number:1];
//}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            [params setValue:indexModel.userId forKey:@"userId"];
            [params setValue:self.aId forKey:@"aId"];
            NSString *url = @"/task/waitAssignTask/updateTask";
            
            if (self.room.length) {
                [params setValue:self.room forKey:@"room"];
            }
            //已分配跳过来的界面
            if (self.number == 0) {
                [params setValue:self.userId forKey:@"indexUserId"];
                url = @"/task/assignTask/updateTask";
            }
            
            [RSHttp requestWithURL:url params:params httpMethod:@"PUT" success:^(NSDictionary *data) {
                [self alertView:@"分配成功" number:0];
            } failure:^(NSInteger code, NSString *errmsg) {
                [self alertView:@"分配失败" number:0];
            }];
        }
        case 0:{
            if (whichAlertView == 1) {
                
            }else{
                if (self.number == 0) {
                    [self.delegate returnNameOfTableView:@"yifenpei"];
                }else{
                    [self.delegate returnNameOfTableView:@"daifenpei"];
                }
                [self.navigationController popViewControllerAnimated:YES];

            }
            
        }
            
            break;
            
        default:
            break;
    }
}


-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [self.filteredArray removeAllObjects];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchText];
    NSArray *tempArray = [self.nameArray filteredArrayUsingPredicate:pred];

    self.filteredArray = [NSMutableArray arrayWithArray:tempArray];
    
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
-(void)alertView:(NSString *)msg number:(int)num
{
    UIAlertView *alertView;
    if (num == 1) {
        whichAlertView = 1;
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"取消分配" otherButtonTitles:@"确认分配", nil];
        alertView.delegate = self;
        [alertView show];
    }else{
        whichAlertView = 0;
        alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        alertView.delegate = self;
        [alertView show];
    }
    
}


@end
