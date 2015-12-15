//
//  ModAddressTableView.m
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "ModAddressTableView.h"
#import "AddressViewVontroller.h"
#import "UIView+ViewController.h"
#import "ModTableViewCell.h"
#import "AppDelegate.h"
#import "UIUtils.h"

@implementation ModAddressTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)viewWillAppear:(BOOL)animated
{
    [self getMessage];

}

-(id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    
    if (self) {
        self.dataArr = [NSMutableArray array];
        [self getMessage];
        self.delegate = self;
        self.dataSource = self;
    }
   
    
    return self;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier1";
    ModTableViewCell *cell = [[ModTableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.backgroundColor = MakeColor(244, 245, 246);

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = self.dataArr[indexPath.row];
    cell.addressLabel.text = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"addr"],[dic objectForKey:@"tId"]];
    [cell.modifyBtn setTitle:@"修改" forState:UIControlStateNormal];
    [cell.modifyBtn addTarget:self action:@selector(didClickModifyBtn) forControlEvents:UIControlEventTouchUpInside];
    cell.modifyBtn.layer.borderColor = colorgreen65.CGColor;
    [cell.modifyBtn setTitleColor:colorgreen65 forState:UIControlStateNormal];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    self.num = indexPath.row;
    NSLog(@"indexPath.row = %ld",(long)self.num);

}

-(void)getMessage
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [RSHttp requestWithURL:@"/task/unstandardAddr" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [self.dataArr removeAllObjects];
        for (NSMutableDictionary *dic in [data objectForKey:@"msg"]) {
            NSLog(@"dic = %@",dic);
            [self.dataArr addObject:dic];
        }
        [self reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

-(void)didClickModifyBtn
{
    AddressViewVontroller *addressVC = [[AddressViewVontroller alloc] init];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic = self.dataArr[self.num];
    addressVC.delegate = self;
    addressVC.tId = [dic objectForKey:@"tId"];
    addressVC.addressStr = [NSString stringWithFormat:@"%@-%@",[dic objectForKey:@"addr"],[dic objectForKey:@"tId"]];
    [self.viewController.navigationController pushViewController:addressVC animated:YES];
}

-(void)returnNameOfTableView:(NSString *)name
{
    NSLog(@"name = %@",name);
    self.nameTableView = name;
}

@end
