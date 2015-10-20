//
//  DistributionTableView.m
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "DistributionTableView.h"
#import "ModTableViewCell.h"
#import "DaiFenPeiVC.h"
#import "UIView+ViewController.h"
#import "DistributionVC.h"
#import "AppDelegate.h"
#import "RedScarf_API.h"
#import "UIUtils.h"
#import "Model.h"
#import "GoPeiSongTableViewCell.h"
#import <objc/runtime.h>
#import "RoomViewController.h"


@implementation DistributionTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

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
        self.backgroundColor = MakeColor(242, 242, 248);
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
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [self showHUD:@"正在加载"];
    [RedScarf_API requestWithURL:@"/task/assignedTask/apartmentAndCount" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            [self.addressArr removeAllObjects];
            for (NSMutableDictionary *dic in [result objectForKey:@"msg"]) {
                NSLog(@"dic = %@",dic);
                Model *model = [[Model alloc] init];
                model.apartmentName = [dic objectForKey:@"apartmentName"];
                model.taskNum = [dic objectForKey:@"taskNum"];
                model.aId = [dic objectForKey:@"apartmentId"];
                model.apartmentsArr = nil;
                model.select = @"zu2x";
                [self.addressArr addObject:model];
            }
            
//            Model *m = self.addressArr[0];
//            m.select = @"xialazu2x";

            [self reloadData];
        }
        [self hidHUD];
    }];
    
}

-(void)getRoomMsg:(NSString *)sender
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [params setObject:sender forKey:@"aId"];
    
    [RedScarf_API requestWithURL:@"/task/assignedTask/roomDetail" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            [self.roomArr removeAllObjects];

            for (Model *model in self.addressArr) {
                if ([model.aId isEqualToString:sender]) {
                    model.apartmentsArr = [result objectForKey:@"msg"];
                }
            }
            [self reloadData];

        }
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
    lineView.backgroundColor = color102;
    [bgView addSubview:lineView];
    
    UIImageView *click = [[UIImageView alloc] initWithFrame:CGRectMake(10, 18, 8, 8)];
    
    [bgView addSubview:click];
    
    UILabel *label = [[UILabel alloc] init];
    [bgView addSubview:label];
    label.textColor = color102;
    label.font = textFont15;
    label.textAlignment = NSTextAlignmentLeft;
    Model *model = [[Model alloc] init];
//    if (self.addressArr.count) {
        model = [self.addressArr objectAtIndex:section];
//        if (section == 0) {
//            click.image = [UIImage imageNamed:@"xialazu2x"];
//        }else{
            click.image = [UIImage imageNamed:model.select];
//        }
//    }
    NSString *str = [NSString stringWithFormat:@"%@",model.apartmentName];
    
    CGSize size = CGSizeMake(kUIScreenWidth-80, 1000);
    CGSize labelSize = [str sizeWithFont:label.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    label.frame = CGRectMake(30, 12, labelSize.width, labelSize.height);
    label.text = str;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(label.frame.size.width+label.frame.origin.x+5, 15, 12, 12)];
    img.image = [UIImage imageNamed:@"loudong"];
    [bgView addSubview:img];
    
    UILabel *count = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth-40, 8, 30, 30)];
    count.text = [NSString stringWithFormat:@"%@份",model.taskNum];
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

    cell.backgroundColor = MakeColor(242, 242, 248);
    cell.bgImageView.backgroundColor = [UIColor whiteColor];
    NSString *str = @"";
    
    Model *mo = self.addressArr[indexPath.section];
    
    self.roomArr = mo.apartmentsArr;
    NSMutableDictionary *model = [self.roomArr objectAtIndex:indexPath.row];
    for (NSMutableDictionary *dic in [[self.roomArr objectAtIndex:indexPath.row] objectForKey:@"content"]) {
        str = [str stringByAppendingFormat:@"%@                                              \n",[dic objectForKey:@"content"]];
    }
    cell.addLabel.frame = CGRectMake(45, 0, 200, 50);
    cell.foodLabel.frame = CGRectMake(45, cell.addLabel.frame.size.height+cell.addLabel.frame.origin.y, kUIScreenWidth-30, 40);
    cell.addLabel.font = textFont15;
    cell.addLabel.text = [NSString stringWithFormat:@"%@(%@)",[model objectForKey:@"room"],[model objectForKey:@"taskNum"]];
    cell.foodLabel.font = [UIFont systemFontOfSize:12];
    [cell setIntroductionText:[NSString stringWithFormat:@"%@",str]];
    
    cell.btn.tag = indexPath.row;
    cell.detailBtn.tag = indexPath.row;
    objc_setAssociatedObject(cell.btn, &UITableViewIndexSearch, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(cell.detailBtn, &UITableViewIndexSearch, indexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [cell.btn addTarget:self action:@selector(didClickBtn:) forControlEvents:UIControlEventTouchUpInside];
    [cell.detailBtn addTarget:self action:@selector(didClickDetailBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

//送达
-(void)didClickBtn:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSIndexPath *indexPath = objc_getAssociatedObject(btn, &UITableViewIndexSearch);
    NSLog(@"indexPath.row = %ld,indexPath.section = %ld",(long)indexPath.row,(long)indexPath.section);

    Model *model = [[Model alloc] init];
    model = [self.addressArr objectAtIndex:indexPath.section];
    
    NSMutableArray *roomArray = model.apartmentsArr;
    
    NSMutableDictionary *roomDic = [roomArray objectAtIndex:indexPath.row];
    self.roomNum = [roomDic objectForKey:@"room"];
    
    self.aId = model.aId;
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:self cancelButtonTitle:@"取消确认" otherButtonTitles:@"确认送达", nil];
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

    RoomViewController *roomVC = [[RoomViewController alloc] init];
    roomVC.titleStr = [dic objectForKey:@"room"];
    roomVC.room = [dic objectForKey:@"room"];
    roomVC.aId = model.aId;
    [self.viewController.navigationController pushViewController:roomVC animated:YES];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 1:
        {
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            app.tocken = [UIUtils replaceAdd:app.tocken];
            [params setObject:app.tocken forKey:@"token"];
            [params setObject:self.aId forKey:@"aId"];
            [params setObject:self.roomNum forKey:@"room"];
            
            [RedScarf_API requestWithURL:@"/task/assignedTask/finishRoom" params:params httpMethod:@"PUT" block:^(id result) {
                NSLog(@"result = %@",result);
                if ([[result objectForKey:@"success"] boolValue]) {
                    [self alertView:@"成功送达"];
                    [self didClickLeft];

                }else{
                    [self alertView:[result objectForKey:@"msg"]];
                }
                
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
    NSLog(@"section = %ld",(long)btn.tag);
    
  
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
