//
//  TeamMembersViewController.m
//  
//
//  Created by zhangb on 15/9/22.
//
//

#import "TeamMembersViewController.h"
#import "MemberDetailViewController.h"
#import "AddMembersViewController.h"

@interface TeamMembersViewController ()

@end

@implementation TeamMembersViewController
{
    NSMutableArray *listArray;
    NSMutableArray *nameArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMessage];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"团队成员";
    [self comeBack:nil];
    //添加成员
    UIImage *img= [[UIImage imageNamed:@"addmember"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(addMember)];
    self.navigationItem.rightBarButtonItem = right;
    listArray = [NSMutableArray array];
    nameArray = [NSMutableArray array];
    [self initTableView];
}

-(void)addMember
{
    AddMembersViewController *addMembersVC = [[AddMembersViewController alloc] init];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addMembersVC];
    [self presentViewController:navController animated:YES completion:nil];
}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"" forKey:@"name"];
    [params setValue:@"-1" forKey:@"pageSize"];
    [params setValue:@"-1" forKey:@"pageNum"];
    [self showHUD:@"正在加载"];
    [RSHttp requestWithURL:@"/user/teamMembers/" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSArray *arr = [NSArray arrayWithArray:[[data objectForKey:@"msg"] objectForKey:@"list"]];
        if (![arr count]) {
            [self.view addSubview:[self named:@"meiyouchengyuan" text:@"成员"]];
        }
        
        [listArray removeAllObjects];
        [nameArray removeAllObjects];
        for (NSMutableDictionary *dic in [[data objectForKey:@"msg"] objectForKey:@"list"]) {
            [listArray addObject:dic];
            [nameArray addObject:[dic objectForKey:@"realName"]];
        }
        [self.tableView reloadData];
        [self hidHUD];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:@"加载失败"];
    }];
}

-(void)initTableView
{
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 44)];
    self.searchBar.placeholder = @"根据姓名／手机号码搜索";
    [self.searchBar.layer setBorderColor:color242.CGColor];
    [self.searchBar.layer setBorderWidth:1.0];
    [self.searchBar setBarTintColor:color242];
    self.searchaDisplay = [[UISearchDisplayController alloc] initWithSearchBar:self.searchBar contentsController:self];
    self.searchaDisplay.searchResultsDelegate = self;
    self.searchaDisplay.searchResultsDataSource = self;
    self.searchaDisplay.delegate = self;

    self.tableView.tableHeaderView = self.searchBar;
    [self.view addSubview:self.tableView];
}

#pragma mark -- tableViewDelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:self.searchaDisplay.searchResultsTableView]) {
        return self.filteredArray.count;
    }
    return listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] init];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary *dic;
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kUIScreenWidth-100, 40)];
    UILabel *phone = [[UILabel alloc] initWithFrame:CGRectMake(15, 35, kUIScreenWidth-100, 20)];
    phone.font = textFont14;
    phone.textColor = color155;
    [cell.contentView addSubview:phone];
    [cell.contentView addSubview:name];
    
    if ([tableView isEqual:self.searchaDisplay.searchResultsTableView]) {
        //根据名字查找aid
        NSString *name = self.filteredArray[indexPath.row];
        NSString *phoneNum = @"";
        for (NSMutableDictionary *dic in listArray) {
            if ([[dic objectForKey:@"realName"] isEqualToString:name]) {
                phoneNum = [dic objectForKey:@"mobilePhone"];
                cell.textLabel.text = [dic objectForKey:@"realName"];
                phone.text = phoneNum;
            }
        }
        
    }else{
        dic = listArray[indexPath.row];
        name.text = [dic objectForKey:@"realName"];
        phone.text = [dic objectForKey:@"mobilePhone"];
        
    }
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(kUIScreenWidth-55, 20, 0.5, 20)];
    line.backgroundColor = color_gray_e8e8e8;
    [cell.contentView addSubview:line];
    
    UIImageView *detail = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth-40, 20, 20, 20)];
    detail.image = [UIImage imageNamed:@"icon_info"];
    [cell.contentView addSubview:detail];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //[tableView deselectRowAtIndexPath:indexPath animated:NO];
    MemberDetailViewController *memberVC = [[MemberDetailViewController alloc] init];
    NSMutableDictionary *dic;
    if ([tableView isEqual:self.searchaDisplay.searchResultsTableView]) {

        //根据名字查找aid
        NSString *name = self.filteredArray[indexPath.row];
        for (NSMutableDictionary *dic in listArray) {
            if ([[dic objectForKey:@"realName"] isEqualToString:name]) {
                memberVC.memberId = [dic objectForKey:@"id"];
            }
        }
        
    }else{
        dic = listArray[indexPath.row];
        memberVC.memberId = [dic objectForKey:@"id"];
    }
    [self.navigationController pushViewController:memberVC animated:YES];
}

-(void)filterContentForSearchText:(NSString *)searchText scope:(NSString *)scope
{
    [self.filteredArray removeAllObjects];
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@",searchText];
    NSArray *tempArray = [nameArray filteredArrayUsingPredicate:pred];
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

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
