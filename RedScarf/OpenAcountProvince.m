//
//  OpenAcountProvince.m
//  RedScarf
//
//  Created by zhangb on 15/9/3.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "OpenAcountProvince.h"
#import "AppDelegate.h"
#import "UIUtils.h"
#import "Header.h"

@implementation OpenAcountProvince
{
    NSString *urlString;
}

-(void)viewDidLoad
{
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.titleString;
    if ([self.title isEqualToString:@"开户省份"]) {
        urlString = @"/user/bankCard/province";
    }
    if ([self.title isEqualToString:@"开户城市"]) {
        urlString = @"/user/bankCard/city";
    }
    if ([self.title isEqualToString:@"开户银行"]) {
        urlString = @"/user/bankCard/bank";
    }
    if ([self.title isEqualToString:@"开户支行"]) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 44)];
        self.searchBar.placeholder = @"搜索";
        [self.searchBar setBarTintColor:MakeColor(244, 245, 246)];
        self.searchaDisplay = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
        self.searchaDisplay.searchResultsDelegate = self;
        self.searchaDisplay.searchResultsDataSource = self;
        self.searchaDisplay.delegate = self;

        urlString = @"/user/bankCard/bank/branch";
    }
  
    self.dataArray = [NSMutableArray array];
    self.nameArray = [NSMutableArray array];
    
    [self getMessage];
    [self navigationBar];
    [self initTableView];
}

-(void)navigationBar
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comeback"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if ([self.title isEqualToString:@"开户支行"]) {
        self.tableView.tableHeaderView = self.searchBar;

    }
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchaDisplay.searchResultsTableView]) {
        return self.filteredArray.count;
        
    }else{
        return self.dataArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    
    if ([tableView isEqual:self.searchaDisplay.searchResultsTableView]) {
        //根据名字查找aid
        NSString *name = self.filteredArray[indexPath.row];
        NSString *aId = @"";
        for (NSMutableDictionary *dic in self.dataArray) {
            if ([[dic objectForKey:@"name"] isEqualToString:name]) {
                aId = [dic objectForKey:@"aId"];
            }
        }
        cell.textLabel.text = [NSString stringWithFormat:@"%@",self.filteredArray[indexPath.row]];
        
    }else{
        dic = [self.dataArray objectAtIndex:indexPath.row];
       
        cell.textLabel.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    if ([tableView isEqual:self.searchaDisplay.searchResultsTableView]) {
        NSString *name = self.filteredArray[indexPath.row];
        NSString *aId = @"";
        for (NSMutableDictionary *dic in self.dataArray) {
            if ([[dic objectForKey:@"name"] isEqualToString:name]) {
                aId = [dic objectForKey:@"aId"];
            }
        }
        
        [self.delegate returnAddress:[NSString stringWithFormat:@"%@ (%@)",name,aId] aId:aId];
    }else{
        dic = [self.dataArray objectAtIndex:indexPath.row];
        [self.delegate returnAddress:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]] aId:[dic objectForKey:@"id"]];
        
    }
    
    [self didClickLeft];
}


-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [self.filteredArray removeAllObjects];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",searchText];
    NSArray *tempArray = [self.nameArray filteredArrayUsingPredicate:pred];
    //只把名字加到数组里面，
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

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    if ([self.title isEqualToString:@"开户城市"]) {
        [params setObject:self.Id forKey:@"provinceId"];
    }
    if ([self.title isEqualToString:@"开户银行"]) {
        [params setObject:@"1" forKey:@"pageNum"];
        [params setObject:@"10" forKey:@"pageSize"];
    }
    if ([self.title isEqualToString:@"开户支行"]) {
        [params setObject:@"1" forKey:@"pageNum"];
        [params setObject:@"10" forKey:@"pageSize"];
        [params setObject:self.idArr[0] forKey:@"provinceId"];
        [params setObject:self.idArr[1] forKey:@"cityId"];
        [params setObject:self.idArr[2] forKey:@"bankId"];
    }
    [RedScarf_API requestWithURL:urlString params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
           
            if ([self.title isEqualToString:@"开户银行"]||[self.title isEqualToString:@"开户支行"]) {
                for (NSMutableDictionary *dic in [[result objectForKey:@"msg"] objectForKey:@"list"]) {
                    NSLog(@"dic = %@",dic);
                    [self.dataArray addObject:dic];
                    [self.nameArray addObject:[dic objectForKey:@"name"]];
                }
            }else{
                for (NSMutableDictionary *dic in [result objectForKey:@"msg"]) {
                    NSLog(@"dic = %@",dic);
                    [self.dataArray addObject:dic];
                    [self.nameArray addObject:[dic objectForKey:@"name"]];
                }
            }
            
            [self.tableView reloadData];
            
        }else{
            [self alertView:[result objectForKey:@"msg"]];
            return ;
        }
    }];
}



@end
