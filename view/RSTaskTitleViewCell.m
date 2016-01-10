//
//  RSTaskTitleViewCell.m
//  RedScarf
//
//  Created by lishipeng on 16/1/4.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSTaskTitleViewCell.h"
#import "RSTaskModel.h"
@implementation RSTaskTitleViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(18, 15, 200, 16)];
        self.titleLabel.textColor  = color155;
        self.titleLabel.font = textFont16;
        [self.contentView addSubview:self.titleLabel];
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.titleLabel.top, 3, self.titleLabel.height)];
        [line setBackgroundColor:color_blue_5999f8];
        [self.contentView addSubview:line];
    }
    return self;
}


-(void) setModel:(RSModel *)model
{
    NSArray *tasks;
    if([model isKindOfClass:[RSAssignedTaskModel class]]) {
        RSAssignedTaskModel *m = (RSAssignedTaskModel *) model;
        tasks = m.tasks;
        self.titleLabel.text = [NSString stringWithFormat:@"%@：%@", m.nickname, m.mobile];
    } else if ([model isKindOfClass:[RSDistributionTaskModel class]]) {
        RSDistributionTaskModel *m = (RSDistributionTaskModel *) model;
        self.titleLabel.text = [NSString stringWithFormat:@"%@", m.name];
        tasks = m.tasks;
    }
    CGFloat bottom = self.titleLabel.bottom + 10;
    for (RSTaskModel *task in tasks) {
        RSTableViewCell *cell = [task getCell];
        cell.top = bottom;
        [self.contentView addSubview:cell];
        bottom += cell.height;
    }
    self.height = bottom + self.titleLabel.top;
    [super setModel:model];
}

@end
