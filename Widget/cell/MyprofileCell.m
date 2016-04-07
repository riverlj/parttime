//
//  MyprofileCell.m
//  RedScarf
//
//  Created by lishipeng on 15/12/12.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "MyprofileCell.h"
#import "MyprofileModel.h"

@implementation MyprofileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconView];
        self.detailTextLabel.textAlignment = NSTextAlignmentRight;
    }
    return self;
}


-(UILabel *) titleLabel
{
    if(_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.right+12, 16.5, 200, 15)];
    _titleLabel.font = textFont15;
    _titleLabel.textColor = color_black_333333;
    return _titleLabel;
}


-(UIImageView *) iconView
{
    if(_iconView) {
        return _iconView;
    }
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 12, 20, 20)];
    return _iconView;
}


-(void) setModel:(RSModel *)model
{
    [super setModel:model];
    //如果model是MyprofileModel
    if([model isKindOfClass:[MyprofileModel class]]) {
        MyprofileModel *myprofile = (MyprofileModel *) model;
        self.titleLabel.text = myprofile.title;
        if ([myprofile.imgName hasPrefix:@"http://"]) {
            [self.iconView sd_setImageWithURL:[NSURL URLWithString:myprofile.imgName]];
        }else{
            self.iconView.image = [UIImage imageNamed:myprofile.imgName];
        }
        self.detailTextLabel.attributedText = myprofile.subtitle;
    }
}

@end
