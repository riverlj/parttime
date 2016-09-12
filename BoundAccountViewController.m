//
//  BoundAccountViewController.m
//  RedScarf
//
//  Created by 李江 on 16/8/22.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "BoundAccountViewController.h"
#import "MyprofileModel.h"

@interface BoundAccountViewController ()
{
    NSInteger statusid;
}
@property (nonatomic, strong)MyprofileModel *profileModel;

@end

@implementation BoundAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"账号绑定";
    
    self.profileModel = [[MyprofileModel alloc] init];
    self.models = [NSMutableArray array];
    self.profileModel.title = @"微信绑定";
    self.profileModel.cellHeight = 49;
//    self.profileModel.subtitle = [[NSAttributedString alloc]initWithString:@"未绑定"];
    [self.profileModel setSelectAction:@selector(bandWeiXin) target:self];
    [self.models addObject:self.profileModel];
    
//    [self.tableView reloadData];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
    
    UIImage *image = [UIImage imageNamed:@"tip_money"];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, image.size.width, image.size.height)];
    imageView.image = image;
    imageView.x = (SCREEN_WIDTH - image.size.width)/2 + 20;
    NSLog(@"%@-\n--%@", imageView, image);
    [contentView addSubview:imageView];

    
    UILabel *tip1 = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom+30, SCREEN_WIDTH, 30)];
    tip1.font = BoldFont(15);
    tip1.textAlignment = NSTextAlignmentCenter;
    tip1.text = @"微信账号绑定后，每次提现";
    tip1.textColor = RS_THRME_COLOR;
    [contentView addSubview:tip1];
    
    UILabel *tip2 = [[UILabel alloc] initWithFrame:CGRectMake(0, tip1.bottom+10, SCREEN_WIDTH, 30)];
    tip2.font = Font(15);
    tip2.text = @"工资将会直接提现到你的微信零钱中";
    tip2.textAlignment = NSTextAlignmentCenter;
    tip2.textColor = [NSString colorFromHexString:@"7d7d7d"];
    [contentView addSubview:tip2];
    
    contentView.height = tip2.bottom;
    self.tableView.tableFooterView = contentView;
    self.tableView.height += 49;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWexinBoundingStatus) name:@"UPDATE_WEIXIN_BOUNDING_STATUE" object:nil];
    
}

- (void)updateWexinBoundingStatus {
    __weak BoundAccountViewController *selfB = self;
    [RSHttp requestWithURL:@"/user/wxinfo" params:nil httpMethod:@"GET" success:^(NSDictionary *data) {
        NSDictionary *dic = [data valueForKey:@"body"];
        NSInteger status = [[dic valueForKey:@"status"] integerValue];
        statusid = status;
        if (status == 0) {
            selfB.profileModel.subtitle = [[NSAttributedString alloc]initWithString:@"未绑定"];
        }else {
            selfB.profileModel.subtitle = [[NSAttributedString alloc]initWithString:@"已绑定"];
        }
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView] showToast:errmsg];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self updateWexinBoundingStatus];
}

- (void)bandWeiXin {
    //构造SendAuthReq结构体
    if (statusid == 1) {
        [[RSToastView shareRSToastView] showToast:@"已绑定"];
    }else{
        SendAuthReq* req =[[SendAuthReq alloc ] init];
        req.scope = @"snsapi_userinfo" ;
        req.state = @"123" ;
        [WXApi sendReq:req];
    }
}

@end
