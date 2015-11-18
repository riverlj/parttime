//
//  FinishTableViewCell.m
//  RedScarf
//
//  Created by zhangb on 15/8/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "FinishTableViewCell.h"
#import "Header.h"


@implementation FinishTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if (kUIScreenWidth == 320) {
            self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 100, 30)];
            self.nameLabel.font = [UIFont systemFontOfSize:14];
            self.nameLabel.textColor = textcolor;
            [self.contentView addSubview:self.nameLabel];
            
            self.chuLiLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, 10, 170, 30)];
            self.chuLiLabel.font = textFont12;
            self.chuLiLabel.textColor = MakeColor(187, 186, 193);
            [self.contentView addSubview:self.chuLiLabel];
        }else{
            self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 130, 30)];
            self.nameLabel.font = [UIFont systemFontOfSize:16];
            self.nameLabel.textColor = textcolor;
            [self.contentView addSubview:self.nameLabel];
            
            self.chuLiLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 7, 170, 30)];
            self.chuLiLabel.font = textFont12;
            self.chuLiLabel.textColor = MakeColor(187, 186, 193);
            [self.contentView addSubview:self.chuLiLabel];
        }
        
        
        self.line = [[UIImageView alloc] initWithFrame:CGRectMake(15, self.nameLabel.frame.size.height+self.nameLabel.frame.origin.y+5, kUIScreenWidth-30, 0.5)];
        self.line.backgroundColor = color155;
        [self.contentView addSubview:self.line];
        
        self.buyerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.line.frame.origin.y+10, 90, 20)];
        self.buyerLabel.font = textFont12;
        self.buyerLabel.textColor = textcolor;
        [self.contentView addSubview:self.buyerLabel];
        
        self.telLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, self.line.frame.origin.y+10, 100, 20)];
        self.telLabel.font = textFont12;
        self.telLabel.textColor = textcolor;
        [self.contentView addSubview:self.telLabel];
        
        self.noctionBtn = [[UIButton alloc] initWithFrame:CGRectMake(kUIScreenWidth-85, self.buyerLabel.frame.size.height+self.buyerLabel.frame.origin.y, 70, 25)];
        self.noctionBtn.titleLabel.font = textFont12;
        self.noctionBtn.layer.masksToBounds = YES;
        self.noctionBtn.layer.cornerRadius = 3;
        [self.noctionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        [self.contentView addSubview:self.noctionBtn];
        
        self.addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.telLabel.frame.size.height+self.telLabel.frame.origin.y, 250, 20)];
        self.addressLabel.font = textFont12;
        self.addressLabel.textColor = textcolor;
        [self.contentView addSubview:self.addressLabel];
        
        self.foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.addressLabel.frame.origin.y+self.addressLabel.frame.size.height, kUIScreenWidth-70, 45)];
        self.foodLabel.numberOfLines = 0;
        self.foodLabel.font = textFont12;
        self.foodLabel.textColor = MakeColor(141, 173, 221);
        [self.contentView addSubview:self.foodLabel];
        
        self.lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y+7, kUIScreenWidth-55, 0.5)];
        self.lineImage.backgroundColor = color155;
        [self.contentView addSubview:self.lineImage];
        
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y+12, 200, 25)];
        self.dateLabel.textColor = textcolor;
        self.dateLabel.font = textFont12;
//        [self.contentView addSubview:self.dateLabel];
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y+12, 200, 25)];
        self.numberLabel.textColor = MakeColor(243, 171, 64);
        self.numberLabel.font = textFont12;
        [self.contentView addSubview:self.numberLabel];
        
    }
    
    return self;
}

-(void)setIntroductionText:(NSString*)text
{
    CGRect frame = [self frame];
    
    self.foodLabel.text = text;
    
    self.foodLabel.numberOfLines = 10;
    CGSize size = CGSizeMake(kUIScreenWidth-55, 1000);
    
    CGSize labelSize = [self.foodLabel.text sizeWithFont:self.foodLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    
    self.foodLabel.frame = CGRectMake(self.foodLabel.frame.origin.x, self.foodLabel.frame.origin.y, labelSize.width, labelSize.height);
    frame.size.height = labelSize.height+100;
    self.lineImage.frame = CGRectMake(40, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y+7, kUIScreenWidth-55, 0.5);
    self.numberLabel.frame = CGRectMake(40, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y+12, 200, 25);
    self.frame = frame;
}


@end
