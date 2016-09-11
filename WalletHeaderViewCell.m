//
//  WalletHeaderViewCell.m
//  RedScarf
//
//  Created by 李江 on 16/9/10.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "WalletHeaderViewCell.h"
#import "RSTwoTitleModel.h"

@implementation WalletHeaderViewCell
{
    RSTwoTitleModel *_twoTitleModel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RS_THRME_COLOR;
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    return self;
}

-(void)setModel:(RSTwoTitleModel *)model
{
    [super setModel:model];
//    model.cellHeight = 128;
    _twoTitleModel = model;
    [self customStyle];
}

- (void)customStyle {
    self.oneLabelLabel.font = Font(14);
    self.oneLabelLabel.textColor = [UIColor whiteColor];
    self.oneLabelLabel.textAlignment = NSTextAlignmentCenter;
    CGSize onetitleSize = [self.oneLabelLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.oneLabelLabel.frame = CGRectMake(0, 64+37, SCREEN_WIDTH, onetitleSize.height);
    
    self.twotitleLabel.font = BoldFont(40);
    self.twotitleLabel.textColor = [UIColor whiteColor];
    self.twotitleLabel.textAlignment = NSTextAlignmentCenter;
    CGSize twotitleSize = [self.twotitleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.twotitleLabel.frame = CGRectMake(0, self.oneLabelLabel.bottom+10, SCREEN_WIDTH, twotitleSize.height);
}
@end
