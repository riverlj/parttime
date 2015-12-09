//
//  DistributionCell.m
//  RedScarf
//
//  Created by zhangb on 15/8/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "DistributionCell.h"
#import "Header.h"

@implementation DistributionCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.groundImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, kUIScreenWidth-30, 45)];
        self.groundImage.backgroundColor = [UIColor whiteColor];
        self.groundImage.layer.cornerRadius = 5;
        self.groundImage.layer.masksToBounds = YES;
        [self.contentView addSubview:self.groundImage];
        
        self.addLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 200, 50)];
        self.addLabel.font = [UIFont systemFontOfSize:16];
        self.addLabel.textColor = MakeColor(75, 75, 75);

        [self.contentView addSubview:self.addLabel];
        
        self.line = [[UIView alloc] initWithFrame:CGRectMake(0, 46, kUIScreenWidth-80, 1)];
        [self.contentView addSubview:self.line];
        self.line.backgroundColor = color242;
        
        self.foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.addLabel.frame.size.height+self.addLabel.frame.origin.y, kUIScreenWidth-30, 40)];
        self.foodLabel.font = [UIFont systemFontOfSize:14];
        self.foodLabel.textColor = color155;
        self.foodLabel.numberOfLines = 0;
        [self.contentView addSubview:self.foodLabel];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.btn.frame = CGRectMake(kUIScreenWidth-80, 30, 50, 30);
        [self.btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
   
        [self.contentView addSubview:self.btn];
        
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.button.frame = CGRectMake(self.groundImage.frame.size.width-60, 0, 60, self.frame.size.height-15);
        [self.button setTitle:@"给ta" forState:UIControlStateNormal];
        [self.button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        self.button.titleLabel.font = textFont16;
        self.button.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.button.backgroundColor = MakeColor(201, 220, 254);
        [self.groundImage addSubview:self.button];

        
    }
    
    return self;
}

-(void)setIntroductionText:(NSString*)text
{
    CGRect frame = [self frame];
 
    self.foodLabel.text = text;
    
    self.foodLabel.numberOfLines = 10;
      CGSize size = CGSizeMake(200, 1000);
    
    CGSize labelSize = [self.foodLabel.text sizeWithFont:self.foodLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    
    self.foodLabel.frame = CGRectMake(self.foodLabel.frame.origin.x, self.foodLabel.frame.origin.y, labelSize.width, labelSize.height);
    
    frame.size.height = labelSize.height+60;
    
    self.groundImage.frame = CGRectMake(15, 0, kUIScreenWidth-30, labelSize.height+45);
    
    self.frame = frame;
}

@end
