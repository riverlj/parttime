//
//  DistributionTableView.m
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "DistributionTableView.h"
#import "ModTableViewCell.h"
#import "UIView+ViewController.h"
#import "AppDelegate.h"
#import "UIUtils.h"
#import "Model.h"
#import "GoPeiSongTableViewCell.h"
#import <objc/runtime.h>
#import "RoomViewController.h"


@implementation DistributionTableView

-(void)viewWillAppear:(BOOL)animated
{
    [self reloadData];
    self.addressArr = [NSMutableArray array];
    self.roomArr = [NSMutableArray array];
    self.totalArr = [NSMutableArray array];
    [self getMessage];
    
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        self.backgroundColor = color_gray_f3f5f7;
        self.addressArr = [NSMutableArray array];
        self.roomArr = [NSMutableArray array];
        self.totalArr = [NSMutableArray array];
        self.separatorStyle = UITableViewCellSeparatorStyleNone;

        UIView *footView = [[UIView alloc] init];
        self.tableFooterView = footView;
        self.judgeStr = @"no";
        [self getMessage];
        self.delegate = self;
        self.dataSource = self;
        [self viewDidLayoutSubviews];
    }
    
    return self;
}

-(void)getMessage
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [self showHUD:@"正在加载"];
    [RSHttp requestWithURL:@"/task/assignedTask/apartmentAndCount" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [self hidHUD];
        NSArray *arr = [NSArray arrayWithArray:[data objectForKey:@"body"]];
        if (![arr count]) {
            [self addSubview:[self named:@"kongrenwu" text:@"任务"]];
        }
        [self.addressArr removeAllObjects];
        for (NSMutableDictionary *dic in [data objectForKey:@"body"]) {
            NSLog(@"dic = %@",dic);
            Model *model = [[Model alloc] init];
            model.apartmentName = [dic objectForKey:@"apartmentName"];
            model.taskNum = [dic objectForKey:@"taskNum"];
            model.aId = [dic objectForKey:@"apartmentId"];
            model.apartmentsArr = nil;
            model.select = @"zu2x";
            [self.addressArr addObject:model];
        }
        
        //默认展开第一行
        [self detailZero:0];
        [self reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
    }];
}

