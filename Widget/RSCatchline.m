//
//  RSCatchline.m
//  RedScarf
//
//  Created by lishipeng on 16/1/14.
//  Copyright © 2016年 zhangb. All rights reserved.
//
// 标语

#import "RSCatchline.h"
@implementation RSCatchline

-(void)layoutSubviews
{
    self.clipsToBounds = YES;
    CGFloat x = self.label.height * self.width/2/sqrt(self.width*self.width + self.height *self.height);
    CGFloat y = self.label.height * self.height/2/sqrt(self.width*self.width + self.height *self.height);
    self.label.centerX = self.width/2 + x;
    self.label.centerY = self.height/2 - y;
    self.label.transform = CGAffineTransformMakeRotation(atan(self.height/self.width));
}

-(UILabel *) label
{
    if(_label) {
        return _label;
    }
    _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width*2, 15)];
    [_label setBackgroundColor:color_red_e54545];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.font = textFont10;
    _label.textColor = [UIColor whiteColor];
    [self addSubview:_label];
    return _label;
}

-(void) setTitle:(NSString *)title withBgColor:(UIColor *)color
{
    self.label.text = title;
    self.label.backgroundColor = color;
}

@end
