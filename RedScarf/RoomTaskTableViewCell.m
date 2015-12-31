//
//  RoomTaskTableViewCell.m
//  RedScarf
//
//  Created by lishipeng on 15/12/31.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RoomTaskTableViewCell.h"
#import "Model.h"
#import "BaiduMobStat.h"
#import "AllocatingTaskVC.h"

@implementation RoomTaskTableViewCell
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, kUIScreenWidth/2, 30)];
        self.titleLabel.numberOfLines = 0;
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = MakeColor(75, 75, 75);
        [self.contentView addSubview:self.titleLabel];
        
        self.subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.titleLabel.right +10, 14, 40, 15)];
        self.subTitleLabel.font = [UIFont systemFontOfSize:13];
        self.subTitleLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:self.subTitleLabel];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.btn setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        self.btn.frame = CGRectMake(kUIScreenWidth-115, 7, 90, 30);
        self.btn.backgroundColor = MakeColor(79, 136, 251);
        self.btn.layer.cornerRadius = 5;
        self.btn.layer.masksToBounds = YES;
        [self.contentView addSubview:self.btn];        
    }
    return self;
}

-(void) setTitle:(NSString *)title
{
    CGSize size = CGSizeMake(self.titleLabel.width, 30);
    CGSize labelSize = [title sizeWithFont:self.titleLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    self.titleLabel.height = labelSize.height;
    self.height = self.titleLabel.height + 24;
    self.titleLabel.centerY = self.height/2;
    self.subTitleLabel.centerY = self.height/2;
    self.btn.centerY = self.height/2;
    self.titleLabel.text = title;
}


-(void) setModel:(RSModel *)model
{
    [super setModel:model];
    if([model isKindOfClass:[Model class]]) {
        Model *m = (Model *)model;
        [self setTitle:m.apartmentName];
        self.subTitleLabel.text = [NSString stringWithFormat:@"%@份", m.taskNum];
        [self.btn setTitle:@"分配" forState:UIControlStateNormal];
        [self.btn addTarget:self action:@selector(fenPei:) forControlEvents:UIControlEventTouchUpInside];
    }
}

-(void)fenPei:(id)sender
{
    if(self.delegate) {
        [[BaiduMobStat defaultStat] logEvent:@"分 配" eventLabel:@"button3"];
        Model *model = (Model *) self.model;
        AllocatingTaskVC *allocaVC = [[AllocatingTaskVC alloc] init];
        allocaVC.aId = model.aId;
        allocaVC.userId = model.userId;
        allocaVC.num = 1;
        allocaVC.number = 0;
        [self.delegate.navigationController pushViewController:allocaVC animated:YES];
    }
}
@end
