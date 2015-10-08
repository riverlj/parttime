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
    self.addressArr = [NSMutableArray array];

    [self getMessage];
    
}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        self.addressArr = [NSMutableArray array];
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

                [self.addressArr addObject:model];
            }
            [self reloadData];

        }
        [self hidHUD];
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.addressArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier2";
    ModTableViewCell *cell = [[ModTableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }

    Model *model = [[Model alloc] init];
    model = [self.addressArr objectAtIndex:indexPath.row];
    
    NSString *str = [NSString stringWithFormat:@"%@",model.apartmentName];
    
    CGSize size = CGSizeMake(kUIScreenWidth-100, 1000);
    CGSize labelSize = [str sizeWithFont:cell.addressLabel.font constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    cell.addressLabel.frame = CGRectMake(10, 12, labelSize.width, labelSize.height);
    cell.addressLabel.text = str;
    
    UILabel *taskNum = [[UILabel alloc] initWithFrame:CGRectMake(cell.addressLabel.frame.size.width+cell.addressLabel.frame.origin.x+10, 14, 25, 15)];
    taskNum.font = [UIFont systemFontOfSize:13];
    taskNum.text = [NSString stringWithFormat:@"(%@)",model.taskNum];
    taskNum.textColor = [UIColor redColor];
    [cell.contentView addSubview:taskNum];
    
    cell.modifyBtn.hidden = YES;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    Model *model = [[Model alloc] init];
    model = [self.addressArr objectAtIndex:indexPath.row];
    DistributionVC *disVC = [[DistributionVC alloc] init];
    disVC.titleStr = [NSString stringWithFormat:@"%@  (%@)",model.apartmentName,model.taskNum];
    disVC.delegate = self;
    disVC.aId = model.aId;
    [self.viewController.navigationController pushViewController:disVC animated:YES];
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
