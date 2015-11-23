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
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
    [self getHomeMsg];
    [self getTaskMessage];
    [self getSeparateMessage];
}

-(void)getTaskMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [self showHUD:@"正在加载"];
    [RedScarf_API requestWithURL:@"/task/waitAssignTask" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            [self hidHUD];
            taskArray = [result objectForKey:@"msg"];
            [[self.view viewWithTag:3434] removeFromSuperview];
            [self initHomeView];
        }
    }];
}

-(void)getSeparateMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    
    [RedScarf_API requestWithURL:@"/task/assignedTask/content" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            separateArray = [result objectForKey:@"msg"];
            [[self.view viewWithTag:3434] removeFromSuperview];
            [self initHomeView];
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = color234;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    titleArray = [NSMutableArray array];
    idArray = [NSMutableArray array];
    imageArray = [NSMutableArray array];
//    if ([[defaults objectForKey:@"count"] rangeOfString:@"8"].location != NSNotFound) {
//        titleArray = [NSMutableArray arrayWithObjects:@"任务分配",@"分餐点",@"历史任务",@"管理成员",@"查看排班",@"我的推广",@"CEO群",@"帮助中心",@"敬请期待", nil];
//        imageArray = [NSArray arrayWithObjects:@"rwfp@2x",@"fencan@2x",@"lishi@2x",@"guanlichengyuan@2x",@"ckpaiban@2x",@"tuiguang2x",@"ceoqun",@"helpcenter",@"qidai2x", nil];
//    }else{
//        titleArray = [NSMutableArray arrayWithObjects:@"分餐点",@"历史任务",@"配送时间",@"配送范围",@"我的推广",@"帮助中心",@"敬请期待",@"",@"", nil];
//        imageArray = [NSArray arrayWithObjects:@"fencan@2x",@"lishi@2x",@"shijian2x",@"fanwei2x",@"tuiguang2x",@"helpcenter", nil];
//    }

    array = [NSArray arrayWithObjects:@"banner1", nil];
    self.title = @"首页";
    
    UIButton *button = (UIButton *)[self.tabBarController.view viewWithTag:11011];
    [button removeFromSuperview];
    //圆形
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-25, kUIScreenHeigth-80, 60, 60)];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitle:@"qusongcan" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor clearColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pressChange:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.cornerRadius = 30;
    btn.tag = 11011;
    [btn setBackgroundImage:[UIImage imageNamed:@"去送餐2x"] forState:UIControlStateNormal];
    btn.layer.masksToBounds = YES;
    [self.tabBarController.view addSubview:btn];
//    [self initBannerView];
//    UIImage *image = [[UIImage imageNamed:@"lingdang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIBarButtonItem *r = [[UIBarButtonItem alloc] initWithImage:image landscapeImagePhone:[UIImage imageNamed:@"lingdang"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickMsg:)];
//    self.navigationItem.rightBarButtonItem = r;
    
}

-(void)getHomeMsg
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    if (token.length) {
        [dic setObject:token forKey:@"token"];
    }
    [RedScarf_API requestWithURL:@"/resource/appMenu" params:dic httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",[result objectForKey:@"msg"]);
        [imageArray removeAllObjects];
        [titleArray removeAllObjects];
        for (NSDictionary *dic in [result objectForKey:@"msg"]) {
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
    }];
}

-(void)didClickMsg:(id)sender
{
    MsgViewController *msgVC = [[MsgViewController alloc] init];
    [self.navigationController pushViewController:msgVC animated:YES];
}

-(void)pressChange:(id)sender
{
    GoPeiSongViewController *goVC = [[GoPeiSongViewController alloc] init];
    [[BaiduMobStat defaultStat] logEvent:@"qusongcan" eventLabel:@"button"];
    [self.navigationController pushViewController:goVC animated:YES];
}

-(void)banner:(id)sender
{
    BannerViewController *bannerVC = [[BannerViewController alloc] init];
    bannerVC.title = @"详情";
    [self.navigationController pushViewController:bannerVC animated:YES];
}

-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    
}

-(void)initBannerView
{
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];
    
    //网络加载 --- 创建带标题的图片轮播器
    SDCycleScrollView *cycleScrollView2 = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 62, kUIScreenWidth, 160) imageURLStringsGroup:nil]; // 模拟网络延时情景
    if (kUIScreenWidth == 320) {
        cycleScrollView2.frame = CGRectMake(0, 57, kUIScreenWidth, 135);
    }else{
        cycleScrollView2.frame = CGRectMake(0, 57, kUIScreenWidth, 157);
    }
    cycleScrollView2.pageControlAliment = SDCycleScrollViewPageContolAlimentRight;
    cycleScrollView2.delegate = self;
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
   
    if (kUIScreenWidth == 320) {
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 128)];
    }else{
        scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, 150)];
    }
    
    scroll.scrollEnabled = YES;
    scroll.userInteractionEnabled = YES;
    scroll.contentSize = CGSizeMake(kUIScreenWidth*array.count, 100);
//    self.edgesForExtendedLayout=UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    //循环  一张图片先不放
    control = [[UIPageControl alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-50, 110, 100, 30)];
    [self.view addSubview:control];
    control.backgroundColor = [UIColor redColor];
    control.currentPage=0;
    control.numberOfPages = array.count;
//    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timer) userInfo:nil repeats:YES];

//    scroll.backgroundColor = [UIColor greenColor];
    [self.view addSubview:scroll];
    for (int i = 0; i<[array count]; i++) {
        CGRect frame;
        frame.origin.x = scroll.frame.size.width*i;
        frame.origin.y = 0;
        frame.size = scroll.frame.size;
        
        UIImageView *view = [[UIImageView alloc] initWithFrame:frame];
        view.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(banner:)];
        tap.numberOfTapsRequired = 1;
        [view addGestureRecognizer:tap];
        view.image = [UIImage imageNamed:array[i]];
        [scroll addSubview:view];
        //        controll.currentPage = i;
        //        [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
        
    }
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
