//
//  WalletViewCell.m
//  RedScarf
//
//  Created by 李江 on 16/9/10.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "WalletViewCell.h"
#import "RSTwoTitleModel.h"
@implementation WalletViewCell
{
    RSTwoTitleModel *_twoTitleModel;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
    }
    return self;
}

-(void)setModel:(RSTwoTitleModel *)model
{
    [super setModel:model];
    model.cellHeight = 48;
    _twoTitleModel = model;

    [self customStyle];
}

- (void)customStyle {
    self.oneLabelLabel.font = Font(15);
    self.oneLabelLabel.textColor = [NSString colorFromHexString:@"222222"];
    self.oneLabelLabel.textAlignment = NSTextAlignmentCenter;
    CGSize onetitleSize = [self.oneLabelLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.oneLabelLabel.frame = CGRectMake(18, 0, onetitleSize.width, _twoTitleModel.cellHeight);
    
    self.twotitleLabel.font = Font(14);
    self.twotitleLabel.textColor = [NSString colorFromHexString:@"515151"];
    self.twotitleLabel.textAlignment = NSTextAlignmentCenter;
    CGSize twotitleSize = [self.twotitleLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.twotitleLabel.frame = CGRectMake(SCREEN_WIDTH-twotitleSize.width-28, 0, twotitleSize.width, _twoTitleModel.cellHeight);

}

@end
