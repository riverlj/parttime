//
//  SalaryTableViewCell.h
//  RedScarf
//
//  Created by zhangb on 15/10/31.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SalaryTableViewCell : UITableViewCell

@property(nonatomic,strong) UILabel *detailLabel;
@property(nonatomic,strong) UILabel *salaryLabel;
@property(nonatomic,strong) UILabel *changeLabel;
@property(nonatomic,strong) UILabel *dateLabel;

@end
