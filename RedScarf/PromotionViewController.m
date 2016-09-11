//
//  PromotionViewController.m
//  RedScarf
//
//  Created by zhangb on 15/8/25.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "PromotionViewController.h"
#import "Header.h"
#import "UMSocialQQHandler.h"
#import "UMSocialWechatHandler.h"
#import "XHCustomShareView.h"


@interface PromotionViewController()
{
    UIScrollView *_contentScrollView;
}
@property (nonatomic, strong)UIImageView *wxPublicImageView;
@property (nonatomic, strong)UILabel *cdkeyLabel;
@property (nonatomic, strong)UIView *bgcontendView;
@property (nonatomic, strong)UIButton *shareBtn;
@property (nonatomic, strong)UIImageView *cdkeybgImageView;

@property (nonatomic, strong)NSString *cdkey;

@property (nonatomic, strong)NSString *sharetitle;
@property (nonatomic, strong)NSString *desc;
@property (nonatomic, strong)NSString *link;
@property (nonatomic, strong)NSString *imgurl;

@property (nonatomic, strong)UILabel *explainLabel;


@end

@implementation PromotionViewController


-(void) viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我要推广";
    self.url = @"/promotionActivity/info";
    self.view.autoresizesSubviews = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.tableView removeFromSuperview];
    
    _contentScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    [_contentScrollView addSubview:self.bgcontendView];
    _contentScrollView.backgroundColor = MakeColor(0x34, 0x86, 0xfd);
    [self.view addSubview:_contentScrollView];
    
    [self.bgcontendView addSubview:self.wxPublicImageView];
    [self.bgcontendView addSubview:self.cdkeybgImageView];
    [self.bgcontendView addSubview:self.cdkeyLabel];

    self.bgcontendView.height = self.cdkeyLabel.bottom + 20;
    [_contentScrollView addSubview:self.shareBtn];
    
    self.explainLabel = [[UILabel alloc]init];
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"用户通过扫二维码，关注爱与领巾公众平台并成功完成首次下单，您可获得1元推广奖励费用。详细步骤如下：\n1、告知用户扫描红领巾二维码，关注爱与红领巾平台（若已经关注，则直接可以进入第2步）\n2、告知用户选择“订早啦”－“我的”－“我的优惠券”，输入推广码即可兑换一张5折优惠券。\n3、告知用户回到“首页”即可使用5折优惠券下单。\n4、根据首次下单用户的数量核算兼职费用。\n5、推广费会与工资一并结算，结算方式为线上提\n\n你还可以把优惠信息分享给微信好友，好友通过你的链接完成首次下单，你也可以得到1元推广费哦～"];
    
    self.explainLabel.numberOfLines = 0;
    self.explainLabel.frame =CGRectMake(10, _shareBtn.bottom + 20, SCREEN_WIDTH-20, 0);
    
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.lineSpacing = 3;//行距
    [text addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    self.explainLabel.attributedText = text;
    CGSize explainSize = [self.explainLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, 10000)];
    self.explainLabel.font = textFont16;
    self.explainLabel.textColor = [UIColor whiteColor];
    self.explainLabel.height = explainSize.height;
    [_contentScrollView addSubview:self.explainLabel];
    
    _contentScrollView.contentSize = CGSizeMake(SCREEN_WIDTH, self.explainLabel.bottom);
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:@"pttmsnew" forKey:@"campaign"];
    
    __weak PromotionViewController *selfB = self;
    [RSHttp mobileRequestWithURL:@"/mobile/index/campaignconfig" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSDictionary *dic = [data valueForKey:@"body"];
        selfB.sharetitle = [dic valueForKey:@"title"];
        selfB.desc = [dic valueForKey:@"desc"];
        selfB.link = [dic valueForKey:@"link"];
        selfB.imgurl = [dic valueForKey:@"imgurl"];
    } failure:^(NSInteger code, NSString *errmsg) {
        [[RSToastView shareRSToastView]showToast:errmsg];
    }];
    [self beginHttpRequest];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (UIView *)bgcontendView {
    if (_bgcontendView) {
        return _bgcontendView;
    }
    
    _bgcontendView = [[UIView alloc]init];
    _bgcontendView.frame = CGRectMake(10, 15, SCREEN_WIDTH-20, 0);
    _bgcontendView.backgroundColor = [UIColor whiteColor];
    _bgcontendView.layer.cornerRadius = 4;
    _bgcontendView.layer.masksToBounds = YES;
    return _bgcontendView;
}

