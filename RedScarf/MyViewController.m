//
//  MyViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/5.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "MyViewController.h"
#import "Header.h"
#import "PromotionViewController.h"
#import "MoneyOfMonth.h"
#import "MyBankCardsVC.h"
#import "Model.h"
#import "MyBankCardVC.h"
#import "SuggestionViewController.h"
#import "OrderTimeViewController.h"
#import "OrderRangeViewController.h"
#import "PersonMsgViewController.h"
#import "GoPeiSongViewController.h"

@interface MyViewController ()
{
    NSArray *cellArr;
    NSArray *imageArr;
    NSMutableDictionary *infoDic;
    UIImageView *headImage;
}

@end

@implementation MyViewController

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:22022].hidden = NO;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    //改变navigationbar的颜色
    self.navigationController.navigationBar.barTintColor = MakeColor(26, 30, 37);
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    [self getMessage];
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor],NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = (UIButton *)[self.tabBarController.view viewWithTag:22022];
    [button removeFromSuperview];
    self.view.backgroundColor = bgcolor;
    self.title = @"我的";
    
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reach currentReachabilityStatus];
    
    NSString *net = [self stringFromStatus:status];
    NSLog(@"net = %@",net);
    if ([net isEqualToString:@"not"]) {
        [self alertView:@"当前没有网络"];
    }
    //圆形
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-25, kUIScreenHeigth-80, 60, 60)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn addTarget:self action:@selector(pressChange:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 30;
    btn.tag = 22022;
    [btn setBackgroundImage:[UIImage imageNamed:@"去送餐2x"] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    
    [self.tabBarController.view addSubview:btn];


    cellArr = [NSArray arrayWithObjects:@"配送时间",@"配送范围", nil];
    imageArr = [NSArray arrayWithObjects:@"time",@"anwei", nil];
    [self getMessage];
    [self initTableView];
}

-(void)pressChange:(id)sender
{
    GoPeiSongViewController *goVC = [[GoPeiSongViewController alloc] init];
    [self.navigationController pushViewController:goVC animated:YES];
    
}


-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    
    [RedScarf_API requestWithURL:@"/user/info" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            infoDic = [NSMutableDictionary dictionary];
            infoDic = [result objectForKey:@"msg"];
            
            }
        
        [self.informationTableView reloadData];
    }];
}

