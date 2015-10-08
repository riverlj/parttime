//
//  OrderRangeViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/17.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "OrderRangeViewController.h"
#import "RedScarf_API.h"

@interface OrderRangeViewController ()

@end

@implementation OrderRangeViewController
{
    NSMutableArray *addressArray;
    NSMutableArray *idArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"配送范围";
    self.tabBarController.tabBar.hidden = YES;
    addressArray = [NSMutableArray array];
    idArray = [NSMutableArray array];
    [self navigationBar];
    [self initTableView];
    [self getMessage];
}

-(void)navigationBar
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comeback"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDone)];
//    right.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = right;
    
    //隐藏tabbar上的按钮
    UIButton *barBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [barBtn removeFromSuperview];
}

-(void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    
    [RedScarf_API requestWithURL:@"/user/setting/addr" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
    
            addressArray = [[result objectForKey:@"msg"] objectForKey:@"apartments"];
            [idArray addObject:[[result objectForKey:@"msg"] objectForKey:@"selectedApartments"]];
            
        }else
        {
            [self alertView:[result objectForKey:@"msg"]];
        }
        [self.tableView reloadData];
    }];
}

#pragma mark -- tableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return addressArray.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    NSMutableDictionary *dic = [addressArray objectAtIndex:indexPath.row];
    
    cell.textLabel.text = [dic objectForKey:@"name"];
    
    for (NSString *str in idArray) {
        if ([str isEqualToString:[NSString stringWithFormat:@"%@",[dic objectForKey:@"id"]]]) {
            cell.backgroundColor = MakeColor(32, 190, 251);
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
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
