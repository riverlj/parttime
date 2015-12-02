//
//  LevelViewController.m
//  RedScarf
//
//  Created by zhangb on 15/11/30.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "LevelViewController.h"

@interface LevelViewController ()

@end

@implementation LevelViewController
{
    NSString *currentGrow,*todayGrow,*rankGrow;
    UITableView *rankTableView;
    NSArray *rankArr,*imageArr,*growArr;
}

-(void)viewWillAppear:(BOOL)animated
{
    self.tabBarController.tabBar.hidden = YES;
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的等级";
    [self comeBack:nil];
    self.view.backgroundColor = color242;
    [self.view removeFromSuperview];
    
    rankArr = [NSArray arrayWithObjects:@"先锋队员",@"一道杠",@"两道杠",@"三道杠",@"四道杠",@"五道杠",@"老前辈", nil];
    imageArr = [NSArray arrayWithObjects:@"0",@"1-1-1",@"2-2",@"3-3",@"4",@"5",@"6", nil];
    growArr = [NSArray arrayWithObjects:@"0~199",@"200~799",@"800~1999",@"2000~3999",@"4000~6999",@"7000~11999",@"12000以上", nil];
//    [self initView];
    [self getMessage];
}

-(void)getMessage
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    if ([defaults objectForKey:@"token"]) {
        [params setObject:[defaults objectForKey:@"token"] forKey:@"token"];
        NSString *url = @"";
        [self showAlertHUD:@"正在加载"];
        for (int i = 0; i < 4; i++) {
            if (i == 0) {
               url = @"/user/growth";
            }
            if (i == 1) {
                url = @"/user/growth/today";
            }
            if (i == 2) {
                url = @"/user/growth/ranking";
            }
            if (i == 3) {
                url = @"/user/growth/log";
            }
            
            [RedScarf_API requestWithURL:@"/user/growth" params:params httpMethod:@"GET" block:^(id result) {
                NSLog(@"result = %@",result);
                if ([[result objectForKey:@"success"] boolValue]) {
                    [self hidHUD];
                    if (i == 0) {
                        currentGrow = [NSString stringWithFormat:@"%@",[result objectForKey:@"msg"]];
                    }
                    if (i == 1) {
                        todayGrow = [NSString stringWithFormat:@"%@",[result objectForKey:@"msg"]];
                    }
                    if (i == 2) {
                        rankGrow = [NSString stringWithFormat:@"%@",[result objectForKey:@"msg"]];
                    }
                    if (i == 3) {
                        
                    }
                }
                [self hidHUD];
                [[self.view viewWithTag:1000] removeFromSuperview];
                
                [self initView];
            }];
            
        }
        
    }
}

-(void)initView
{
    UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:bgView];
    bgView.contentSize = CGSizeMake(0, kUIScreenHeigth*1.6);
    bgView.userInteractionEnabled = YES;
    bgView.tag = 1000;
    
    UIView *levelView = [[UIView alloc] initWithFrame:CGRectMake(18, 84, kUIScreenWidth-36, 73)];
    levelView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:levelView];
    
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 11, 49, 49)];
    headView.layer.cornerRadius = 25;
    headView.layer.masksToBounds = YES;
    if ([self.headUrl rangeOfString:@"http"].location != NSNotFound) {
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.headUrl]]];
        headView.image = image;
    }else{
         headView.image = [UIImage imageNamed:@"touxiang"];
    }
   
    [levelView addSubview:headView];
    if ([self.position isEqualToString:@"ceo"]) {
        UILabel *ceoView = [[UILabel alloc] initWithFrame:CGRectMake(headView.frame.origin.x+headView.frame.size.width/2-12, headView.frame.origin.y+headView.frame.size.height-6, 24, 12)];
        ceoView.backgroundColor = colorblue;
        ceoView.layer.cornerRadius = 3;
        ceoView.textAlignment = NSTextAlignmentCenter;
        ceoView.layer.masksToBounds = YES;
        ceoView.textColor = [UIColor whiteColor];
        ceoView.text = @"ceo";
        ceoView.font = textFont12;
        [levelView addSubview:ceoView];
    }
    
    UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(headView.frame.size.width+headView.frame.origin.x+5, 16, 137, 15)];
    name.text = @"asdasdasd";
    name.font = textFont14;
    [levelView addSubview:name];
    
    UIImageView *levelImage = [[UIImageView alloc] initWithFrame:CGRectMake(name.frame.origin.x, 40, levelView.frame.size.width+levelView.frame.origin.x-150, 14)];
    [levelView addSubview:levelImage];
    levelImage.layer.cornerRadius = 8;
    levelImage.layer.masksToBounds = YES;
    levelImage.backgroundColor = color232;
    
    UIImageView *progressImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 14)];
    [levelImage addSubview:progressImage];
    progressImage.backgroundColor = [UIColor greenColor];
    [UIView animateWithDuration:1.5 animations:^{
        progressImage.frame = CGRectMake(0, 0, 100, 14);
    }];
    
    UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(levelImage.frame.size.width+levelImage.frame.origin.x+5, 40, 58, 12)];
    count.text = @"300/800";
    count.font = textFont12;
    count.textColor = color155;
    [levelView addSubview:count];
    //~~~~~~
    UILabel *rank = [[UILabel alloc] initWithFrame:CGRectMake(18, levelView.frame.size.height+levelView.frame.origin.y+10, 113, 11)];
    rank.text = [NSString stringWithFormat:@"全国等级排名：%@",@"104"];
    rank.font = textFont12;
    rank.textColor = color155;
    [bgView addSubview:rank];
    
    UILabel *predictionLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth-170, rank.frame.origin.y, 150, 11)];
    predictionLabel.textColor = color155;
    predictionLabel.font = textFont12;
    predictionLabel.text = @"距离三道杠还有300成长值";
    [bgView addSubview:predictionLabel];
    //~~~~~~~
    UIView *recordView = [[UIView alloc] initWithFrame:CGRectMake(18, predictionLabel.frame.size.height+predictionLabel.frame.origin.y+30, kUIScreenWidth-38, 41)];
    [bgView addSubview:recordView];
    recordView.backgroundColor = [UIColor whiteColor];
    UILabel *recordText = [[UILabel alloc] initWithFrame:CGRectMake(16, 14, 83, 15)];
    recordText.text = @"成长值记录";
    recordText.textColor = color155;
    recordText.font = textFont15;
    [recordView addSubview:recordText];
    
