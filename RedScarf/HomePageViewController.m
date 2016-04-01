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
#import "MenuModel.h"

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
    [self getRedDot];
    [super viewWillAppear:animated];
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


- (void)getRedDot{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [RSHttp requestWithURL:@"/resource/redDot" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        
        UIImage *image;

        NSDictionary *messageDic = [[data objectForKey:@"body"] objectForKey:@"message"];
        NSInteger redDoc = [[messageDic objectForKey:@"redDot"] integerValue];
        if (redDoc > 0) {
            //消息提示
            image = [[UIImage imageNamed:@"lingdang@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }else {
            image = [[UIImage imageNamed:@"konglingdang@2x"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        }
        UIBarButtonItem *r = [[UIBarButtonItem alloc] initWithImage:image landscapeImagePhone:[UIImage imageNamed:@"lingdang"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickMsg:)];
        self.navigationItem.rightBarButtonItem = r;
        
        NSArray *commonArr = [[data objectForKey:@"body"] objectForKey:@"common"];
        for (NSDictionary *dic in commonArr) {
            NSString *url = [dic objectForKey:@"url"];
            RSMenuButton *btn = [self getMenuBtnByUrl:url];
            NSInteger redDot = [[dic objectForKey:@"redDot"]integerValue];
            NSLog(@"redDot = %zd", redDot);
            if (redDot > 0) {
                [btn setRedPot:YES];
            }else{
                [btn setRedPot:NO];
            }
        }

    } failure:^(NSInteger code, NSString *errmsg) {
    }];

}

-(void)getUserinfo
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [RSHttp requestWithURL:@"/user/info" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSDictionary *infoDic = [data objectForKey:@"body"];
        NSError *error = nil;
        RSAccountModel *model = [MTLJSONAdapter modelOfClass:[RSAccountModel class] fromJSONDictionary:infoDic error:&error];
        [model save];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

-(RSMenuButton*) getMenuBtnByUrl:(NSString *) url
{
    for(UIView *subView in self.listScrollView.subviews) {
        if([subView isKindOfClass:[RSMenuButton class]]) {
            RSMenuButton *btn = (RSMenuButton *)subView;
            if([btn.menuModel.url isEqualToString:[NSString stringWithFormat:@"rsparttime://%@",url]]) {
                NSLog(@"%@", btn.menuModel.url);
                return btn;
            }
        }
    }
    return nil;
}

-(void)getHomeMsg
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:@"0" forKey:@"parentId"];
    [RSHttp requestWithURL:@"/resource/appMenu/child" params:dic httpMethod:@"GET" success:^(NSDictionary *data) {
        [self initHomeView:[data objectForKey:@"body"]];
        [self getRedDot];
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
    if (bannerVC.urlString.length == 0) {
        return;
    }
    [self.navigationController pushViewController:bannerVC animated:YES];
}

-(void)getBannerView
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"1" forKey:@"pageNum"];
    [params setObject:@"3" forKey:@"pageSize"];
    [RSHttp requestWithURL:@"/user/banners" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        for (NSMutableDictionary *dic in [[data objectForKey:@"body"] objectForKey:@"list"]) {
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
        
        NSError *error = nil;
        MenuModel *menuModel = [MTLJSONAdapter modelOfClass:[MenuModel class] fromJSONDictionary:dict error:&error];
        button.menuModel = menuModel;
        button.redPot = NO;
                            
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
    if(btn.menuModel.url && ![btn.menuModel.url isEqualToString:@""]) {
        if([btn.menuModel.url hasPrefix:@"http://"]) {
            BannerViewController *bannerVC = [[BannerViewController alloc] init];
            MenuModel *menuModel = btn.menuModel;
            bannerVC.title = menuModel.title;
            bannerVC.urlString = menuModel.url;
            [self.navigationController pushViewController:bannerVC animated:YES];
        } else if([btn.menuModel.url hasPrefix:@"rsparttime://"]){
            UIViewController *vc = [[NSClassFromString(btn.menuModel.vcName) alloc] init];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
}
@end
