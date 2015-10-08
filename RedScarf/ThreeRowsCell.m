//
//  ThreeRowsCell.m
//  RedScarf
//
//  Created by zhangb on 15/8/26.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "ThreeRowsCell.h"
#import "Header.h"

@implementation ThreeRowsCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    
    self.date = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, (kUIScreenWidth-30)/3, 40)];
    self.date.font = [UIFont systemFontOfSize:13];
    self.date.textAlignment = NSTextAlignmentCenter;
    self.date.userInteractionEnabled = NO;
    self.date.textColor = MakeColor(75, 75, 75);
    [self addSubview:self.date];
    
    self.funsCount = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-30)/3, 0, (kUIScreenWidth-30)/3, 40)];
    self.funsCount.textAlignment = NSTextAlignmentCenter;
    self.funsCount.font = [UIFont systemFontOfSize:13];
    self.funsCount.userInteractionEnabled = NO;
    self.funsCount.textColor = MakeColor(75, 75, 75);
    [self addSubview:self.funsCount];
    
    self.totalCount = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-30)/3*2, 0, (kUIScreenWidth-30)/3, 40)];
    self.totalCount.textAlignment = NSTextAlignmentCenter;
    self.totalCount.font = [UIFont systemFontOfSize:13];
    self.totalCount.textColor = MakeColor(75, 75, 75);
    [self addSubview:self.totalCount];

    
    return self;
}
@end
