//
//  HomePageViewController.m
//  RedScarf
//
//  Created by zhangb on 15/10/9.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "HomePageViewController.h"
#import "TaskViewController.h"
#import "FinishViewController.h"
#import "TeamMembersViewController.h"
#import "CheckTaskViewController.h"
#import "PromotionViewController.h"
#import "TeamViewController.h"
#import "AllocatingTaskVC.h"
#import "GoPeiSongViewController.h"
#import "SeparateViewController.h"
#import "OrderRangeViewController.h"
#import "OrderTimeViewController.h"
#import "BannerViewController.h"
#import "MsgViewController.h"
#import "SDCycleScrollView.h"
#import "LoginViewController.h"

@interface HomePageViewController ()<SDCycleScrollViewDelegate>

@end

@implementation HomePageViewController
{
    NSMutableArray *titleArray,*idArray;
    NSMutableArray *imageArray;
    NSArray *array;
    UIPageControl *control;
    UIScrollView *scroll;
    
    NSArray *taskArray,*separateArray;
    NSMutableArray *imagesURLStrings,*imageUrlArray;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[self.view viewWithTag:3434] removeFromSuperview];
}

-(void)viewDidAppear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewStartWithName:@"shouye"];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[BaiduMobStat defaultStat] pageviewEndWithName:@"shouye"];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self getHomeMsg];
    [self getTaskMessage];
    [self getSeparateMessage];
    [self getStatus];
    [super viewWillAppear:animated];
}

-(void)getTaskMessage
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [self showHUD:@"正在加载"];
    [RSHttp requestWithURL:@"/task/waitAssignTask" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [self hidHUD];
        taskArray = [data objectForKey:@"msg"];
        [[self.view viewWithTag:3434] removeFromSuperview];
        [self initHomeView];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

-(void)getSeparateMessage
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [RSHttp requestWithURL:@"/task/assignedTask/content" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        if ([[data objectForKey:@"success"] boolValue]) {
            separateArray = [data objectForKey:@"msg"];
            [[self.view viewWithTag:3434] removeFromSuperview];
            [self initHomeView];
        }
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = color234;
    titleArray = [NSMutableArray array];
    idArray = [NSMutableArray array];
    imageArray = [NSMutableArray array];
    imagesURLStrings = [NSMutableArray array];
    imageUrlArray = [NSMutableArray array];

    array = [NSArray arrayWithObjects:@"banner1", nil];
    self.title = @"首页";
    

    [self getBannerView];
}

-(void)getStatus
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
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

-(void)getHomeMsg
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        [dic setObject:token forKey:@"token"];
    }
    [RSHttp requestWithURL:@"/resource/appMenu" params:dic httpMethod:@"GET" success:^(NSDictionary *data) {
        if ([[data objectForKey:@"success"] boolValue]) {
            [imageArray removeAllObjects];
            [titleArray removeAllObjects];
            for (NSDictionary *dic in [data objectForKey:@"msg"]) {
                [titleArray addObject:[dic objectForKey:@"menu"]];
                [idArray addObject:[dic objectForKey:@"id"]];
            }
            
            for (int i = 0; i < idArray.count; i++) {
                if ([idArray[i] intValue] == 801) {
                    [imageArray addObject:@"rwfp@2x"];
                }
                if ([idArray[i] intValue] == 802) {
                    [imageArray addObject:@"fencan@2x"];
                }
                if ([idArray[i] intValue] == 803) {
                    [imageArray addObject:@"lishi@2x"];
                }
                if ([idArray[i] intValue] == 804) {
                    [imageArray addObject:@"guanlichengyuan@2x"];
                }
                if ([idArray[i] intValue] == 805) {
                    [imageArray addObject:@"ckpaiban@2x"];
                }
                if ([idArray[i] intValue] == 806) {
                    [imageArray addObject:@"tuiguang2x"];
                }
                if ([idArray[i] intValue] == 807) {
                    [imageArray addObject:@"ceoqun"];
                }
                if ([idArray[i] intValue] == 808) {
                    [imageArray addObject:@"helpcenter"];
                }
                if ([idArray[i] intValue] == 809) {
                    [imageArray addObject:@"qidai2x"];
                }
                
                if ([idArray[i] intValue] == 901) {
                    [imageArray addObject:@"fencan@2x"];
                }
                if ([idArray[i] intValue] == 902) {
                    [imageArray addObject:@"lishi@2x"];
                }
                if ([idArray[i] intValue] == 903) {
                    [imageArray addObject:@"shijian2x"];
                }
                if ([idArray[i] intValue] == 904) {
                    [imageArray addObject:@"fanwei2x"];
                }
                if ([idArray[i] intValue] == 907) {
                    [imageArray addObject:@"tuiguang2x"];
                }
                if ([idArray[i] intValue] == 906) {
                    [imageArray addObject:@"helpcenter"];
                }
                if ([idArray[i] intValue] == 908) {
                    [imageArray addObject:@"rwfp@2x"];
                }
            }
            [[self.view viewWithTag:3434] removeFromSuperview];
            [self initHomeView];
        }else{
            if ([[data objectForKey:@"msg"] isEqualToString:@"无效的Token"]) {
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults removeObjectForKey:@"token"];
                [defaults synchronize];
                
                AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
                LoginViewController *loginVC = [[LoginViewController alloc] init];
                [app setRoorViewController:loginVC];
            }
        }
    } failure:^(NSInteger code, NSString *errmsg) {
        
    }];
}

