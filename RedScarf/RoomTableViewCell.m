//
//  RoomTableViewCell.m
//  RedScarf
//
//  Created by zhangb on 15/8/15.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RoomTableViewCell.h"
#import "Header.h"

@implementation RoomTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.groundImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, kUIScreenWidth-30, 115)];
        self.groundImage.backgroundColor = [UIColor redColor];
        self.groundImage.backgroundColor = [UIColor whiteColor];
        self.groundImage.layer.cornerRadius = 5;
        self.groundImage.layer.masksToBounds = YES;
        self.groundImage.userInteractionEnabled = YES;
        //        self.groundImage.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:self.groundImage];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 250, 35)];
        [self.groundImage addSubview:self.nameLabel];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, self.nameLabel.frame.size.height+self.nameLabel.frame.origin.y, kUIScreenWidth-90, 30)];
        self.foodLabel.numberOfLines = 0;
        self.foodLabel.font = [UIFont systemFontOfSize:12];
        [self.groundImage addSubview:self.foodLabel];
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y, 180, 30)];
        self.numberLabel.font = [UIFont systemFontOfSize:12];
        self.numberLabel.textColor = MakeColor(187, 186, 193);

        [self.groundImage addSubview:self.numberLabel];
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth-120, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y, 110, 30)];
        self.dateLabel.textColor = MakeColor(187, 186, 193);

        self.dateLabel.font = [UIFont systemFontOfSize:12];
        [self.groundImage addSubview:self.dateLabel];
        
        self.roundBtn = [[UIImageView alloc] initWithFrame:CGRectMake(10,43, 20, 20)];
        self.roundBtn.layer.borderColor = [UIColor grayColor].CGColor;
        self.roundBtn.layer.borderWidth = 1.0;
        self.roundBtn.layer.cornerRadius = 10;
        self.roundBtn.layer.masksToBounds = YES;
        
        [self.groundImage addSubview:self.roundBtn];
    }
    
    return self;
}

@end
