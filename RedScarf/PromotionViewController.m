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
@property (nonatomic, strong)UIImageView *wxPublicImageView;
@property (nonatomic, strong)UILabel *cdkeyLabel;
@property (nonatomic, strong)UIView *bgcontendView;
@property (nonatomic, strong)UIButton *shareBtn;
@property (nonatomic, strong)UIImageView *cdkeybgImageView;

@property (nonatomic, strong)NSString *cdkey;



@end

@implementation PromotionViewController


-(void) viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我要推广";
    self.url = @"/promotionActivity/info";
    
    [self.tableView removeFromSuperview];
    self.view.backgroundColor = MakeColor(0x34, 0x86, 0xfd);


    [self.view addSubview:self.bgcontendView];
    
    [self.bgcontendView addSubview:self.wxPublicImageView];
    [self.bgcontendView addSubview:self.cdkeybgImageView];
    [self.bgcontendView addSubview:self.cdkeyLabel];

    self.bgcontendView.height = self.cdkeyLabel.bottom + 20;
    [self.view addSubview:self.shareBtn];
    
    [self beginHttpRequest];
}

- (UIView *)bgcontendView {
    if (_bgcontendView) {
        return _bgcontendView;
    }
    
    _bgcontendView = [[UIView alloc]init];
    _bgcontendView.frame = CGRectMake(10, 64+15, SCREEN_WIDTH-20, 0);
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
    CGFloat y = self.view.height - self.bgcontendView.bottom;
    _shareBtn.y = self.bgcontendView.bottom + (y - _shareBtn.height)/2;
    
    @weakify(self)
    [[_shareBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self)
        [UMSocialData defaultData].extConfig.wechatSessionData.url = [NSString stringWithFormat:@"http://test2.dev.honglingjinclub.com/web/extension.html?couponcode=%@", self.cdkey];
        [UMSocialData defaultData].extConfig.wechatTimelineData.url = [NSString stringWithFormat:@"http://test2.dev.honglingjinclub.com/web/extension.html?couponcode=%@", self.cdkey];
        [UMSocialData defaultData].extConfig.wechatSessionData.title = @"hi同学，送你一张五折券早餐券";
        [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"hi同学，送你一张五折券早餐券";
        [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeWeb;
         [UMSocialData defaultData].extConfig.wechatSessionData.shareText = @"一直用［爱与红领巾］订早餐，营养好吃不贵邀你来体验，首次预订5折优惠";
        [UMSocialData defaultData].extConfig.wechatTimelineData.shareText=  @"一直用［爱与红领巾］订早餐，营养好吃不贵邀你来体验，首次预订5折优惠";

        XHCustomShareView *shareView = [XHCustomShareView shareViewWithPresentedViewController:self items:@[UMShareToWechatSession,UMShareToWechatTimeline] title:nil image:[UIImage imageNamed:@"wxpublic.png"] urlResource:nil];
        shareView.tag = 9876;
        [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    }];
    
    return _shareBtn;
}


@end