-(void)didClickMsg:(id)sender
{
    MsgViewController *msgVC = [[MsgViewController alloc] init];
    [self.navigationController pushViewController:msgVC animated:YES];
}



-(void)banner:(id)sender
{
    BannerViewController *bannerVC = [[BannerViewController alloc] init];
    [self.navigationController pushViewController:bannerVC animated:YES];
}




-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    BannerViewController *bannerVC = [[BannerViewController alloc] init];
    bannerVC.title = @"详情";
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.tocken = [UIUtils replaceAdd:app.tocken];
    bannerVC.url = [NSString stringWithFormat:@"%@?token=%@",imageUrlArray[index],app.tocken];
    [self.navigationController pushViewController:bannerVC animated:YES];
}

-(void)getBannerView
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
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

-(void)initBannerView
{
    
    //网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 62, kUIScreenWidth, 160) imageURLStringsGroup:nil]; // 模拟网络延时情景
    if (kUIScreenWidth == 320) {
        cycleScrollView2.frame = CGRectMake(0, 57, kUIScreenWidth, 135);
    }else{
        cycleScrollView2.frame = CGRectMake(0, 57, kUIScreenWidth, 157);
    }
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView2.delegate = self;
    if (imagesURLStrings.count == 1) {
        cycleScrollView2.infiniteLoop = NO;
        cycleScrollView2.autoScroll = NO;
    }else {
        cycleScrollView2.infiniteLoop = YES;
        cycleScrollView2.autoScroll = YES;
    }
    //    cycleScrollView2.titlesGroup = titles;
    cycleScrollView2.dotColor = [UIColor whiteColor]; // 自定义分页控件小圆标颜色
    cycleScrollView2.placeholderImage = [UIImage imageNamed:@"placeholder"];
    [self.view addSubview:cycleScrollView2];
    
    //             --- 模拟加载延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        cycleScrollView2.imageURLStringsGroup = imagesURLStrings;
    });
}

-(void)initHomeView
{
    int wight;
    int imageY;
    if (kUIScreenWidth == 320) {
        wight = 100;
        imageY = 25;
    }else{
        wight = 120;
        imageY = 35;
    }

    UIScrollView *listScroll;
    if (kUIScreenWidth == 320) {
        listScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 192, kUIScreenWidth, kUIScreenHeigth-224)];
    }else{
        listScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 214, kUIScreenWidth, kUIScreenHeigth-214)];
    }
    
    listScroll.userInteractionEnabled = YES;
    listScroll.contentSize = CGSizeMake(0, (kUIScreenHeigth-214)*1.2);
    listScroll.tag = 3434;
    [self.view addSubview:listScroll];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    int iNum,jNum;
    if ([[defaults objectForKey:@"count"] rangeOfString:@"8"].location != NSNotFound) {
        iNum = titleArray.count/3;
        if (titleArray.count%3 != 0) {
            iNum += 1;
        }
        jNum = 3;
    }else{
        
        iNum = titleArray.count/3;
        if (titleArray.count%3 != 0) {
            iNum += 1;
        }
        jNum = 3;
    }
    
        for (int i = 0; i < iNum; i++) {
            for (int j = 0; j < jNum; j++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                btn.backgroundColor = [UIColor whiteColor];
                btn.frame = CGRectMake(kUIScreenWidth/3*j, i*wight, kUIScreenWidth/3+1, wight+1);
                btn.layer.borderColor = MakeColor(220, 220, 220).CGColor;
                btn.layer.borderWidth = 0.5;
                btn.tag = 100*i+j;
                [listScroll addSubview:btn];
                
                UIImageView *image;
                if (kUIScreenWidth == 320) {
                    image = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width/2-15, imageY, 30, 30)];
                    //调整企鹅的大小
                    if ([[defaults objectForKey:@"count"] rangeOfString:@"8"].location != NSNotFound) {
                        if (i == 2 && j == 0) {
                            image = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width/2-15, imageY+4, 30, 30)];
                        }
                    }
                    
                }else{
                    image = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width/2-20, imageY, 40, 40)];
                    if ([[defaults objectForKey:@"count"] rangeOfString:@"8"].location != NSNotFound) {
                        if (i == 2 && j == 0) {
                            image = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width/2-15, imageY+4, 30, 30)];
                        }
                    }
                }
                
                [btn addSubview:image];
                
                UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/3*j, btn.frame.size.height+btn.frame.origin.y-45, kUIScreenWidth/3, 35)];
                if (i == 0) {
                    titleLabel.text = titleArray[j];
                    image.image = [UIImage imageNamed:imageArray[j]];
                }
                if (i == 1) {
                    titleLabel.text = titleArray[j+3];
                    image.image = [UIImage imageNamed:imageArray[j+3]];
                }
                if (i == 2) {
                    titleLabel.text = titleArray[j+6];
                    image.image = [UIImage imageNamed:imageArray[j+6]];
                }
                titleLabel.font = textFont14;
                titleLabel.textColor = color155;
                titleLabel.textAlignment = NSTextAlignmentCenter;
                [listScroll addSubview:titleLabel];
                
                //小红点
                UIImageView *circleView = [[UIImageView alloc] initWithFrame:CGRectMake(btn.frame.size.width+btn.frame.origin.x-32, btn.frame.origin.y+20, 12, 12)];
                circleView.layer.cornerRadius = 6;
                circleView.layer.masksToBounds = YES;
                circleView.backgroundColor = [UIColor redColor];

                if ([[defaults objectForKey:@"count"] rangeOfString:@"8"].location != NSNotFound) {
                    
                    [btn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
                    if (i == 0 && j == 0) {
                        if (taskArray.count) {
                            [btn addSubview:circleView];
                        }
                    }
                    if (i == 0 && j == 1) {
                        if (separateArray.count) {
                            circleView.frame = CGRectMake(btn.frame.size.width+btn.frame.origin.x-32, btn.frame.origin.y+20, 12, 12);
                            [listScroll addSubview:circleView];
                        }
                    }
                    
                }else{
                    [btn addTarget:self action:@selector(didClickPartTime:) forControlEvents:UIControlEventTouchUpInside];
                    if (i == 0 && j == 0) {
                        if (separateArray.count) {
                            [btn addSubview:circleView];
                        }
                    }
                }
                
            }
            
        }
}

