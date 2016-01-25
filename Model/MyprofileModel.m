//
//  MyprofileModel.m
//  RedScarf
//
//  Created by lishipeng on 15/12/12.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "MyprofileModel.h"

@implementation MyprofileModel
-(instancetype) initWithTitle:(NSString *)title icon:(NSString *)imgName vcName:(NSString *)vcName
{
    self = [self init];
    self.title = title;
    self.imgName = imgName;
    self.vcName = vcName;
    self.cellHeight = 48;
    self.subtitle = [[NSAttributedString alloc]initWithString:@""];
    return self;
}

@end
