//
//  RSProgressView.m
//  RedScarf
//
//  Created by lishipeng on 15/12/10.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSProgressView.h"

@implementation RSProgressView

-(instancetype) init
{
    self = [super init];
    if(self) {
        self.progress = 0;
        [self addSubview:self.frontView];
        [self resize];
    }
    return self;
}

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.progress = 0;
        [self addSubview:self.frontView];
        [self resize];
    }
    return self;
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resize];
}


-(void) resize
{
    self.frontView.frame = CGRectMake(0, 0, self.width*self.progress, self.height);
}


-(UIImageView *) frontView
{
    if(_frontView) {
        return _frontView;
    }
    _frontView = [[UIImageView alloc] init];
    return _frontView;
}

-(void) setProgress:(float)progress
{
    if (progress > 1) {
        progress = 1;
    }
    if(progress < 0) {
        progress = 0;
    }
    _progress = progress;
    [self resize];
}


-(void) setProgress:(float)progress withInterval:(float)interval
{
    [UIView animateWithDuration:interval animations:^{
        self.progress = progress;
    }];
}

-(void) setFrontcolor:(UIColor *)frontcolor backColor:(UIColor *)backColor
{
    self.frontView.backgroundColor = frontcolor;
    self.backgroundColor = backColor;
}

-(void) setFrontImg:(NSString *)frontImg backImg:(NSString *)backImg
{
    UIImage *imgPattern1 = [UIImage imageNamed:frontImg];
    UIColor *colorPattern1 = [[UIColor alloc] initWithPatternImage:imgPattern1];
    [self.frontView setBackgroundColor:colorPattern1];
    //self.frontView.image = [[UIImage imageNamed:frontImg] stretchableImageWithLeftCapWidth:0 topCapHeight:self.height];
    self.image = [UIImage imageNamed:backImg];
}

@end
