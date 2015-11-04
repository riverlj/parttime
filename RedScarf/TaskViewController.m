//
//  TaskViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "TaskViewController.h"
#import "ModAddressTableView.h"
#import "DistributionTableView.h"
#import "DaiFenPeiTableView.h"
#import "Header.h"
#import "YiFenPeiTableViewCell.h"
#import "DaiFenPeiVC.h"
#import "HeadDisTableView.h"
#import "UIUtils.h"
#import "RedScarf_API.h"
#import "AppDelegate.h"
#import "AllocatingTaskVC.h"
#import "FinishViewController.h"
#import "Model.h"
#import <objc/runtime.h>
#import "AddressViewVontroller.h"

@interface TaskViewController ()

@end

@implementation TaskViewController
{
    ModAddressTableView *modTableView;
    DistributionTableView *disTableView;
    DaiFenPeiTableView *daiFenTableView;
    UIView *navigationView;
    id resultData;
    
    int countStr;
    
    NSString *searchOrAll;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self comeBack:nil];
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;

    self.tabBarController.tabBar.hidden = YES;
//    self.navigationController.navigationBar.hidden = YES;
    
    if (disTableView.nameTableView.length) {
//        [self didClickPeiSong];
        disTableView.nameTableView = @"";
    }
    if (self.yiOrDaifenpei.length) {
        [self didClickYiFenPei];
        self.yiOrDaifenpei = @"";
    }
    if (daiFenTableView.nameTableView.length) {
        [self didClickDaiFenPeiBtn];
        daiFenTableView.nameTableView = @"";
    }

}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:22022].hidden = NO;
    [self.tabBarController.view viewWithTag:11011].hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = MakeColor(244, 245, 246);
    self.title = @"任务";
    searchOrAll = @"all";
    countStr = 0;
    self.nameArr = [NSMutableArray array];
    self.addressArr = [NSMutableArray array];
    self.dataArr = [NSMutableArray array];
    
    [self initButton];
    [self didClickDaiFenPeiBtn];
}

-(void)initButton
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 51)];
    view.backgroundColor = MakeColor(244, 245, 246);
    view.tag = 10000;
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    view.layer.borderColor = MakeColor(187, 186, 193).CGColor;
    view.layer.borderWidth = 1.0;
    
    UIButton *waitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    waitBtn.frame = CGRectMake(0, 0, view.frame.size.width/2, 45);
    waitBtn.tag = 100;
    [waitBtn setTitle:@"待分配" forState:UIControlStateNormal];
    [waitBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    waitBtn.font = [UIFont systemFontOfSize:18];
    [waitBtn addTarget:self action:@selector(didClickDaiFenPeiBtn) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:waitBtn];
    UIButton *OverBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    OverBtn.frame = CGRectMake(view.frame.size.width/2, 0, view.frame.size.width/2, 45);
    [OverBtn setTitle:@"已分配" forState:UIControlStateNormal];
    [OverBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    OverBtn.font = [UIFont systemFontOfSize:18];
    OverBtn.tag = 200;
    [OverBtn addTarget:self action:@selector(didClickYiFenPei) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:OverBtn];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 48, kUIScreenWidth/2, 3)];
    footView.backgroundColor =  MakeColor(79, 136, 251);
    footView.tag = 10001;
    [view addSubview:footView];
    [self setBtnBackgroundColor:0];
}

-(void)initTableView
{

    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 115, kUIScreenWidth, 51)];
    self.searchBar.delegate = self;
    [self.searchBar setBarTintColor:color242];
    [self.searchBar.layer setBorderColor:color242.CGColor];
    [self.searchBar.layer setBorderWidth:1.0];
    
    self.searchBar.placeholder = @"搜索配送人";
    self.YiFenPeiTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 115, kUIScreenWidth, kUIScreenHeigth-115)];
    self.YiFenPeiTableview.tag = 100002;
    self.YiFenPeiTableview.tableHeaderView = self.searchBar;
    self.YiFenPeiTableview.backgroundColor = color242;
    self.YiFenPeiTableview.delegate = self;
    self.YiFenPeiTableview.dataSource = self;
    //去掉分割线
