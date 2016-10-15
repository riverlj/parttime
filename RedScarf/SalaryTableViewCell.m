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
    self.detailLabel.font = textFont15;
    self.detailLabel.textColor = rs_color_222222;
    [self.contentView addSubview:self.detailLabel];
    
    self.salaryLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.detailLabel.frame.size.height+self.detailLabel.frame.origin.y, 100, 30)];
    self.salaryLabel.font = textFont12;
    self.salaryLabel.textColor = rs_color_7d7d7d;
    [self.contentView addSubview:self.salaryLabel];
    
    self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth-90, 10, 80, 30)];
    self.dateLabel.font = textFont13;
    self.dateLabel.textAlignment = NSTextAlignmentRight;
    self.dateLabel.textColor = rs_color_7d7d7d;
    [self.contentView addSubview:self.dateLabel];
    
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth-10-10, 40, 6, 10)];
    arrow.image = [UIImage imageNamed:@"icon_tx_arrow"];
    [self.contentView addSubview:arrow];
    
    self.changeLabel = [[UILabel alloc] initWithFrame:CGRectMake(arrow.left-95, 40, 90, 30)];
    self.changeLabel.font = textFont15;
    self.changeLabel.textColor = rs_color_f9443e;
    self.changeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.changeLabel];
    arrow.centerY = self.changeLabel.centerY;
    
    return self;
}

@end
