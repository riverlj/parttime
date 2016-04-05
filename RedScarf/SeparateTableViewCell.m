//
//  SeparateTableViewCell.m
//  RedScarf
//
//  Created by zhangb on 15/10/21.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "SeparateTableViewCell.h"
#import "RSTaskModel.h"

@implementation SeparateTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.bgView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, kUIScreenWidth - 36, 35)];
        [self.bgView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:self.bgView];
        
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,self.bgView.width*2/6, 35)];
        self.typeLabel.textColor = colorblue;
        self.typeLabel.font = textFont12;
        self.typeLabel.numberOfLines = 0;
        self.typeLabel.textAlignment = NSTextAlignmentCenter;
        self.typeLabel.layer.borderColor = color_gray_e8e8e8.CGColor;
        self.typeLabel.layer.borderWidth = 0.5;
        [self.bgView addSubview:self.typeLabel];
        
        self.foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.typeLabel.right, self.typeLabel.top, self.bgView.width*3/6, self.typeLabel.height)];
        self.foodLabel.textColor = color155;
        self.foodLabel.numberOfLines = 0;
        self.foodLabel.font = textFont12;
        self.foodLabel.textAlignment = NSTextAlignmentCenter;
        self.foodLabel.layer.borderColor = color_gray_e8e8e8.CGColor;
        self.foodLabel.layer.borderWidth = 0.5;
        [self.bgView addSubview:self.foodLabel];
        
        self.numLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.foodLabel.right, self.foodLabel.top, self.bgView.width/6, self.foodLabel.height)];
        self.numLabel.font = textFont12;
        self.numLabel.numberOfLines = 0;
        self.numLabel.textAlignment = NSTextAlignmentCenter;
        self.numLabel.layer.borderColor = color_gray_e8e8e8.CGColor;
        self.numLabel.layer.borderWidth = 0.5;
        self.numLabel.textColor = colorblue;
        [self.bgView addSubview:self.numLabel];
    }
    return self;
}

- (void)calculateLableHeight:(UILabel *)lable WithText:(NSString *)text{
    lable.text = text;
    lable.numberOfLines = 0;
    lable.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [lable sizeThatFits:CGSizeMake(self.foodLabel.width, 10000)];
    lable.height = size.height + 20;

}

- (void) setLablesHeight{
    if (self.foodLabel.height >= self.typeLabel.height) {
        self.typeLabel.height = self.foodLabel.height;
    }else{
        self.foodLabel.height = self.typeLabel.height;
    }
    self.numLabel.height = self.foodLabel.height;
    self.bgView.height = self.foodLabel.height;
    self.height = self.foodLabel.height;
}

-(void)setModel:(RSModel *)model
{
    if([model isKindOfClass:[RSTaskModel class]]) {
        RSTaskModel *m = (RSTaskModel *)model;
        [self calculateLableHeight:self.typeLabel WithText:m.tag];
        self.numLabel.text = m.count;   //份数
        [self calculateLableHeight:self.foodLabel WithText:m.content];
        [self setLablesHeight];
        if(!model.isSelectable) {
            [self.typeLabel setTextColor:color_black_666666];
            [self.bgView setBackgroundColor:color_gray_eeeedf2];
            [self.numLabel setTextColor:color_black_666666];
        }
    }
    [super setModel:model];
}

@end
