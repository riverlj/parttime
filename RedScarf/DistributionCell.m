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
        
        self.addLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 200, 50)];
        self.addLabel.font = [UIFont systemFontOfSize:18];
        self.addLabel.textColor = MakeColor(75, 75, 75);

        [self.contentView addSubview:self.addLabel];
        
        self.foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, self.addLabel.frame.size.height+self.addLabel.frame.origin.y, kUIScreenWidth-30, 40)];
        self.foodLabel.font = [UIFont systemFontOfSize:14];
        self.foodLabel.textColor = MakeColor(75, 75, 75);
        self.foodLabel.numberOfLines = 0;
        [self.contentView addSubview:self.foodLabel];
        
        self.btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.btn.frame = CGRectMake(kUIScreenWidth-80, 30, 50, 30);
        [self.btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
   
        
        [self.contentView addSubview:self.btn];
        
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
    
    self.frame = frame;
}

@end
