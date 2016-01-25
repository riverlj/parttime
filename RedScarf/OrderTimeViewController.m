//
//  OrderTimeViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/16.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "OrderTimeViewController.h"

@interface OrderTimeViewController ()

@end

@implementation OrderTimeViewController
{
    UIScrollView *scrollView;
    BOOL isEdited;
    NSMutableArray *dateArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"配送时间";
    scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    isEdited = NO;
    [scrollView setBackgroundColor:MakeColor(0xf5, 0xf5, 0xf9)];
    scrollView.contentSize = CGSizeMake(0, kUIScreenHeigth);
    scrollView.userInteractionEnabled = YES;
    scrollView.scrollEnabled = YES;
    [self.view addSubview:scrollView];
    [self comeBack:nil];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDone)];
    self.navigationItem.rightBarButtonItem = right;
    dateArr = [NSMutableArray array];
    [self getDate];
}

-(void)getDate
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url = @"/user/setting/time";
    if (self.username.length) {
        [params setObject:self.username forKey:@"username"];
        url = @"/team/user/setting/time";
    }
    [self showHUD:@"正在加载"];
    [RSHttp requestWithURL:url params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        CGFloat top = 0;
        for(NSDictionary *dic in [data objectForKey:@"msg"]) {
            NSDate *date =[NSDate dateFromString:[NSString stringWithFormat:@"%@-%@-01", [dic objectForKey:@"year"], [dic objectForKey:@"month"]]];
            RSCalendar *cal = [[RSCalendar alloc] initWithFrame:CGRectMake(18, 0, kUIScreenWidth-36, kUIScreenWidth * 7.8/7)];
            cal.date = date;
            cal.top = top;
            cal.delegate = self;
            top += cal.height;
            [cal setSelectedArr:[[[dic objectForKey:@"days"] componentsSeparatedByString: @","] mutableCopy]];
            [scrollView addSubview:cal];
            scrollView.contentSize = CGSizeMake(0, cal.bottom + 64);
        }
        [self hidHUD];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self showToast:errmsg];
    }];
}

-(void)dateTaped:(NSDate *)date
{
    isEdited = YES;
}

-(void) didClickLeft
{
    //如果编辑过
    if(isEdited) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"您编辑的内容还没有保存，确定退出么？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alertView show];
    } else {
        [super didClickLeft];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [super didClickLeft];
    }
}

-(void)didClickDone
{
    if(!isEdited) {
        [self showToast:@"保存成功"];
        return;
    }
    NSMutableArray *dataArr = [NSMutableArray array];
    for(UIView *view in [scrollView subviews]) {
        if([view isKindOfClass:[RSCalendar class]]) {
            RSCalendar *cal = (RSCalendar *)view;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];
            NSDateComponents *comp = [cal.date YMDComponents];
            [dic setValue:[NSString stringWithFormat:@"%ld", comp.year] forKey:@"year"];
            [dic setValue:[NSString stringWithFormat:@"%ld", comp.month] forKey:@"month"];
            [dic setValue:[cal.selectedArr componentsJoinedByString:@","] forKey:@"days"];
            [dataArr addObject:dic];
        }
    }
    
    NSString *urlString;
    id params = dataArr;
    if (self.username.length) {
        urlString = [NSString stringWithFormat:@"/team/user/setting/time"];
        params = [NSDictionary dictionaryWithObjectsAndKeys:self.username, @"username", dataArr, @"ustList", nil];
    }else{
        urlString = [NSString stringWithFormat:@"/user/setting/time"];
    }
    [self showHUD:@"修改中"];
    [RSHttp requestWithURL:urlString params:params httpMethod:@"PUTJSON" success:^(NSDictionary *data) {
        [self hidHUD];
        [self showToast:@"保存成功"];
        isEdited = NO;
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self showToast:errmsg];
    }];
}
@end
