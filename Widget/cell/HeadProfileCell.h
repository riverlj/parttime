//
//  HeadProfileCell.h
//  RedScarf
//
//  Created by lishipeng on 15/12/12.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSTableViewCell.h"
#import "RSHeadView.h"

@interface HeadProfileCell : RSTableViewCell

@property(nonatomic, strong) RSHeadView *headView;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *telLabel;
@property(nonatomic, strong) UILabel *titleLabel;


-(void) reload;
@end
