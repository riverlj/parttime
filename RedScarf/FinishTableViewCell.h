//
//  FinishTableViewCell.h
//  RedScarf
//
//  Created by zhangb on 15/8/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSTableViewCell.h"

@interface FinishTableViewCell : RSTableViewCell

@property (nonatomic, strong) UIView *bgView;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *chuLiLabel;
@property(nonatomic,strong)UILabel *buyerLabel;
@property(nonatomic,strong)UILabel *telLabel;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UILabel *foodLabel;
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic, strong) UIImageView *statusImage;

-(void)setIntroductionText:(NSString*)text;

@end
