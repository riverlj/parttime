//
//  RSTipsView.m
//  RedScarf
//
//  Created by lishipeng on 16/1/5.
//  Copyright © 2016年 zhangb. All rights reserved.
//
// 主要用于数据没有加载时的背景

#import "RSTipsView.h"

@implementation RSTipsView
-(instancetype) init
{
    self = [super init];
    if(self) {
        [self setBackgroundColor:color_gray_f3f5f7];
        [self addSubview:self.imgView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setBackgroundColor:color_gray_f3f5f7];
        [self addSubview:self.imgView];
        [self addSubview:self.titleLabel];
    }
    return self;
}

-(void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.imgView.centerX = self.width/2;
    self.titleLabel.centerX = self.width/2;
    self.imgView.top = (self.height - self.imgView.height - 10 - self.titleLabel.height)/2 - kUITabBarHeight;
    self.titleLabel.top = self.imgView.bottom + 10;
}

-(UIImageView *)imgView
{
    if(_imgView) {
        return _imgView;
    }
    _imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
    return _imgView;
}

-(UILabel *)titleLabel
{
    if(_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.imgView.width, 40)];
    _titleLabel.textColor = color155;
    _titleLabel.font = textFont12;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    return _titleLabel;
}

-(void) setTitle:(NSString *)title withImg:(NSString *)img
{
    self.titleLabel.text = title;
    self.imgView.image = [UIImage imageNamed:img];
}

@end
