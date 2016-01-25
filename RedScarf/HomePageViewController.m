//
//  HomePageViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/9.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "HomePageViewController.h"
#import "FinishViewController.h"
#import "TeamMembersViewController.h"
#import "CheckTaskViewController.h"
#import "PromotionViewController.h"
#import "TeamViewController.h"
#import "GoPeiSongViewController.h"
#import "SeparateViewController.h"
#import "OrderRangeViewController.h"
#import "OrderTimeViewController.h"
#import "BannerViewController.h"
#import "MsgViewController.h"
#import "LoginViewController.h"
#import "RSMenuButton.h"
#import "RSAccountModel.h"

@interface HomePageViewController ()<SDCycleScrollViewDelegate>

@end

@implementation HomePageViewController
{
    NSMutableArray *imagesURLStrings,*imageUrlArray;
}

-(void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"shouye"];
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"shouye"];
    [super viewDidDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getTaskMessage];
    [self getSeparateMessage];
    [self getStatus];
    [super viewWillAppear:animated];
}

-(void)getTaskMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [RSHttp requestWithURL:@"/task/waitAssignTask" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSArray *taskArray = [data objectForKey:@"msg"];
        RSMenuButton *btn = [self getMenuBtnById:801];
        if(btn) {
            if(taskArray.count > 0) {
                [btn setRedPot:YES];
            } else {
                [btn setRedPot:NO];
            }
        }
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

-(void)getSeparateMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [RSHttp requestWithURL:@"/task/assignedTask/content" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSArray *separateArray = [data objectForKey:@"msg"];
        RSMenuButton *btn = [self getMenuBtnById:802];
        if(btn) {
            if(separateArray.count > 0) {
                [btn setRedPot:YES];
            } else {
                [btn setRedPot:NO];
            }
        }
        btn = [self getMenuBtnById:901];
        if(btn) {
            if(separateArray.count > 0) {
                [btn setRedPot:YES];
            } else {
                [btn setRedPot:NO];
            }
        }
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.listScrollView addSubview:self.cycleScrollView];
    [self.view addSubview: self.listScrollView];

    imagesURLStrings = [NSMutableArray array];
    imageUrlArray = [NSMutableArray array];

    self.title = @"首页";
    [self getHomeMsg];
    [self getBannerView];
    [self getUserinfo];
}

-(void)getUserinfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [RSHttp requestWithURL:@"/user/info" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSDictionary *infoDic = [data objectForKey:@"msg"];
        NSError *error = nil;
        RSAccountModel *model = [MTLJSONAdapter modelOfClass:[RSAccountModel class] fromJSONDictionary:infoDic error:&error];
        [model save];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}


-(void)getStatus
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:[NSNumber numberWithInt:1] forKey:@"pageNum"];
    [params setObject:[NSNumber numberWithInt:10] forKey:@"pageSize"];
    
    [RSHttp requestWithURL:@"/user/message" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        UIImage *image;
        if ([[NSString stringWithFormat:@"%@",[[data objectForKey:@"body"] objectForKey:@"unReadTotal"]] isEqualToString:@"0"]) {
            //消息提示
            image = [[UIImage imageNamed:@"konglingdang@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }else
        {
            image = [[UIImage imageNamed:@"lingdang@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        UIBarButtonItem *r = [[UIBarButtonItem alloc] initWithImage:image landscapeImagePhone:[UIImage imageNamed:@"lingdang"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickMsg:)];
        self.navigationItem.rightBarButtonItem = r;
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

-(RSMenuButton*) getMenuBtnById:(NSInteger) menuid
{
    for(UIView *subView in self.listScrollView.subviews) {
        if([subView isKindOfClass:[RSMenuButton class]]) {
            RSMenuButton *btn = (RSMenuButton *)subView;
            if(btn.menuid == menuid) {
                return btn;
            }
        }
    }
    return nil;
}

-(void)getHomeMsg
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [RSHttp requestWithURL:@"/resource/appMenu" params:dic httpMethod:@"GET" success:^(NSDictionary *data) {
        [self initHomeView:[data objectForKey:@"msg"]];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self showToast:errmsg];
    }];
}

-(void)didClickMsg:(id)sender
{
    MsgViewController *msgVC = [[MsgViewController alloc] init];
    [self.navigationController pushViewController:msgVC animated:YES];
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BannerViewController *bannerVC = [[BannerViewController alloc] init];
    bannerVC.title = @"详情";
    bannerVC.urlString = [imageUrlArray objectAtIndex:index];
    [self.navigationController pushViewController:bannerVC animated:YES];
}

-(void)getBannerView
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"pageNum"];
    [params setObject:@"3" forKey:@"pageSize"];
    [RSHttp requestWithURL:@"/user/banners" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        for (NSMutableDictionary *dic in [[data objectForKey:@"msg"] objectForKey:@"list"]) {
            [imagesURLStrings addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"url"]]];
            [imageUrlArray addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"linkUrl"]]];
        }
        [self initBannerView];
    } failure:^(NSInteger code, NSString *errmsg) {
        
    }];
}

