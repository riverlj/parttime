//
//  RSHomeButton.m
//  RedScarf
//
//  Created by lishipeng on 15/12/14.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSMenuButton.h"

@implementation RSMenuButton
-(instancetype) init
{
    self = [super init];
    if(self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.label];
        [self addSubview:self.image];
        [self.layer setBorderWidth:0.5]; //边框宽度
        UIColor *color = color_gray_e8e8e8;
        [self.layer setBorderColor:color.CGColor]; //边框颜色
    }
    return self;
}

-(UILabel *)label
{
    if(_label) {
        return _label;
    }
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, 0, self.width, 14);
    _label.font = textFont14;
    _label.textColor = color155;
    _label.textAlignment = NSTextAlignmentCenter;
    return _label;
}

-(UIImageView *)image
{
    if(_image) {
        return _image;
    }
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    return _image;
}

-(UIImageView *)circleView
{
    if(_circleView) {
        return _circleView;
    }
    _circleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    _circleView.layer.cornerRadius = 6;
    _circleView.layer.masksToBounds = YES;
    _circleView.backgroundColor = colorrede5;
    return _circleView;
}

-(void) layoutSubviews
{
    self.image.width = self.width/3;
    self.image.height = self.height/3;
    self.image.left = (self.width - self.image.width)/2;
    self.image.top = (self.height - self.image.height - self.label.height - self.height/10)/2;
    self.label.top = self.image.bottom + self.height/10;
    self.label.width = self.width;
    self.circleView.right = self.width - 18;
    self.circleView.top = 18;

}

-(void) setMenuid:(NSInteger)menuid
{
    _menuid = menuid;
    NSDictionary *urlDict = @{
        @"801":@"TasksViewController",
        @"802":@"SeparateViewController",
        @"803":@"FinishViewController",
        @"804":@"TeamMembersViewController",
        @"805":@"CheckTaskViewController",
        @"806":@"PromotionViewController",
        @"807":@"http://jianzhi.honglingjinclub.com/html/banner/20151113/ceo.html",
        @"808":@"http://jianzhi.honglingjinclub.com/html/banner/20151026/QandA.html",
        @"809":@"",
        @"901":@"SeparateViewController",
        @"902":@"FinishViewController",
        @"903":@"OrderTimeViewController",
        @"904":@"OrderRangeViewController",
        @"907":@"PromotionViewController",
        @"906":@"http://jianzhi.honglingjinclub.com/html/banner/20151026/QandA.html",
        
    };
    NSString *idStr = [NSString stringWithFormat:@"%ld", _menuid];
    if([urlDict valueForKey:idStr]) {
        _url = [urlDict valueForKey:idStr];
    } else {
        _url = nil;
    }
}

-(void)setTitle:(NSString *)title image:(NSString *)image redPot:(BOOL)redPot
{
    self.label.text = title;
    if([image hasPrefix:@"http://"]) {
        [self.image sd_setImageWithURL:[NSURL URLWithString:image]];
    } else {
        self.image.image = [UIImage imageNamed:image];
    }
    self.redPot = redPot;
}

-(void) setRedPot:(BOOL)redPot
{
    _redPot = redPot;
    if(_redPot) {
        if(![self.circleView superview]) {
            [self addSubview:self.circleView];
        }
    } else {
        if([self.circleView superview]) {
            [self.circleView removeFromSuperview];
        }
    }
}

- (void)setUrl:(NSString *)url{
    _url = url;
    NSDictionary *urlDict = @{
                          @"rsparttime://task/taskManager" : @"TasksViewController",
                          @"rsparttime://task/finishedTask" : @"FinishViewController",
                          @"rsparttime://task/ceoDisPos" : @"SeparateViewController",
                          @"rsparttime://team/schedule" : @"CheckTaskViewController",
                          @"rsparttime://team/member" : @"TeamMembersViewController",
                          @"rsparttime://user/promotion" : @"PromotionViewController",
                          @"rsparttime://task/userDisPos" : @"SeparateViewController",
                          @"rsparttime://user/settingTime" :@"OrderTimeViewController",
                          @"rsparttime://user/settingAddr" : @"OrderRangeViewController"
                        };
    if([urlDict valueForKey:url]) {
        _vcUrl = [urlDict valueForKey:url];
    } else {
        _vcUrl = nil;
    }
}
@end
