//
//  PromotionViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/25.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "PromotionViewController.h"
#import "Header.h"
#import "OrderCountsViewController.h"
#import "FunsViewController.h"
#import "TotalMoneyViewController.h"
#import "ListCell.h"
#import "RecommendViewController.h"
#import "MyFunsViewController.h"
#import "RuleOfActive.h"
#import "RSUIView.h"
#import "PromotionModel.h"


@implementation PromotionViewController {
    NSString *code;
    RSTitleView *fansView;
    RSTitleView *totalMoneyView;
    RSTitleView *totalOrderView;
}

-(void) viewDidLoad
{
    [super viewDidLoad];
    self.url = @"/promotionActivity/index";
    self.useFooterRefresh = YES;
    self.title = @"推广活动";
    [self comeBack:nil];
    [self.tips setTitle:@"" withImg:nil];
    self.tableView.tableHeaderView = [self headView];
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSelectionStyleNone;
    [self beginHttpRequest];
}

-(void) afterHttpSuccess:(NSDictionary *)data
{
    NSDictionary *dic = [data objectForKey:@"body"];
    code = [dic valueForKey:@"cdkey"];
    fansView.numLabel.text = [dic valueForKey:@"fansTotal"];
    totalMoneyView.numLabel.text = [dic valueForKey:@"promoteAccount"];
    totalOrderView.numLabel.text = [dic valueForKey:@"orderTotal"];
    NSInteger i = [self.models count];
    for(NSDictionary *temp in [dic objectForKey:@"otherUsers"]) {
        i++;
        PromotionModel *model = [MTLJSONAdapter modelOfClass:[PromotionModel class] fromJSONDictionary:temp error:nil];
        model.rank = i;
        [self.models addObject:model];
    }
}

-(void) afterProcessHttpData:(NSInteger)before afterCount:(NSInteger)after
{
    if(before == 0 && after != 0) {
        PromotionModel *head = [[PromotionModel alloc]init];
        head.name = @"姓名";
        head.mobile = @"电话";
        head.orderCnt = @"昨日下单";
        head.promotionCnt = @"推广总数";
        [self.models insertObject:head atIndex:0];
        head.isSelectable = NO;
        [self.tableView reloadData];
    }
    [super afterProcessHttpData:before afterCount:after];
}