-(SDCycleScrollView *)cycleScrollView
{
    if(_cycleScrollView) {
        return _cycleScrollView;
    }
    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame: CGRectMake(0, 0, kUIScreenWidth, kUIScreenWidth*300/750) imageURLStringsGroup:nil];
    _cycleScrollView.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    _cycleScrollView.delegate = self;
    //_cycleScrollView.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    _cycleScrollView.backgroundColor = color_gray_f3f5f7;
    return _cycleScrollView;
}

-(void)initBannerView
{
    if(imagesURLStrings.count == 0) {
        self.cycleScrollView.infiniteLoop = NO;
        self.cycleScrollView.autoScroll = NO;
    } else if (imagesURLStrings.count == 1) {
        self.cycleScrollView.infiniteLoop = NO;
        self.cycleScrollView.autoScroll = NO;
     }else {
         self.cycleScrollView.infiniteLoop = YES;
         self.cycleScrollView.autoScroll = YES;
     }
     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         self.cycleScrollView.imageURLStringsGroup = imagesURLStrings;
     });
}

-(UIScrollView *) listScrollView
{
    if(_listScrollView) {
        return _listScrollView;
    }
    _listScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _listScrollView.userInteractionEnabled = YES;
    _listScrollView.contentSize = CGSizeMake(0, kUIScreenHeigth*1.2);
    [self.view addSubview:_listScrollView];
    return _listScrollView;
}

-(void)initHomeView:(NSDictionary *)items
{
    //一行的个数
    NSInteger columns = 3;
    CGFloat weight = kUIScreenWidth/columns;
    //NSInteger imageY = 25;
    NSInteger total = 0;
    CGFloat maxHeight = 0;
    for(NSDictionary *dict in items) {
        NSInteger column = total%columns;
        NSInteger line = total/columns;
        RSMenuButton *button = [[RSMenuButton alloc] init];
        button.frame = CGRectMake(weight*column, self.cycleScrollView.height + line * weight, weight, weight);
        [button setTitle:[dict valueForKey:@"menu"] image:[dict valueForKey:@"pic-79-79"] redPot:NO];
        button.menuid = [[dict valueForKey:@"id"] intValue];
        [self.listScrollView addSubview:button];
        [button addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
        if(button.bottom > maxHeight) {
            maxHeight = button.bottom;
        }
        total ++;
    }
    self.listScrollView.contentSize = CGSizeMake(0, fmax(kUIScreenHeigth, maxHeight));
}

-(void)didClick:(id)sender
{
    if(![sender isKindOfClass:[RSMenuButton class]]) {
        return ;
    }
    RSMenuButton *btn = (RSMenuButton *)sender;
    if(btn.url && ![btn.url isEqualToString:@""]) {
        if([btn.url hasPrefix:@"http://"]) {
            BannerViewController *bannerVC = [[BannerViewController alloc] init];
            bannerVC.title = btn.label.text;
            bannerVC.urlString = btn.url;
            [self.navigationController pushViewController:bannerVC animated:YES];
        } else {
            UIViewController *vc = [[NSClassFromString(btn.url) alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
@end
