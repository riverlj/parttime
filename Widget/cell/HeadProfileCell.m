//
//  HeadProfileCell.m
//  RedScarf
//
//  Created by lishipeng on 15/12/12.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "HeadProfileCell.h"
#import "RSAccountModel.h"
#import "MyprofileModel.h"
@implementation HeadProfileCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"me_background.jpg"]];
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.headView];
        [self.contentView addSubview: self.nameLabel];
        [self.contentView addSubview:self.telLabel];
        [self reload];
    }
    return self;
}

-(void) reload
{
    [self.headView reload];
    RSAccountModel *model = [RSAccountModel sharedAccount];
    self.telLabel.text = model.mobile;
    self.nameLabel.text = model.realName;
}

-(UILabel *) telLabel
{
    if(_telLabel) {
        return _telLabel;
    }
    _telLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headView.left - 10, self.nameLabel.bottom - 5, self.nameLabel.width + 20, 25)];
    _telLabel.textColor = colorblue;
    _telLabel.textAlignment = NSTextAlignmentCenter;
    _telLabel.font = [UIFont systemFontOfSize:14];
    return _telLabel;
}

-(UILabel *) nameLabel
{
    if(_nameLabel) {
        return _nameLabel;
    }
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headView.left, self.headView.bottom+5, self.headView.width, 30)];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.textColor = [UIColor whiteColor];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    return _nameLabel;
}

-(UILabel *)titleLabel
{
    if(_titleLabel) {
        return _titleLabel;
    }
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kUIScreenWidth, 44)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = textFont16;
    return _titleLabel;
}

-(RSHeadView *)headView
{
    if(_headView) {
        return _headView;
    }
    _headView = [[RSHeadView alloc]initWithFrame:CGRectMake(0, 15 + self.titleLabel.bottom, 80, 80)];
    _headView.left = (kUIScreenWidth - _headView.width)/2;
    return _headView;
}
-(void) setModel:(RSModel *)model
{
    if([model isKindOfClass:[MyprofileModel class]]) {
        self.titleLabel.text = ((MyprofileModel *)model).title;
    }
    [super setModel:model];
    [self reload];
}
@end
