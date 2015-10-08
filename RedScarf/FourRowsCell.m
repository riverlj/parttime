//
//  FourRowsCell.m
//  RedScarf
//
//  Created by zhangb on 15/8/26.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "FourRowsCell.h"
#import "Header.h"

@implementation FourRowsCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    self.date = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (kUIScreenWidth-30)/4, 40)];
    self.date.font = [UIFont systemFontOfSize:13];
    self.date.textAlignment = NSTextAlignmentCenter;
    self.date.textColor = MakeColor(75, 75, 75);
    [self addSubview:self.date];
    
    self.orderCount = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-30)/4, 0, (kUIScreenWidth-30)/4, 40)];
    self.orderCount.textAlignment = NSTextAlignmentCenter;
    self.orderCount.font = [UIFont systemFontOfSize:13];
    self.orderCount.textColor = MakeColor(75, 75, 75);
    [self addSubview:self.orderCount];
    
    self.reimburseCounts = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-30)/4*2, 0, (kUIScreenWidth-30)/4, 40)];
    self.reimburseCounts.textAlignment = NSTextAlignmentCenter;
    self.reimburseCounts.font = [UIFont systemFontOfSize:13];
    self.reimburseCounts.textColor = MakeColor(75, 75, 75);
    [self addSubview:self.reimburseCounts];
    
    self.totalOrderCounts = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-30)/4*3, 0, (kUIScreenWidth-30)/4, 40)];
    self.totalOrderCounts.textAlignment = NSTextAlignmentCenter;
    self.totalOrderCounts.font = [UIFont systemFontOfSize:13];
    self.totalOrderCounts.textColor = MakeColor(75, 75, 75);
    [self addSubview:self.totalOrderCounts];

    
    
    return self;
}

@end
