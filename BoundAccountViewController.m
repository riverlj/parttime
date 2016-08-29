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
    self.tableView.tableFooterView = [UIView new];
    
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
