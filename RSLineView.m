//
//  RSLineView.m
//  RSUser
//
//  Created by 李江 on 16/4/11.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSLineView.h"

@implementation RSLineView

+(id)lineViewHorizontalWithFrame:(CGRect)frame Color:(UIColor*)lineColor
{
    CGFloat floatsortaPixel =1.0/[UIScreen mainScreen].scale;
    
    RSLineView *lineView = [[RSLineView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, floatsortaPixel)];

    lineView.backgroundColor = lineColor;
    return lineView;
}

+(id)lineViewVerticalWithFrame:(CGRect)frame Color:(UIColor*)lineColor
{
    RSLineView *lineView = [[RSLineView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, 1, frame.size.height)];
    lineView.backgroundColor = lineColor;
    return lineView;
}


+(UIView *)lineViewHorizontal
{
    UIView * lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 1)];
    lineView.backgroundColor = RS_Line_Color;
    return lineView;
}
@end
