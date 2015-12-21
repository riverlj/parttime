//
//  RoomTableViewCell.h
//  RedScarf
//
//  Created by zhangb on 15/8/15.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSTableViewCell.h"

@interface RoomTableViewCell : RSTableViewCell

@property(nonatomic,strong)UIButton *roundBtn;
@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *foodLabel;
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UIImageView *groundImage;

-(void)setIntroductionText:(NSMutableAttributedString*)text;
@end
