//
//  WithdrawCell.m
//  RedScarf
//
//  Created by 李江 on 16/10/14.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "WithdrawCell.h"
#import "WithdrawModel.h"

const static CGFloat k_left = 15;
const static CGFloat k_right = 15;

@implementation WithdrawCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.vLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0)];
        [self.contentView addSubview:self.vLineView];
        self.leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(k_left, 0, 12, 12)];
        [self.contentView addSubview:self.leftIcon];
        self.statuLabel = [[UILabel alloc] init];
        self.statuLabel.font = textFont15;
        self.statuLabel.textColor = rs_color_222222;
        [self.contentView addSubview:self.statuLabel];
        
        self.timeLabel = [[UILabel alloc] init];
        self.timeLabel.font = textFont13;
        self.timeLabel.textColor = rs_color_7d7d7d;
        [self.contentView addSubview:self.timeLabel];
        
        self.rightLabel = [[UILabel alloc] init];
        self.rightLabel.font = textFont12;
        self.rightLabel.textColor = rs_color_7d7d7d;
        [self.contentView addSubview:self.rightLabel];
        
        self.hLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 0)];
        self.hLineView.backgroundColor = RS_Line_Color;
        [self.contentView addSubview:self.hLineView];
    }
    return self;
}

-(void)setModel:(WithdrawViewModel *)model {
    self.leftIcon.image = model.image;
    
    self.statuLabel.text = model.statustr;
    CGSize statuLabelSize = [self.statuLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.statuLabel.frame = CGRectMake(k_left+12+10, 15, statuLabelSize.width, statuLabelSize.height);
    
    self.rightLabel.text = model.rightText;
    CGSize rightLabelSize = [self.rightLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.rightLabel.frame = CGRectMake(SCREEN_WIDTH-k_right-rightLabelSize.width, 15, rightLabelSize.width, rightLabelSize.height);
    if (model.rightLabelColor) {
        self.rightLabel.textColor = model.rightLabelColor;
    }

    self.timeLabel.text = model.timestr;
    CGSize timeLabelSize = [self.timeLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.timeLabel.frame = CGRectMake(k_left+12+10, self.statuLabel.bottom + 10, timeLabelSize.width, timeLabelSize.height);
    
    if (model.status.integerValue == 2|| model.status.integerValue == 3) {
        self.vLineView.backgroundColor = rs_color_f9443e;
    }else {
        self.vLineView.backgroundColor = RS_Line_Color;
    }
    
    if (!model.cellLineHidden) {
        self.hLineView.frame = CGRectMake(self.statuLabel.left, self.timeLabel.bottom+14, SCREEN_WIDTH-self.statuLabel.left, 1/([UIScreen mainScreen].scale));
    }else {
        self.hLineView.hidden = YES;
    }
    
    model.cellHeight = self.timeLabel.bottom + 15;
    
    self.leftIcon.centerY = model.cellHeight/2;
    if (model.lineDown) {
        self.vLineView.frame = CGRectMake(21, 0, 1, 0);
        self.vLineView.y = self.leftIcon.bottom;
    }else{
        self.vLineView.frame = CGRectMake(21, 0, 1, 0);
    }
    self.vLineView.height = self.leftIcon.top;
    
    NSLog(@"");
}

@end
