//
//  SalaryTableViewCell.m
//  RedScarf
//
//  Created by zhangb on 15/10/31.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "SalaryTableViewCell.h"
#import "Header.h"

@implementation SalaryTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 30)];
    self.detailLabel.font = textFont16;
    [self.contentView addSubview:self.detailLabel];
    
    self.salaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.detailLabel.frame.size.height+self.detailLabel.frame.origin.y, 100, 30)];
    self.salaryLabel.font = textFont14;
    self.salaryLabel.textColor = color155;
    [self.contentView addSubview:self.salaryLabel];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth-90, 10, 80, 30)];
    self.dateLabel.font = textFont14;
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.dateLabel.textColor = color155;
    [self.contentView addSubview:self.dateLabel];
    
    self.changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth-80, 40, 70, 30)];
    self.changeLabel.font = textFont14;
    self.changeLabel.textColor = [UIColor redColor];
    self.changeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.changeLabel];
    
    return self;
}

@end
