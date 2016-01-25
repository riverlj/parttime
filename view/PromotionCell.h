//
//  PromotionCell.h
//  RedScarf
//
//  Created by lishipeng on 16/1/20.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSTableViewCell.h"

@interface PromotionCell : RSTableViewCell
@property(nonatomic, strong) UILabel *rankLabel;
@property(nonatomic, strong) UIImageView *rankView;

@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *mobileLabel;
@property(nonatomic, strong) UILabel *orderCntLabel;
@property(nonatomic, strong) UILabel *promotionLabel;
@end