-(void) afterHttpSuccess:(NSDictionary *)data
{
    NSDictionary *body = [data valueForKey:@"body"];
    self.cdkey = [body valueForKey:@"cdkey"];
    
    self.cdkeyLabel.text = [NSString stringWithFormat:@"推广码：%@", self.cdkey];
}

- (UIImageView *)wxPublicImageView {
    
    if (_wxPublicImageView) {
        return _wxPublicImageView;
    }
    
    _wxPublicImageView = [[UIImageView alloc] init];
    
    _wxPublicImageView.frame = CGRectMake(18, 18, (self.bgcontendView.width - 36), (self.bgcontendView.width - 36));
    _wxPublicImageView.image = [UIImage imageNamed:@"wxpublic"];
    _wxPublicImageView.contentMode = UIViewContentModeScaleAspectFill;
    return _wxPublicImageView;
}


-(UILabel *)cdkeyLabel {
    if (_cdkeyLabel) {
        return _cdkeyLabel;
    }
    
    _cdkeyLabel = [[UILabel alloc]init];
    
    _cdkeyLabel.frame = CGRectMake((self.bgcontendView.width-245*(SCREEN_WIDTH/320))/2, self.wxPublicImageView.bottom + 20, 245*(SCREEN_WIDTH/320), 41);

    _cdkeyLabel.textAlignment = NSTextAlignmentCenter;
    _cdkeyLabel.font = Font(18);
    _cdkeyLabel.textColor = RS_THRME_COLOR;
    return _cdkeyLabel;
}


-(UIImageView *)cdkeybgImageView {
    if (_cdkeybgImageView) {
        return _cdkeybgImageView;
    }
    
    _cdkeybgImageView = [[UIImageView alloc]init];
    _cdkeybgImageView.frame =  CGRectMake((self.bgcontendView.width-245*(SCREEN_WIDTH/320))/2, self.wxPublicImageView.bottom + 20, 245*(SCREEN_WIDTH/320), 41);
    _cdkeybgImageView.image = [UIImage imageNamed:@"cdkeybgview"];
    return _cdkeybgImageView;
}

-(UIButton *)shareBtn {
    if (_shareBtn) {
        return _shareBtn;
    }
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = CGRectMake(10, 0, SCREEN_WIDTH-20, 50);
    
    [_shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [_shareBtn setTitle:@"分享" forState:UIControlStateHighlighted];
    [_shareBtn setTitleColor:RS_THRME_COLOR forState:UIControlStateHighlighted];
    [_shareBtn setTitleColor:RS_THRME_COLOR forState:UIControlStateNormal];
    _shareBtn.titleLabel.font = Font(18);
    
    [_shareBtn setBackgroundColor:[UIColor whiteColor]];
    _shareBtn.layer.cornerRadius = 2;
    _shareBtn.layer.masksToBounds = YES;
    _shareBtn.y = self.bgcontendView.bottom + 20;
    
    @weakify(self)
    [[_shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"%@?couponcode=%@",self.link, self.cdkey];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"%@?couponcode=%@",self.link, self.cdkey];
        [UMSocialData defaultData].extConfig.wechatSessionData.title = self.sharetitle;
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = self.sharetitle;
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
         [UMSocialData defaultData].extConfig.wechatSessionData.shareText = self.desc;
        [UMSocialData defaultData].extConfig.wechatTimelineData.shareText=  self.desc;

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.imgurl]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                XHCustomShareView *shareView = [XHCustomShareView shareViewWithPresentedViewController:self items:@[UMShareToWechatSession,UMShareToWechatTimeline] title:nil image:image urlResource:nil];
                shareView.tag = 9876;
                [[UIApplication sharedApplication].keyWindow addSubview:shareView];
            });
        });
        
        
    }];
    
    return _shareBtn;
}


@end