//    self.YiFenPeiTableview.separatorStyle = UITableViewCellSeparatorStyleNone;

    [self.view addSubview:self.YiFenPeiTableview];
    [self showHUD:@"正在加载"];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    
    NSString *nameStr = [NSString stringWithFormat:@"%@",self.searchBar.text];
    nameStr = [nameStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [params setObject:nameStr forKey:@"name"];
    
    [RedScarf_API requestWithURL:@"/task/assignTask/user" params:params httpMethod:@"GET" block:^(id result) {

        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            [self.dataArr removeAllObjects];
            searchOrAll = @"search";
            for (NSMutableDictionary *dic in [result objectForKey:@"msg"]) {
                NSLog(@"dic = %@",dic);
                Model *model = [[Model alloc] init];
                model.username = [dic objectForKey:@"username"];
                model.apartmentsArr = [dic objectForKey:@"tasks"];
                model.mobile = [dic objectForKey:@"mobile"];
                model.userId = [dic objectForKey:@"userId"];
                [self.dataArr addObject:model];
            }
//            self.searchBar.text = [NSString stringWithString:[self.searchBar.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
            [self.YiFenPeiTableview reloadData];

        }
    }];

    [self.view endEditing:YES];
}


-(void)didClickFenPei
{
    [self setBtnBackgroundColor:0];
    
    NSArray *views = [self.view subviews];
    for (UITableView *table in views) {
        if ([table isKindOfClass:[UITableView class]]) {
            [table removeFromSuperview];
            
        }
        
    }

    HeadDisTableView *view = (HeadDisTableView *)[[self.view viewWithTag:100006] viewWithTag:100005];
    [view removeFromSuperview];
    UIImageView *groundView = (UIImageView *)[self.view viewWithTag:100006];
    [groundView removeFromSuperview];

    [[self.view viewWithTag:10000] setHidden:NO];

    [self didClickDaiFenPeiBtn];

}

//-(void)didClickPeiSong
//{
//    [self setBtnBackgroundColor:2];
//    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    btn = (UIButton *)[navigationView viewWithTag:102];
//    [btn setBackgroundColor:MakeColor(21, 83, 177)];
//
//    NSArray *views = [self.view subviews];
//    for (UITableView *table in views) {
//        if ([table isKindOfClass:[UITableView class]]) {
//            [table removeFromSuperview];
//
//        }
//    }
//
//    [[self.view viewWithTag:10000] setHidden:YES];
//    
//    UIImageView *backgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(40, navigationView.frame.origin.y+navigationView.frame.size.height, kUIScreenWidth-80, kUIScreenHeigth/2-55)];
//    [self.view addSubview:backgroundView];
//    backgroundView.tag = 100006;
////    backgroundView.contentMode = UIViewContentModeScaleAspectFit;
//    backgroundView.image = [UIImage imageNamed:@"beijing@2x"];
//    backgroundView.userInteractionEnabled = YES;
//    
//    HeadDisTableView *headTableView = [[HeadDisTableView alloc] initWithFrame:CGRectMake(10, 0,backgroundView.frame.size.width-30, backgroundView.frame.size.height-50)];
//    headTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    headTableView.tag = 100005;
//    [backgroundView addSubview:headTableView];
//    
//    UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(backgroundView.frame.size.width/2-80, headTableView.frame.size.height+headTableView.frame.origin.y+12, 160, 10)];
//    countLabel.tag = 100008;
//    countLabel.text = [NSString stringWithFormat:@"—总计:%d份—",countStr];
//    countLabel.font = [UIFont systemFontOfSize:12];
//    countLabel.textAlignment = UITextAlignmentCenter;
//    [backgroundView addSubview:countLabel];
//    
//    
//    disTableView = [[DistributionTableView alloc] initWithFrame:CGRectMake(0, kUIScreenHeigth/2+10, kUIScreenWidth,kUIScreenHeigth/2-55)];
//    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(10, 0, kUIScreenWidth-10, 0.5)];
//    line.backgroundColor = MakeColor(187, 186, 193);
//    UIView *footView = [[UIView alloc] init];
//    disTableView.tableFooterView = footView;
//    disTableView.tableHeaderView = line;
//    [self.view addSubview:disTableView];
//}
//

