//
//  DistributionCell.m
//  RedScarf
//
//  Created by zhangb on 15/8/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "DistributionCell.h"
#import "Model.h"

@implementation DistributionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = color_gray_f3f5f7;

        self.groundImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, 15, kUIScreenWidth-36, 40)];
        self.groundImage.backgroundColor = [UIColor whiteColor];
        self.groundImage.layer.cornerRadius = 5;
        self.groundImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.groundImage];
        
        UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(18, 12, 3, 16)];
        line.layer.cornerRadius = 1;
        line.layer.masksToBounds = YES;
        [line setBackgroundColor:color_blue_5999f8];
        [self.groundImage addSubview:line];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(line.right + 5, line.top, self.groundImage.width - 36 - 66, line.height)];
        self.nameLabel.textColor = color_black_222222;
        self.nameLabel.font = textFont15;
        [self.groundImage addSubview:self.nameLabel];
        
        self.rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.groundImage.width - 61, 0, 61, 40)];
        self.rightLabel.text = @"给ta";
        self.rightLabel.textColor = MakeColor(0x59, 0x99, 0xf8);
        self.rightLabel.font = textFont15;
        self.rightLabel.textAlignment = NSTextAlignmentCenter;
        self.rightLabel.backgroundColor = MakeColor(0xd3, 0xe4, 0xfe);
        [self.groundImage addSubview:self.rightLabel];
        self.labelArr = [NSMutableArray array];
        
    }
    return self;
}


-(void) setModel:(RSModel *)model
{
    [super setModel:model];
    if([model isKindOfClass:[Model class]]) {
        Model *m = (Model *) model;
        CGFloat top = 40;
        if([self.labelArr count]) {
            for(UILabel *label in self.labelArr) {
                [label removeFromSuperview];
            }
            [self.labelArr removeAllObjects];
        }
        for (NSMutableDictionary *dic in m.tasksArr) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(18, top, self.groundImage.width - self.rightLabel.width-18 -5 , 40)];
            label.textColor = color_black_666666;
            label.font = textFont15;
            label.text = [dic objectForKey:@"apartmentName"];
            
            UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, label.width, 0.5)];
            [line setBackgroundColor:color_gray_e8e8e8];
            [label addSubview:line];
            top += label.height;
            [self.labelArr addObject:label];
            [self.groundImage addSubview:label];
        }
        
        NSString *str = m.username;
        if(!m.present) {
            str = [str append:@"(未出勤)"];
        }
        str = [str append:[NSString stringWithFormat:@" %@", m.mobile]];
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                                     textFont12, NSFontAttributeName,
                                     color_red_e54545, NSForegroundColorAttributeName, nil];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:str attributes:dict];
        [attrStr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color_black_333333, NSForegroundColorAttributeName, textFont15, NSFontAttributeName, nil] range:NSMakeRange(0, [m.username length])];
        [attrStr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color_black_666666, NSForegroundColorAttributeName,  nil] range:NSMakeRange([attrStr length] - [m.mobile length], [m.mobile length])];
        self.nameLabel.attributedText = attrStr;
        
        self.groundImage.height = top;
        self.rightLabel.height = self.groundImage.height;
        self.height = self.groundImage.height + 15;
    }
}

@end
