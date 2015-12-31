//
//  ModTableViewCell.m
//  RedScarf
//
//  Created by zhangb on 15/8/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "ModTableViewCell.h"
#import "Header.h"

@implementation ModTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.addressLabel.numberOfLines = 0;
        self.addressLabel.textAlignment = NSTextAlignmentLeft;
        self.addressLabel.font = [UIFont systemFontOfSize:16];
        self.addressLabel.textColor = MakeColor(75, 75, 75);
        [self.contentView addSubview:self.addressLabel];
        
        self.modifyBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.modifyBtn setTitleColor:[UIColor  whiteColor] forState:UIControlStateNormal];
        self.modifyBtn.frame = CGRectMake(kUIScreenWidth-115, 7, 90, 30);
        self.modifyBtn.backgroundColor = MakeColor(79, 136, 251);
        self.modifyBtn.layer.cornerRadius = 5;
        self.modifyBtn.layer.masksToBounds = YES;
        [self.contentView addSubview:self.modifyBtn];
        
    }
    return self;
}


@end
