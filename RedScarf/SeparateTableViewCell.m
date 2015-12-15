//
//  SeparateTableViewCell.m
//  RedScarf
//
//  Created by zhangb on 15/10/21.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "SeparateTableViewCell.h"
#import "Header.h"

@implementation SeparateTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0,(kUIScreenWidth-20)/3, 35)];
        self.typeLabel.textColor = colorblue;
        self.typeLabel.font = textFont12;
        self.typeLabel.numberOfLines = 0;
        self.typeLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.typeLabel];
        
        self.foodLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-20)/5*2+5, 0, (kUIScreenWidth-20)/5*2, 35)];
        self.foodLabel.textColor = color155;
        self.foodLabel.numberOfLines = 0;
        self.foodLabel.font = textFont12;
        self.foodLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.foodLabel];
        
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-20)/5*4+5, 0, (kUIScreenWidth-20)/5, 35)];
        self.numLabel.textColor = color155;
        self.numLabel.font = textFont12;
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.numLabel];
    }
    return self;
}

-(void)setIntroductionText:(NSString*)text
{
    CGRect frame = [self frame];
    
    self.foodLabel.text = text;
    
    self.foodLabel.numberOfLines = 10;
    CGSize size = CGSizeMake((kUIScreenWidth-20)/5*2, 1000);
    
    CGSize labelSize = [self.foodLabel.text sizeWithFont:self.foodLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    
    if (labelSize.width-10 < (kUIScreenWidth-20)/5*2) {
        self.foodLabel.frame = CGRectMake(self.foodLabel.frame.origin.x, self.foodLabel.frame.origin.y,(kUIScreenWidth-20)/5*2-10, labelSize.height+20);
        self.typeLabel.frame = CGRectMake(self.typeLabel.frame.origin.x, self.typeLabel.frame.origin.y,(kUIScreenWidth-20)/5*2-10, labelSize.height+20);
    }else{
        self.foodLabel.frame = CGRectMake(self.foodLabel.frame.origin.x, self.foodLabel.frame.origin.y, labelSize.width-10, labelSize.height+20);
        self.typeLabel.frame = CGRectMake(self.typeLabel.frame.origin.x, self.typeLabel.frame.origin.y, labelSize.width-10, labelSize.height+20);
    }

    frame.size.height = labelSize.height+20;
    
    self.frame = frame;
}

@end
