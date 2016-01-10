//
//  DistributionCell.h
//  RedScarf
//
//  Created by zhangb on 15/8/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSTableViewCell.h"

@interface DistributionCell : RSTableViewCell

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UIImageView *groundImage;
@property(nonatomic,strong)UILabel *rightLabel;
@property(nonatomic, strong)NSMutableArray *labelArr;

@end
