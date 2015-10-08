//
//  AddressEditingCell.m
//  RedScarf
//
//  Created by zhangb on 15/8/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "AddressEditingCell.h"
#import "Header.h"

@implementation AddressEditingCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.roundBtn = [[UIImageView alloc] initWithFrame:CGRectMake(10, 12, 20, 20)];
        self.roundBtn.layer.borderColor = [UIColor grayColor].CGColor;
        self.roundBtn.layer.borderWidth = 1.0;
        self.roundBtn.layer.cornerRadius = 10;
        self.roundBtn.layer.masksToBounds = YES;

        [self.contentView addSubview:self.roundBtn];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.textColor = MakeColor(75, 75, 75);
        self.nameLabel.frame = CGRectMake(35, 2, kUIScreenWidth-30, 40);
        [self.contentView addSubview:self.nameLabel];
        
    }
    return self;
}

@end
