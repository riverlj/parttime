//
//  RSUIView.m
//  RedScarf
//
//  Created by lishipeng on 16/1/13.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSUIView.h"

@implementation RSUIView

+(UIView *) roundRectViewWithFrame:(CGRect)frame
{
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.cornerRadius = 5;
    view.layer.borderColor = color_gray_e8e8e8.CGColor;
    view.layer.borderWidth = 0.5;
    view.clipsToBounds = YES;
    return view;
}

+(UIImageView *) lineWithFrame:(CGRect)frame
{
    UIImageView *line = [[UIImageView alloc] initWithFrame:frame];
    line.backgroundColor = color_gray_e8e8e8;
    return line;
}
@end