-(void)didClickPartTime:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"btn.tag = %ld",(long)btn.tag);
    if (btn.tag == 0) {
        
    }
    switch (btn.tag) {
        case 0:
        {
            SeparateViewController *separateVC = [[SeparateViewController alloc] init];
            separateVC.partTime = @"partTime";
            [self.navigationController pushViewController:separateVC animated:YES];
        }
            break;
        case 1:
        {
            FinishViewController *finishVC = [[FinishViewController alloc] init];
            [self.navigationController pushViewController:finishVC animated:YES];
        }
            break;
        case 2:
        {
            OrderTimeViewController *orderTimeVC = [[OrderTimeViewController alloc] init];
//            NSMutableDictionary *userInfo = [infoDic objectForKey:@"userInfo"];
//            orderTimeVC.username = [userInfo objectForKey:@"username"];
            [self.navigationController pushViewController:orderTimeVC animated:YES];
            
        }
            break;
        case 100:
        {
            OrderRangeViewController *orderRangeVC = [[OrderRangeViewController alloc] init];
            [self.navigationController pushViewController:orderRangeVC animated:YES];
        }
            break;
        case 101:
        {
            //[self alertView:@"即将上线"];
            PromotionViewController *promotionVC = [[PromotionViewController alloc] init];
            [self.navigationController pushViewController:promotionVC animated:YES];
        }
            break;
        case 102:
        {
            BannerViewController *bannerVC = [[BannerViewController alloc] init];
            bannerVC.title = @"帮助中心";
            [self.navigationController pushViewController:bannerVC animated:YES];
        }
            break;
            
        default:
            break;
    }

}

-(void)didClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSLog(@"btn.tag = %ld",(long)btn.tag);
    if (btn.tag == 0) {
        
    }
    switch (btn.tag) {
        case 0:
        {
            TaskViewController *taskVC = [[TaskViewController alloc] init];
            [self.navigationController pushViewController:taskVC animated:YES];
        }
            break;
        case 1:
        {
            SeparateViewController *separateVC = [[SeparateViewController alloc] init];
            separateVC.partTime = @"ceo";
            [self.navigationController pushViewController:separateVC animated:YES];
        }
            break;
        case 2:
        {
            
            FinishViewController *finishVC = [[FinishViewController alloc] init];
            [self.navigationController pushViewController:finishVC animated:YES];

        }
            break;
        case 100:
        {
            TeamMembersViewController *teamMemberVC = [[TeamMembersViewController alloc] init];
            [self.navigationController pushViewController:teamMemberVC animated:YES];
        }
            break;
        case 101:
        {
            CheckTaskViewController *checkTaskVC = [[CheckTaskViewController alloc] init];
            [self.navigationController pushViewController:checkTaskVC animated:YES];
        }
            break;
        case 102:
        {
            //[self alertView:@"即将上线"];
            PromotionViewController *promotionVC = [[PromotionViewController alloc] init];
            [self.navigationController pushViewController:promotionVC animated:YES];
        }
            break;
        case 200:
        {
            BannerViewController *bannerVC = [[BannerViewController alloc] init];
            bannerVC.title = @"CEO群";
            [self.navigationController pushViewController:bannerVC animated:YES];

        }
            break;
        case 201:
        {
            BannerViewController *bannerVC = [[BannerViewController alloc] init];
            bannerVC.title = @"帮助中心";
            [self.navigationController pushViewController:bannerVC animated:YES];
            
        }
            break;
        default:
            break;
    }
    
}
@end