-(UIView *) headView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 200)];
    fansView = [[RSTitleView alloc] initWithFrame:CGRectMake(0, 0, view.width/3, 73)];
    fansView.titleLabel.text = @"推荐粉丝总数";
    fansView.vcName = @"FunsViewController";
    [fansView addTapAction:@selector(didclickTitle:) target:self];
    [view addSubview: fansView];
    totalMoneyView = [[RSTitleView alloc] initWithFrame:CGRectMake(fansView.right, fansView.top, fansView.width, fansView.height)];
    totalMoneyView.titleLabel.text = @"推广费总额";
    totalMoneyView.vcName = @"TotalMoneyViewController";
    [totalMoneyView addTapAction:@selector(didclickTitle:) target:self];
    [totalMoneyView addSubview:[RSUIView lineWithFrame:CGRectMake(0, 15, 0.8, totalMoneyView.height-30)]];
    [view addSubview:totalMoneyView];
    totalOrderView = [[RSTitleView alloc] initWithFrame:CGRectMake(totalMoneyView.right, totalMoneyView.top, totalMoneyView.width, totalMoneyView.height)];
    totalOrderView.titleLabel.text = @"推广下单数";
    [totalOrderView addTapAction:@selector(didclickTitle:) target:self];
    totalOrderView.vcName = @"OrderCountsViewController";
    [totalOrderView addSubview:[RSUIView lineWithFrame:CGRectMake(0, 15, 0.8, totalOrderView.height-30)]];
    [view addSubview:totalOrderView];
    
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(18, fansView.bottom + 11, (kUIScreenWidth - 36 - 20)/3, 79)];
    btn.backgroundColor = MakeColor(0xff, 0x6f, 0x5c);
    btn.layer.cornerRadius = 8;
    btn.clipsToBounds = YES;
    [btn setTitle:@"我要推荐" forState:UIControlStateNormal];
    btn.titleLabel.font = textFont13;
    btn.imageView.width = 30;
    btn.imageView.height = 30;
    btn.imageEdgeInsets = UIEdgeInsetsMake(-11.5, (btn.width-btn.imageView.width)/2, 11.5, (btn.width-btn.imageView.width)/2);
    btn.titleEdgeInsets = UIEdgeInsetsMake(20, -30, -20, 0);
    [btn setImage:[UIImage imageNamed:@"icon_good"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(didClickRecommend) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(btn.right + 10, btn.top, btn.width, btn.height)];
    [btn1 setBackgroundColor:MakeColor(0x58, 0xb1, 0xed)];
    btn1.layer.cornerRadius = 8;
    btn1.clipsToBounds = YES;
    [btn1 setTitle:@"我的粉丝" forState:UIControlStateNormal];
    btn1.titleLabel.font = textFont13;
    btn1.imageView.width = 30;
    btn1.imageView.height = 30;
    [btn1 addTarget:self action:@selector(didClickMyFuns) forControlEvents:UIControlEventTouchUpInside];
    btn1.imageEdgeInsets = UIEdgeInsetsMake(-11.5, (btn.width-btn.imageView.width)/2, 11.5, (btn.width-btn.imageView.width)/2);
    btn1.titleEdgeInsets = UIEdgeInsetsMake(20, -30, -20, 0);
    [btn1 setImage:[UIImage imageNamed:@"icon_fans"] forState:UIControlStateNormal];
    [view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] initWithFrame:CGRectMake(btn1.right + 10, btn.top, btn.width, btn.height)];
    [btn2 setBackgroundColor:MakeColor(0x62, 0xc4, 0x7b)];
    btn2.layer.cornerRadius = 8;
    btn2.clipsToBounds = YES;
    [btn2 setTitle:@"活动规则" forState:UIControlStateNormal];
    btn2.titleLabel.font = textFont13;
    btn2.imageView.width = 30;
    btn2.imageView.height = 30;
    [btn2 addTarget:self action:@selector(didClickRuleOfActive) forControlEvents:UIControlEventTouchUpInside];
    btn2.imageEdgeInsets = UIEdgeInsetsMake(-11.5, (btn.width-btn.imageView.width)/2, 11.5, (btn.width-btn.imageView.width)/2);
    btn2.titleEdgeInsets = UIEdgeInsetsMake(20, -30, -20, 0);
    [btn2 setImage:[UIImage imageNamed:@"icon_star"] forState:UIControlStateNormal];
    [view addSubview:btn2];
    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-50, btn2.bottom+ 33, 100, 14)];
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = MakeColor(87, 87, 87);
    label.text = @"推广大比拼";
    label.font = [UIFont systemFontOfSize:14];
    [label sizeToFit];
    label.centerX = kUIScreenWidth /2+5;
    [view addSubview:label];
    
    UIImageView *blueview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 5, 10)];
    blueview.layer.cornerRadius = 2.5;
    blueview.clipsToBounds = YES;
    blueview.backgroundColor = btn1.backgroundColor;
    blueview.right = label.left - 5;
    blueview.centerY = label.centerY;
    [view addSubview:blueview];
    
    view.height = blueview.bottom + 14;
    return view;
}

-(void)didclickTitle:(id)sender
{
    UITapGestureRecognizer *reg = (UITapGestureRecognizer *)sender;
    if([reg.view isKindOfClass:[RSTitleView class]]) {
        RSTitleView *titleView = (RSTitleView *) reg.view;
        UIViewController *vc = [[NSClassFromString(titleView.vcName) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(void)didClickRecommend
{
    RecommendViewController *recommendVC = [[RecommendViewController alloc] init];
    recommendVC.code = code;
    [self.navigationController pushViewController:recommendVC animated:YES];
}

-(void)didClickMyFuns
{
    MyFunsViewController *myFunsVC = [[MyFunsViewController alloc] init];
    [self.navigationController pushViewController:myFunsVC animated:YES];
}

-(void)didClickRuleOfActive
{
    RuleOfActive *ruleOfActiveVC = [[RuleOfActive alloc] init];
    ruleOfActiveVC.title = @"活动规则";
    [self.navigationController pushViewController:ruleOfActiveVC animated:YES];
}
@end


@implementation RSTitleView
-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.backgroundColor = [UIColor whiteColor];
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 22, self.width, 15)];
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.textColor = color_black_333333;
        self.numLabel.font = textFont15;
        [self addSubview:self.numLabel];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.numLabel.bottom + 11, self.width, 12)];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.textColor = color_black_666666;
        self.titleLabel.font = textFont12;
        [self addSubview:self.titleLabel];
        UIImageView *line = [RSUIView lineWithFrame:CGRectMake(0, self.height - 0.5, self.width, 0.5)];
        [self addSubview:line];
    }
    return self;
}

@end