-(void)didClickDaiFenPeiBtn
{
    NSArray *views = [self.view subviews];
    for (UITableView *table in views) {
        if ([table isKindOfClass:[UITableView class]]) {
            [table removeFromSuperview];
            
        }
    }
    [self.view addSubview:[self.view viewWithTag:10000]];
    
    UIView *footView = [[self.view viewWithTag:10000] viewWithTag:10001];
    footView.frame = CGRectMake(0, 47, kUIScreenWidth/2, 3);
    UIButton *btn = (UIButton *)[[self.view viewWithTag:10000] viewWithTag:100];
    [btn setTitleColor: MakeColor(79, 136, 251) forState:UIControlStateNormal];
    UIButton *btn1 = (UIButton *)[[self.view viewWithTag:10000] viewWithTag:200];
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    daiFenTableView = [[DaiFenPeiTableView alloc] initWithFrame:CGRectMake(0, 115, self.view.frame.size.width, self.view.frame.size.height-115)];
    daiFenTableView.tag = 100000;
//    daiFenTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIView *foot = [[UIView alloc] init];
    daiFenTableView.tableFooterView = foot;
    [self.view addSubview:daiFenTableView];
}

-(void)didClickYiFenPei
{
    UIView *footView = [[self.view viewWithTag:10000] viewWithTag:10001];
    footView.frame = CGRectMake(kUIScreenWidth/2, 47, kUIScreenWidth/2, 3);
    UIButton *btn = (UIButton *)[[self.view viewWithTag:10000] viewWithTag:100];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    UIButton *btn1 = (UIButton *)[[self.view viewWithTag:10000] viewWithTag:200];
    [btn1 setTitleColor: MakeColor(79, 136, 251) forState:UIControlStateNormal];
    searchOrAll = @"all";

    [self getMessage];
    [self initTableView];
}

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [params setValue:@"" forKey:@"name"];
    [RedScarf_API requestWithURL:@"/task/assignTask/user" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            [self.dataArr removeAllObjects];
            for (NSMutableDictionary *dic in [result objectForKey:@"msg"]) {
                NSLog(@"dic = %@",dic);
                Model *model = [[Model alloc] init];
                model.username = [dic objectForKey:@"username"];
                model.tasksArr = [dic objectForKey:@"tasks"];
                model.mobile = [dic objectForKey:@"mobile"];
                model.userId = [dic objectForKey:@"userId"];
                [self.dataArr addObject:model];
                
            }
            [self.YiFenPeiTableview reloadData];
        }
        [self hidHUD];
    }];

}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    Model *model = [[Model alloc] init];
    model = [self.dataArr objectAtIndex:section];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 44)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, 44.5, kUIScreenWidth-10, 0.5)];
    line.backgroundColor = color155;
    [view addSubview:line];
    
    UIImageView *personImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 15, 3, 14)];
    personImageView.backgroundColor = colorblue;
    [view addSubview:personImageView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kUIScreenWidth, 42)];
    nameLabel.text = [NSString stringWithFormat:@"%@:%@",model.username,model.mobile];
    nameLabel.textColor = [UIColor grayColor];
    nameLabel.font = [UIFont systemFontOfSize:15];
    [view addSubview:nameLabel];
    
    return view;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 10)];
    view.backgroundColor = color242;

    return view;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Model *model = [[Model alloc] init];
    model = [self.dataArr objectAtIndex:section];
    if ([searchOrAll isEqualToString:@"all"]) {
        return model.tasksArr.count;

    }
    return model.apartmentsArr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    YiFenPeiTableViewCell *cell = [[YiFenPeiTableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
    }
    
    Model *model = [[Model alloc] init];
    model = [self.dataArr objectAtIndex:indexPath.section];
    
    NSMutableDictionary *addressDic;
    if ([searchOrAll isEqualToString:@"all"]) {
        addressDic = model.tasksArr[indexPath.row];

    }else if ([searchOrAll isEqualToString:@"search"]){
        addressDic = model.apartmentsArr[indexPath.row];

    }
    
    NSString *str = [NSString stringWithFormat:@"%@",[addressDic objectForKey:@"apartmentName"]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGSize size = CGSizeMake(kUIScreenWidth-135, 30);
    CGSize labelSize = [str sizeWithFont:cell.addressLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    cell.addressLabel.frame = CGRectMake(20, 12, labelSize.width, labelSize.height);
    cell.addressLabel.text = str;
    
    UILabel *taskNum = [[UILabel alloc] initWithFrame:CGRectMake(cell.addressLabel.frame.size.width+cell.addressLabel.frame.origin.x+10, 14, 30, 15)];
    taskNum.font = [UIFont systemFontOfSize:13];
    taskNum.text = [NSString stringWithFormat:@"%@份",[addressDic objectForKey:@"taskNum"]];
    taskNum.textColor = [UIColor grayColor];
    [cell.contentView addSubview:taskNum];

    
    [cell.btn setTitle:@"分配" forState:UIControlStateNormal];
    //关联button
    objc_setAssociatedObject(cell.btn, &UITableViewIndexSearch, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [cell.btn addTarget:self action:@selector(didClickFenPeiBtn:) forControlEvents:UIControlEventTouchUpInside];

    [cell.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    YiFenPeiTableViewCell *cell = (YiFenPeiTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    Model *model = [[Model alloc] init];
    model = [self.dataArr objectAtIndex:indexPath.section];
    NSMutableDictionary *addressDic;

    if ([searchOrAll isEqualToString:@"all"]) {
        addressDic = model.tasksArr[indexPath.row];

    }else{
        addressDic = model.apartmentsArr[indexPath.row];

    }
    
    DaiFenPeiVC *daiFenPeiVC = [[DaiFenPeiVC alloc] init];
    daiFenPeiVC.delegate = self;
    daiFenPeiVC.number = 0;
    daiFenPeiVC.aId = [addressDic objectForKey:@"apartmentId"];
    daiFenPeiVC.userId = model.userId;
    daiFenPeiVC.titleStr = cell.addressLabel.text;
    [self.navigationController pushViewController:daiFenPeiVC animated:YES];
    
}

-(void)didClickFenPeiBtn:(id)sender
{
    //统计
    [[BaiduMobStat defaultStat] logEvent:@"分 配" eventLabel:@"button3"];

    
    UIButton *btn = (UIButton *)sender;
    NSIndexPath *indexPath = objc_getAssociatedObject(btn, &UITableViewIndexSearch);
    Model *model = [[Model alloc] init];
    NSMutableDictionary *addressDic;

    if ([searchOrAll isEqualToString:@"all"]) {
        model = [self.dataArr objectAtIndex:indexPath.section];
        addressDic = model.tasksArr[indexPath.row];
    }else{
        model = [self.dataArr objectAtIndex:indexPath.section];
        addressDic = model.apartmentsArr[indexPath.row];
    }
    

    NSLog(@"indexPath.row = %ld,indexPath.section = %ld",(long)indexPath.row,(long)indexPath.section);
    AllocatingTaskVC *allocaVC = [[AllocatingTaskVC alloc] init];
    allocaVC.aId = [addressDic objectForKey:@"apartmentId"];
    allocaVC.delegate  = self;
    allocaVC.num = 1;
    allocaVC.number = 0;
    allocaVC.userId = model.userId;
    [self.navigationController pushViewController:allocaVC animated:YES];
}

-(void)returnNameOfTableView:(NSString *)name
{
    self.yiOrDaifenpei = name;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)setBtnBackgroundColor:(int)index
{
    for (int i = 0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        if (i == index) {
            btn = (UIButton *)[navigationView viewWithTag:100+i];
            [btn setBackgroundColor:MakeColor(21, 83, 177)];
        }else{
            btn = (UIButton *)[navigationView viewWithTag:100+i];
            [btn setBackgroundColor: MakeColor(32, 102, 205)];
            
        }
    }
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
