//
//  NormalLogCell.m
//  RedScarf
//
//  Created by lishipeng on 15/12/10.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "NormalLogCell.h"
#import "LevelLogModel.h"

@implementation NormalLogCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.subLabel];
        [self.contentView addSubview:self.accessLabel];
    }
    return self;
}


-(UILabel *) titleLabel
{
    if(_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 21, 200, 15)];
    _titleLabel.font = textFont15;
    _titleLabel.textColor = color_black_333333;
    return _titleLabel;
}

-(UILabel *) subLabel
{
    if(_subLabel) {
        return _subLabel;
    }
    _subLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.left, self.titleLabel.bottom+12, self.titleLabel.width, 12)];
    _subLabel.font = textFont12;
    _subLabel.textColor = color_gray_cccccc;
    return _subLabel;
}

-(UILabel *)accessLabel
{
    if(_accessLabel) {
        return _accessLabel;
    }
    _accessLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth - 15 -80, self.titleLabel.top, 80, self.subLabel.bottom - self.titleLabel.top)];
    _accessLabel.textAlignment = NSTextAlignmentRight;
    _accessLabel.font = textFont18;
    return _accessLabel;
}

-(void) setModel:(RSModel *)model
{
    [super setModel:model];
    //如果model是levellog
    if([model isKindOfClass:[LevelLogModel class]]) {
        LevelLogModel *levellog = (LevelLogModel *) model;
        self.titleLabel.text = levellog.info;
        self.subLabel.text = levellog.time;
        if(levellog.growth >= 0) {
            self.accessLabel.textColor = color_green_1fc15e;
            self.accessLabel.text = [NSString stringWithFormat:@"+%ld", levellog.growth];
        } else {
            self.accessLabel.textColor = colorrede5;
            self.accessLabel.text = [NSString stringWithFormat:@"%ld", levellog.growth];
        }
    }
}

@end
