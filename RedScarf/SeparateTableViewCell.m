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

-(void)setIntroductionText:(NSString*)text
{
    self.foodLabel.text = text;
    self.foodLabel.numberOfLines = 0;
    CGSize size = CGSizeMake(self.foodLabel.width, 1000);
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:self.foodLabel.font, NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGRect rect = [text boundingRectWithSize:size options:options attributes:attributes context:nil];
    
    self.foodLabel.height = rect.size.height + 20;
    self.typeLabel.height = self.foodLabel.height;
    self.numLabel.height = self.foodLabel.height;
    self.bgView.height = self.foodLabel.height;
    self.height = self.foodLabel.height;
}

-(void)setModel:(RSModel *)model
{
    if([model isKindOfClass:[RSTaskModel class]]) {
        RSTaskModel *m = (RSTaskModel *)model;
        self.typeLabel.text = m.tag;
        self.numLabel.text = m.count;
        [self setIntroductionText:m.content];
        if(!model.isSelectable) {
            [self.typeLabel setTextColor:color_black_666666];
            [self.bgView setBackgroundColor:color_gray_eeeedf2];
            [self.numLabel setTextColor:color_black_666666];
        }
    }
    [super setModel:model];
}

@end
