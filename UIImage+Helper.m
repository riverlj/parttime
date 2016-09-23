//
//  UIImage+Helper.m
//  RedScarf
//
//  Created by 李江 on 16/9/20.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "UIImage+Helper.h"

@implementation UIImage (Helper)
+ (UIImage *)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