-(void)getRoomMsg:(NSString *)sender
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:sender forKey:@"aId"];
    [RSHttp requestWithURL:@"/task/assignedTask/roomDetail" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [self.roomArr removeAllObjects];
        for (Model *model in self.addressArr) {
            if ([model.aId isEqualToString:sender]) {
                model.apartmentsArr = [[data objectForKey:@"body"] mutableCopy];
            }
        }
        [self reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.addressArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    Model *model = [[Model alloc] init];
    if (self.addressArr.count) {
        model = self.addressArr[section];
    }
    
    if ([model.select isEqualToString:@"zu2x"]) {
        return 0;
    }
    if ([model.select isEqualToString:@"xialazu2x"]) {
        return model.apartmentsArr.count;
    }
    
    return model.apartmentsArr.count;
   
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 45)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 44.5, kUIScreenWidth, 0.5)];
    lineView.backgroundColor = color155;
    [bgView addSubview:lineView];
    
    UIImageView *click = [[UIImageView alloc] initWithFrame:CGRectMake(20, 18, 8, 8)];
    
    [bgView addSubview:click];
    
    UILabel *label = [[UILabel alloc] init];
    [bgView addSubview:label];
    label.textColor = color102;
    label.font = textFont15;
    label.textAlignment = NSTextAlignmentLeft;
    Model *model = [[Model alloc] init];
    model = [self.addressArr objectAtIndex:section];
    click.image = [UIImage imageNamed:model.select];

    NSString *str = [NSString stringWithFormat:@"%@",model.apartmentName];
    
    CGSize size = CGSizeMake(kUIScreenWidth-80, 1000);
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:label.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect rect = [str boundingRectWithSize:size options:options attributes:attributes context:nil];

    
    label.frame = CGRectMake(35, 12, rect.size.width, rect.size.height);
    label.text = str;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.size.width+label.frame.origin.x+5, 15, 12, 12)];
    img.image = [UIImage imageNamed:@"loudong"];
    [bgView addSubview:img];
    
    UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth-40, 8, 30, 30)];
    count.text = [NSString stringWithFormat:@"%@单",model.taskNum];
    count.textColor = color155;
    count.font = textFont12;
    [bgView addSubview:count];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 45)];
    [bgView addSubview:btn];
    btn.tag = section;
    [btn addTarget:self action:@selector(detail:) forControlEvents:UIControlEventTouchUpInside];
    
    return bgView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    GoPeiSongTableViewCell *cell = (GoPeiSongTableViewCell *)[self tableView:self cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height+10 ;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier2";
    GoPeiSongTableViewCell *cell = [[GoPeiSongTableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = MakeColor(242, 242, 248);
    cell.bgImageView.backgroundColor = [UIColor whiteColor];
    NSString *contentStr = @"";
    NSMutableArray *lengthArr = [NSMutableArray array];
    NSMutableArray *countArr = [NSMutableArray array];
    Model *mo = self.addressArr[indexPath.section];
    
    self.roomArr = mo.apartmentsArr;
    NSMutableDictionary *model = [self.roomArr objectAtIndex:indexPath.row];
    for (NSMutableDictionary *dic in [[self.roomArr objectAtIndex:indexPath.row] objectForKey:@"content"]) {
        
        contentStr = [contentStr stringByAppendingFormat:@"%@                 (%@份)\n",[dic objectForKey:@"tag"],[dic objectForKey:@"count"]];
        
        NSString *countStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"count"]];
        
        [countArr addObject:[NSNumber numberWithUnsignedInteger:countStr.length+3]];
        [lengthArr addObject:[NSNumber numberWithUnsignedInteger:contentStr.length-1]];
        
    }
    contentStr = [contentStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    //数量和餐品颜色
    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
    for (int i = 0; i < lengthArr.count; i++) {
        //份数颜色
        int tagLength = [[countArr objectAtIndex:i] intValue];
        int contentLength = [[lengthArr objectAtIndex:i]intValue];
        NSRange tagRange = NSMakeRange(contentLength-tagLength, tagLength);
        [noteStr addAttribute:NSForegroundColorAttributeName value:colorblue range:tagRange];
    }

    cell.addLabel.text = [NSString stringWithFormat:@"%@(%@单)",[model objectForKey:@"room"],[model objectForKey:@"taskNum"]];
    [cell setIntroductionText:noteStr];
    
    cell.btn.tag = indexPath.row;
    cell.detailBtn.tag = indexPath.row;
    [cell.btn setTitle:@"送达" forState:UIControlStateNormal];
    objc_setAssociatedObject(cell.btn, &UITableViewIndexSearch, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(cell.detailBtn, &UITableViewIndexSearch, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [cell.btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.detailBtn addTarget:self action:@selector(didClickDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

//送达
-(void)didClickBtn:(id)sender
{
    [[BaiduMobStat defaultStat] logEvent:@"送达" eventLabel:@"button10"];
    UIButton *btn = (UIButton *)sender;
    NSIndexPath *indexPath = objc_getAssociatedObject(btn, &UITableViewIndexSearch);

    Model *model = [[Model alloc] init];
    model = [self.addressArr objectAtIndex:indexPath.section];
    
    NSMutableArray *roomArray = model.apartmentsArr;
    
    NSMutableDictionary *roomDic = [roomArray objectAtIndex:indexPath.row];
    self.roomNum = [roomDic objectForKey:@"room"];
    
    self.aId = model.aId;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请确认所有商品都已送到，点击后将提示用户领取" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
    [alertView show];
}
//详情
-(void)didClickDetailBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSIndexPath *indexPath = objc_getAssociatedObject(btn, &UITableViewIndexSearch);
    
    Model *model = self.addressArr[indexPath.section];
    self.roomArr = model.apartmentsArr;
    NSMutableDictionary *dic = [self.roomArr objectAtIndex:indexPath.row];
    
    if([dic objectForKey:@"room"]) {
        RoomViewController *roomVC = [[RoomViewController alloc] init];
        roomVC.titleStr = [dic objectForKey:@"room"];
        roomVC.room = [dic objectForKey:@"room"];
        roomVC.aId = model.aId;
        [self.viewController.navigationController pushViewController:roomVC animated:YES];
    } else {
        [(BaseViewController *)self.delegate showToast:@"寝室号错误!"];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            app.tocken = [UIUtils replaceAdd:app.tocken];
            [params setObject:self.aId forKey:@"aId"];
            [params setObject:self.roomNum forKey:@"room"];
            [params setObject:@"2" forKey:@"source"];
            [self showHUD:@"送达中..."];
            [RSHttp requestWithURL:@"/task/assignedTask/finishRoom" params:params httpMethod:@"PUT" success:^(NSDictionary *data) {
                [self showToast:@"成功送达"];
                Model *tempModel;
                NSDictionary *tempDic;
                for (Model *model in self.addressArr) {
                    if ([model.aId isEqualToString:self.aId]) {
                        tempModel = model;
                        for(NSDictionary *dic in model.apartmentsArr) {
                            if([[dic valueForKey:@"room"] isEqualToString:self.roomNum]) {
                                tempDic = dic;
                            }
                        }
                    }
                }
                [tempModel.apartmentsArr removeObject:tempDic];
                self.roomNum = nil;
                if([tempModel.apartmentsArr count] == 0) {
                    [self.addressArr removeObject:tempModel];
                    [self detailZero:0];
                }
                [self reloadData];
                [self hidHUD];
            } failure:^(NSInteger code, NSString *errmsg) {
                [self hidHUD];
                [self showToast:errmsg];
            }];
        }
            break;
            
        default:
            break;
    }
}

-(void)didClickLeft
{
    [self.viewController.navigationController popViewControllerAnimated:YES];
}

-(void)detail:(id)sender
{
    UIButton *btn = (UIButton *)sender;
  
    Model *model = [[Model alloc] init];
    model = self.addressArr[btn.tag];
    if ([model.select isEqualToString:@"zu2x"]) {
        model.select = @"xialazu2x";
    }else{
        model.select = @"zu2x";
    }
    
    for (int i = 0; i < self.addressArr.count; i++) {
        if (i != btn.tag) {
            Model *model = [[Model alloc] init];
            model = self.addressArr[i];
            model.select = @"zu2x";
        }
    }

    
    [self getRoomMsg:model.aId];
}

-(void)detailZero:(int)sender
{
    Model *model = [[Model alloc] init];
    if (self.addressArr.count) {
        model = self.addressArr[sender];
        if ([model.select isEqualToString:@"zu2x"]) {
            model.select = @"xialazu2x";
        }else{
            model.select = @"zu2x";
        }
        
        [self getRoomMsg:model.aId];
    }else{
        
    }
}

-(void)viewDidLayoutSubviews {
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)])  {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)returnNameOfTableView:(NSString *)name
{
    self.nameTableView = name;
}

@end
