//
//  BuildingTaskCell.m
//  RedScarf
//
//  Created by lishipeng on 16/1/15.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "BuildingTaskCell.h"
#import "RSUIView.h"
#import "BuildingTaskModel.h"

@implementation BuildingTaskCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *bgView = [RSUIView roundRectViewWithFrame:CGRectMake(18, 10, kUIScreenWidth-36, 45)];
        [self.contentView addSubview:bgView];

        self.iconView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 0, 20, 20)];
        self.iconView.image = [UIImage imageNamed:@"weixuanzhong"];
        self.iconView.centerY = bgView.height/2;
        [bgView addSubview:self.iconView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.right +10, 0, bgView.width - self.iconView.right -18,  bgView.height)];
        [bgView addSubview:self.titleLabel];
    }
    return self;
}


-(void) setModel:(RSModel *)model
{
    [super setModel:model];
    if([model isKindOfClass:[BuildingTaskModel class]]) {
        BuildingTaskModel *m = (BuildingTaskModel *) model;
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ %ld单", m.room, m.taskNum] attributes:@{NSForegroundColorAttributeName:color_black_333333,NSFontAttributeName:textFont15}];
        [attrStr setAttributes:@{NSForegroundColorAttributeName:color_black_666666,NSFontAttributeName:textFont14} range:NSMakeRange(m.room.length, attrStr.length - m.room.length)];
        self.titleLabel.attributedText = attrStr;
        if(m.isSelected) {
            self.iconView.image = [UIImage imageNamed:@"xuanzhong"];
        } else {
            self.iconView.image = [UIImage imageNamed:@"weixuanzhong"];
        }

    }
}

@end
