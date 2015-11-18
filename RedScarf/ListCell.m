//
//  ListCell.m
//  RedScarf
//
//  Created by zhangb on 15/8/26.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "ListCell.h"
#import "Header.h"

@implementation ListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.photoView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 12, 12)];
    [self addSubview:self.photoView];
    
    self.sort = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 12, 12)];
    self.sort.backgroundColor = MakeColor(135, 135, 135);
    self.sort.layer.masksToBounds = YES;
    self.sort.layer.cornerRadius = 6;
    self.sort.textAlignment = NSTextAlignmentCenter;
    self.sort.font = [UIFont systemFontOfSize:10];
    self.sort.textColor = [UIColor whiteColor];
    [self addSubview:self.sort];
    
    self.name = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, (kUIScreenWidth-30)/4-27, 40)];
    self.name.font = [UIFont systemFontOfSize:13];
//    self.name.backgroundColor = [UIColor redColor];
    self.name.textColor = MakeColor(75, 75, 75);
    [self addSubview:self.name];
    
    self.telLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-30)/4, 0, (kUIScreenWidth-30)/4+30, 40)];
    self.telLabel.font = [UIFont systemFontOfSize:13];
    self.telLabel.textColor = MakeColor(75, 75, 75);
    [self addSubview:self.telLabel];
    
    self.order = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-30)/4*2, 0, (kUIScreenWidth-30)/4, 40)];
    self.order.textAlignment = NSTextAlignmentCenter;
    self.order.font = [UIFont systemFontOfSize:13];
    self.order.textColor = MakeColor(75, 75, 75);
    [self addSubview:self.order];
    
    self.totalCount = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-30)/4*3, 0, (kUIScreenWidth-30)/4, 40)];
    self.totalCount.textAlignment = NSTextAlignmentCenter;
    self.totalCount.font = [UIFont systemFontOfSize:13];
    self.totalCount.textColor = MakeColor(75, 75, 75);
    [self addSubview:self.totalCount];
    
    
    return self;
}

@end
