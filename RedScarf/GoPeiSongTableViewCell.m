//
//  GoPeiSongTableViewCell.m
//  RedScarf
//
//  Created by zhangb on 15/10/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "GoPeiSongTableViewCell.h"
#import "Header.h"

@implementation GoPeiSongTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(18, 10, kUIScreenWidth-36, 50)];
        self.backgroundColor = [UIColor whiteColor];
        self.bgImageView.layer.cornerRadius = 5;
        self.bgImageView.layer.masksToBounds = YES;
        self.bgImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.bgImageView];
        
        self.addLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 15)];
        self.addLabel.font = textFont15;
        self.addLabel.textColor = color_black_333333;
        [self.bgImageView addSubview:self.addLabel];

        self.detailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.detailBtn.frame = CGRectMake(self.bgImageView.width-60, 0, 60, 45);
        [self.detailBtn setTitle:@"详情" forState:UIControlStateNormal];
        [self.detailBtn setTitleColor:color_blue_5999f8 forState:UIControlStateNormal];
        [self.bgImageView addSubview:self.detailBtn];

        
        self.foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.addLabel.left, self.addLabel.bottom + 15, self.bgImageView.width - 36, 12)];
        self.foodLabel.font = textFont12;
        self.foodLabel.numberOfLines = 0;
        [self.bgImageView addSubview:self.foodLabel];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.btn.frame = CGRectMake(0, self.foodLabel.bottom + 15, 70, 30);
        self.btn.centerX = self.bgImageView.width/2;
        self.btn.titleLabel.font = textFont15;
        self.btn.titleLabel.textColor = [UIColor whiteColor];
        [self.btn setTitle:@"送达" forState:UIControlStateNormal];
        self.btn.layer.masksToBounds = YES;
        self.btn.layer.cornerRadius = 5;
        [self.btn setBackgroundColor:MakeColor(89, 146, 251)];
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.bgImageView addSubview:self.btn];
    }
    
    return self;
}

-(void)setIntroductionText:(NSMutableAttributedString*)text
{
    [self.foodLabel setAttributedText:text];
    CGSize size = CGSizeMake(self.foodLabel.width, 1000);
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [text boundingRectWithSize:size options:options context:nil];
    
    self.foodLabel.height = rect.size.height+10;
    self.btn.top = self.foodLabel.bottom + 12;
    self.bgImageView.height = self.btn.bottom + 8;
    self.height = self.bgImageView.bottom;
}

@end