-(void)initTableView
{
    self.informationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
    self.informationTableView.delegate = self;
    self.informationTableView.dataSource = self;
    UIView *view = [[UIView alloc] init];
    self.informationTableView.tableFooterView = view;
    self.informationTableView.backgroundColor = bgcolor;
    
    [self.view addSubview:self.informationTableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }
    if (section == 2) {
        return 1;
    }
    if (section == 3) {
        return 2;
    }
    if (section == 4) {
        return 1;
    }
    
    return 1;

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    
    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 170;
    }
    return 45;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    [self.navigationController setNavigationBarHidden:NO];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if (indexPath.section == 0) {
        cell.backgroundColor = MakeColor(55, 57, 63);
        headImage = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-40, 15, 80, 80)];
        headImage.layer.cornerRadius = 35;
        headImage.layer.masksToBounds = YES;

            NSString *imageFile=[NSTemporaryDirectory() stringByAppendingPathComponent:@"/img.png"];
            NSData *imageData = [[NSData alloc] initWithContentsOfFile:imageFile];
            UIImage *image = [[UIImage alloc] initWithData:imageData];
            if (image != nil)
            {
                headImage.image = image;
            }else{
                headImage.image = [UIImage imageNamed:@"touxiang"];
            }

       cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.contentView addSubview:headImage];
        
        UIImageView *ceoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(headImage.frame.origin.x+headImage.frame.size.width/2-10, headImage.frame.origin.y+headImage.frame.size.height-8, 20, 10)];
        ceoImageView.image = [UIImage imageNamed: @"ceo"];
        [cell.contentView addSubview:ceoImageView];
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-40, headImage.frame.size.height+headImage.frame.origin.y+5, 80, 30)];
        nameLabel.textAlignment = NSTextAlignmentCenter;
        NSMutableDictionary *userInfo = [infoDic objectForKey:@"userInfo"];
        nameLabel.text = [userInfo objectForKey:@"realName"];
        nameLabel.textColor = [UIColor whiteColor];
        nameLabel.font = [UIFont systemFontOfSize:16];
        UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-45, nameLabel.frame.size.height+nameLabel.frame.origin.y-5, 100, 25)];
        
        telLabel.text = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"mobilePhone"]];
        telLabel.textColor = colorblue;
        telLabel.textAlignment = NSTextAlignmentCenter;
        telLabel.font = [UIFont systemFontOfSize:14];
        [cell.contentView addSubview:nameLabel];
        [cell.contentView addSubview:telLabel];
        
    }else if (indexPath.section == 1) {
        

        for (int i = 0; i < 1; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(47, 10, 280, 25)];
            label.textColor = MakeColor(75, 75, 75);
            if (indexPath.row == 0) {
                UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 20, 20)];
                photoView.image = [UIImage imageNamed:@"Wallet3x"];
                [cell.contentView addSubview:photoView];
                label.text = [NSString stringWithFormat:@"我的工资"];
                
            }else if (indexPath.row == 1){

                UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 20, 20)];
                photoView.image = [UIImage imageNamed:@"yinhang2x"];
                [cell.contentView addSubview:photoView];
                label.text = @"我的银行卡";
            }
            label.font = [UIFont systemFontOfSize:16];

            [cell.contentView addSubview:label];
        }
    }
    else if (indexPath.section == 2){
        
        UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 20, 20)];
        photoView.image = [UIImage imageNamed:@"fankui2x"];
        [cell.contentView addSubview:photoView];
        
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 10, 280, 25)];
        cellLabel.text = @"意见反馈";
        cellLabel.textColor = MakeColor(75, 75, 75);
        cellLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:cellLabel];
    }
    else if (indexPath.section == 3){
        
        UIImageView *photoView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 20, 20)];
        photoView.image = [UIImage imageNamed:imageArr[indexPath.row]];
        [cell.contentView addSubview:photoView];
        
        UILabel *cellLabel = [[UILabel alloc] initWithFrame:CGRectMake(47, 10, 280, 25)];
        cellLabel.text = cellArr[indexPath.row];
        cellLabel.textColor = MakeColor(75, 75, 75);
        cellLabel.font = [UIFont systemFontOfSize:16];
        [cell.contentView addSubview:cellLabel];
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        PersonMsgViewController *personVC = [[PersonMsgViewController alloc] init];
        personVC.personMsgArray = [NSMutableArray array];
        NSMutableDictionary *info = [infoDic objectForKey:@"userInfo"];
        if (info) {
            [personVC.personMsgArray addObject:[info objectForKey:@"realName"]];
            NSMutableDictionary *apartmentDic = [info objectForKey:@"apartment"];
            //学校
            [personVC.personMsgArray addObject:[[apartmentDic objectForKey:@"school"] objectForKey:@"name"]];
            personVC.schoolId = [[apartmentDic objectForKey:@"school"] objectForKey:@"id"];
            //地址
            [personVC.personMsgArray addObject:[apartmentDic objectForKey:@"name"]];
            [personVC.personMsgArray addObject:[info objectForKey:@"mobilePhone"]];
            [personVC.personMsgArray addObject:[info objectForKey:@"idCardNo"]];
            [personVC.personMsgArray addObject:[info objectForKey:@"studentIdCardNo"]];
            [personVC.personMsgArray addObject:@"密码"];
            [personVC.personMsgArray addObject:[info objectForKey:@"sex"]];
            [self.navigationController pushViewController:personVC animated:YES];

        }
            }
    if (indexPath.section == 1) {
        
        if (indexPath.row == 0) {
            MoneyOfMonth *moneyOfMonthVC = [[MoneyOfMonth alloc] init];
            moneyOfMonthVC.salary = [infoDic objectForKey:@"salary"];
            [self.navigationController pushViewController:moneyOfMonthVC animated:YES];
            
        }else if (indexPath.row == 1){

            MyBankCardVC *bankCardVC = [[MyBankCardVC alloc] init];
            [self.navigationController pushViewController:bankCardVC animated:YES];
        }
        
    }
    if (indexPath.section == 2) {
        SuggestionViewController *suggestionVC = [[SuggestionViewController alloc] init];
        [self.navigationController pushViewController:suggestionVC animated:YES];
    }
    if (indexPath.section == 3) {
        if (indexPath.row == 0) {
            OrderTimeViewController *orderTimeVC = [[OrderTimeViewController alloc] init];
            NSMutableDictionary *userInfo = [infoDic objectForKey:@"userInfo"];
//            orderTimeVC.username = [userInfo objectForKey:@"username"];
            [self.navigationController pushViewController:orderTimeVC animated:YES];
        }
        if (indexPath.row == 1) {
            OrderRangeViewController *orderRangeVC = [[OrderRangeViewController alloc] init];
            NSMutableDictionary *userInfo = [infoDic objectForKey:@"userInfo"];
            orderRangeVC.username = [userInfo objectForKey:@"username"];
            [self.navigationController pushViewController:orderRangeVC animated:YES];
        }
        
    }
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
