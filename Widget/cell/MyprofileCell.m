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
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.iconView];
    }
    return self;
}


-(UILabel *) titleLabel
{
    if(_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.iconView.right+12, self.iconView.top, 200, 16)];
    _titleLabel.font = textFont16;
    _titleLabel.textColor = MakeColor(75, 75, 75);
    return _titleLabel;
}

-(UIImageView *) iconView
{
    if(_iconView) {
        return _iconView;
    }
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 13, 20, 20)];
    
    return _iconView;
}


-(void) setModel:(RSModel *)model
{
    [super setModel:model];
    //如果model是MyprofileModel
    if([model isKindOfClass:[MyprofileModel class]]) {
        MyprofileModel *myprofile = (MyprofileModel *) model;
        self.titleLabel.text = myprofile.title;
        self.iconView.image = [UIImage imageNamed:myprofile.imgName];
    }
}

@end