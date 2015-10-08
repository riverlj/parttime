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
        [self.modifyBtn setTitleColor:[UIColor  redColor] forState:UIControlStateNormal];
        self.modifyBtn.frame = CGRectMake(kUIScreenWidth-75, 8, 50, 30);
        self.modifyBtn.layer.borderColor = [UIColor redColor].CGColor;
        self.modifyBtn.layer.borderWidth = 1;
        self.modifyBtn.layer.cornerRadius = 8;
        self.modifyBtn.layer.masksToBounds = YES;
        NSLog(@"~~%f",self.contentView.frame.size.width);
        [self.contentView addSubview:self.modifyBtn];
        
    }
    return self;
}

@end
