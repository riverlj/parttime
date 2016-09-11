//
//  LayOutConfig.m
//  RedScarf
//
//  Created by 李江 on 16/9/9.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "LayOutConfig.h"

@implementation LayOutConfig

+(CGFloat)adapterDeviceHeight:(CGFloat)number {
    if(iPhone6Plus)
    {
        return number*1.5;
    }
    else
    {
        return number;
    }
}@end
