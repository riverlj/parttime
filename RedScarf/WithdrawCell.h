//
//  WithdrawCell.h
//  RedScarf
//
//  Created by 李江 on 16/10/14.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSTableViewCell.h"

@interface WithdrawCell : RSTableViewCell
@property (nonatomic, strong)UIImageView *leftIcon;
@property (nonatomic, strong)UIView *hLineView; //水平
@property (nonatomic, strong)UIView *vLineView; //竖直
@property (nonatomic, strong)UILabel *statuLabel;
@property (nonatomic, strong)UILabel *rightLabel;
@property (nonatomic, strong)UILabel *timeLabel; //时间



@end