//    UIButton *recordBtn = [UIButton alloc] initWithFrame:<#(CGRect)#>
    
    UILabel *todayText = [[UILabel alloc] initWithFrame:CGRectMake(recordView.frame.size.width+recordView.frame.origin.x-135, 15, 95, 12)];
    todayText.textColor = color155;
    todayText.font = textFont12;
    todayText.text = [NSString stringWithFormat:@"今日成长值：%@",todayGrow];
    [recordView addSubview:todayText];
    UIImageView *recordDetail = [[UIImageView alloc] initWithFrame:CGRectMake(todayText.frame.size.width+todayText.frame.origin.x+5, 13, 9, 16)];
    recordDetail.image = [UIImage imageNamed:@"you2x"];
    [recordView addSubview:recordDetail];
    //~~~~~~~
    UIView *showView = [[UIView alloc] initWithFrame:CGRectMake(18, recordView.frame.size.height+recordView.frame.origin.y+20, kUIScreenWidth-36, 121)];
    showView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:showView];
    
   
    for (int i = 0; i < 4 ; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(12, 13+i*(14+13), showView.frame.size.width-20, 14)];
        [showView addSubview:label];
        label.textColor = color155;
        label.text = @"如何获得成长值？";
        label.font = textFont16;
        if (i == 1) {
            
            label.text = @"成功配送并送达一个任务，增加两个成长值";
            label.font = textFont12;
        }
        if (i == 2) {
            label.text = @"未送达一个任务，增加一个成长值";
            label.font = textFont12;
        }
        if (i == 3) {
            label.text = @"若配送的任务被用户成功投诉，相应成长值被取消";
            label.font = textFont12;
        }
    }
    rankTableView = [[UITableView alloc] initWithFrame:CGRectMake(18, showView.frame.size.height+showView.frame.origin.y+20, kUIScreenWidth-36, 366)];
    rankTableView.delegate = self;
    rankTableView.dataSource = self;
    UIView *foot = [[UIView alloc] init];
    rankTableView.tableFooterView = foot;
    rankTableView.layer.borderColor = color232.CGColor;
    rankTableView.layer.borderWidth = 0.5;
    rankTableView.layer.cornerRadius = 5;
    rankTableView.layer.masksToBounds = YES;
    [bgView addSubview:rankTableView];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth-36, 40)];
    for (int i = 0; i < 3; i++) {
        CGFloat wight = (kUIScreenWidth-36)/3;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(wight*i, 0, wight, 40)];
        label.textColor = color102;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = textFont14;
        [view addSubview:label];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = color232;
        [view addSubview:line];
        
        if (i == 0) {
            label.text = @"等级";
        }
        if (i == 1) {
            line.frame = CGRectMake(wight*i, 0, 0.8, 40);
            label.text = @"勋章";
        }
        if (i == 2) {
            line.frame = CGRectMake(wight*i, 0, 0.8, 40);
            label.text = @"成长值";
        }
    }
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 39.2, kUIScreenWidth-36, 0.8)];
    lineView.backgroundColor = color232;
    [view addSubview:lineView];
    
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.userInteractionEnabled = NO;
    for (int i = 0; i < 3; i++) {
        CGFloat wight = (kUIScreenWidth-36)/3;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(wight*i, 0, wight, 40)];
        label.textColor = color102;
        label.textAlignment = NSTextAlignmentCenter;
        label.font = textFont12;
        [cell.contentView addSubview:label];
        
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = color232;
        [cell.contentView addSubview:line];
        
        if (i == 0) {
            label.text = rankArr[indexPath.row];
        }
        if (i == 1) {
            line.frame = CGRectMake(wight*i, 0, 0.8, 40);
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.size.width/2-8, 10, 15, 15)];
            image.image = [UIImage imageNamed:imageArr[indexPath.row]];
            [label addSubview:image];
        }
        if (i == 2) {
            line.frame = CGRectMake(wight*i, 0, 0.8, 40);
            label.text = growArr[indexPath.row];
        }
    }

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

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
