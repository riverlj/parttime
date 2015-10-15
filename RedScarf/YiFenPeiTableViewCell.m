//
//  YiFenPeiTableViewCell.m
//  RedScarf
//
//  Created by zhangb on 15/8/12.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "YiFenPeiTableViewCell.h"
#import "Header.h"

@implementation YiFenPeiTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.btn.frame = CGRectMake(kUIScreenWidth-105, 9, 85, 30);
//        self.btn.layer.borderColor = [UIColor redColor].CGColor;
//        self.btn.layer.borderWidth = 1;
        self.btn.backgroundColor = colorblue;
        self.btn.layer.cornerRadius = 8;
        self.btn.layer.masksToBounds = YES;
        [self.contentView addSubview:self.btn];
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        self.addressLabel.font = [UIFont systemFontOfSize:16];
        self.addressLabel.textColor = MakeColor(75, 75, 75);
        [self.contentView addSubview:self.addressLabel];
        
//        self.lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, kUIScreenWidth-30, 1)];
//        self.lineImage.image = [UIImage imageNamed:@"xuxian"];
//        [self.contentView addSubview:self.lineImage];
//        self.footImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.frame.size.height, kUIScreenWidth-30, 1)];
//        self.footImage.image = [UIImage imageNamed:@"xuxian"];
//        [self.contentView addSubview:self.footImage];
    }
    return  self;
}

@end
