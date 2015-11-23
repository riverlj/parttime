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
        
        self.bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, kUIScreenWidth-30, self.frame.size.height-10)];
//        self.bgImageView.image = [UIImage imageNamed:@"liebiao"];
        self.backgroundColor = [UIColor whiteColor];
        self.bgImageView.layer.cornerRadius = 5;
        self.bgImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:self.bgImageView];
        
        self.addLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50)];
        self.addLabel.font = [UIFont systemFontOfSize:18];
        self.addLabel.textColor = MakeColor(75, 75, 75);
        
        [self.contentView addSubview:self.addLabel];
        
        self.foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, self.addLabel.frame.size.height+self.addLabel.frame.origin.y, kUIScreenWidth-30, 40)];
        self.foodLabel.font = [UIFont systemFontOfSize:14];
        self.foodLabel.textColor = MakeColor(180, 180, 180);
        self.foodLabel.numberOfLines = 0;
        [self.contentView addSubview:self.foodLabel];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.btn.frame = CGRectMake(kUIScreenWidth/2-35, 30, 70, 30);
        [self.btn setTitle:@"送达" forState:UIControlStateNormal];
        self.btn.layer.masksToBounds = YES;
        self.btn.layer.cornerRadius = 5;
        [self.btn setBackgroundColor:MakeColor(89, 146, 251)];
        [self.btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:self.btn];
        
        
        self.detailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.detailBtn.frame = CGRectMake(kUIScreenWidth-60, 20, 30, 30);
        [self.detailBtn setTitle:@"详情" forState:UIControlStateNormal];
        [self.detailBtn setTitleColor:MakeColor(69, 126, 251) forState:UIControlStateNormal];
        [self.contentView addSubview:self.detailBtn];
    }
    
    return self;
}

-(void)setIntroductionText:(NSMutableAttributedString*)text
{
    CGRect frame = [self frame];
    
//    self.foodLabel.text = text;
    [self.foodLabel setAttributedText:text];
    self.foodLabel.numberOfLines = 10;
    CGSize size = CGSizeMake(kUIScreenWidth-70, 1000);
    
    CGSize labelSize = [self.foodLabel.text sizeWithFont:self.foodLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    
    self.foodLabel.frame = CGRectMake(self.foodLabel.frame.origin.x, self.foodLabel.frame.origin.y, labelSize.width, labelSize.height);
    frame.size.height = labelSize.height+100;
    self.bgImageView.frame = CGRectMake(15, 10, kUIScreenWidth-30, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y+40);
    self.btn.frame = CGRectMake(kUIScreenWidth/2-45, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y+12, 90, 30);
    self.frame = frame;
}

@end
