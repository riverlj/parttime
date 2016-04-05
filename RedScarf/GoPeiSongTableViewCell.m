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
        
        self.detailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.detailBtn.frame = CGRectMake(0, 0, self.bgImageView.width, 45);
        [self.detailBtn setTitle:@"详情" forState:UIControlStateNormal];
        [self.detailBtn setTitleColor:color_blue_5999f8 forState:UIControlStateNormal];
        [self.bgImageView addSubview:self.detailBtn];
        
        self.addLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 200, 15)];
        self.addLabel.font = textFont15;
        self.addLabel.textColor = color_black_333333;
        [self.detailBtn addSubview:self.addLabel];

        

        self.foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.addLabel.left, self.addLabel.bottom + 15, self.bgImageView.width - 2*self.addLabel.left , 12)];
        self.foodLabel.font = textFont12;
        self.foodLabel.numberOfLines = 0;
        self.foodLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.detailBtn addSubview:self.foodLabel];
        
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
    
    CGSize size = [self.foodLabel sizeThatFits:CGSizeMake(self.foodLabel.width, 10000)];
    
    self.foodLabel.height = size.height+10;
    self.btn.top = self.foodLabel.bottom + 12;
    self.bgImageView.height = self.btn.bottom + 8;
    self.detailBtn.height = self.foodLabel.bottom;
    self.detailBtn.titleEdgeInsets = UIEdgeInsetsMake( 25 - self.detailBtn.height/2, self.detailBtn.width/2 -28, self.detailBtn.height/2 -25, 28-self.detailBtn.width/2);
    self.height = self.bgImageView.bottom;
    
}

@end
