//
//  FinishTableViewCell.m
//  RedScarf
//
//  Created by zhangb on 15/8/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "FinishTableViewCell.h"
#import "Header.h"
#import "Model.h"
#import "RSUIView.h"

@implementation FinishTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView setBackgroundColor:color_gray_f3f5f7];
        [self.bgView addSubview:self.nameLabel];
        [self.bgView addSubview:self.chuLiLabel];
        [self.bgView addSubview:self.statusImage];
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(self.buyerLabel.left, self.statusImage.bottom, self.bgView.width - 2*self.nameLabel.left, 0.5)];
        [line setBackgroundColor:color_gray_e8e8e8];
        [self.bgView addSubview:line];
        [self.bgView addSubview:self.telLabel];
        [self.bgView addSubview:self.foodLabel];
        [self.bgView addSubview:self.addressLabel];
        [self.bgView addSubview:self.buyerLabel];
        [self.bgView addSubview:self.numberLabel];
        [self.contentView addSubview:self.bgView];
    }
    
    return self;
}

-(UIView *)bgView
{
    if(_bgView) {
        return _bgView;
    }
    _bgView = [RSUIView roundRectViewWithFrame:CGRectMake(10, 0, kUIScreenWidth - 20, 100)];
    [_bgView setBackgroundColor:[UIColor whiteColor]];
    return _bgView;
}

-(UILabel *)nameLabel
{
    if(_nameLabel) {
        return _nameLabel;
    }
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, (self.bgView.width - self.statusImage.width -15)/2, 30)];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.textColor = textcolor;
    return _nameLabel;
}

-(UILabel *) chuLiLabel
{
    if(_chuLiLabel) {
        return _chuLiLabel;
    }
    _chuLiLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.right, 10, self.bgView.width - self.statusImage.width - self.nameLabel.right + 20, 30)];
    _chuLiLabel.font = textFont12;
    _chuLiLabel.textAlignment = NSTextAlignmentRight;
    _chuLiLabel.textColor = MakeColor(187, 186, 193);
    return _chuLiLabel;
}

-(UILabel *) telLabel
{
    if(_telLabel) {
        return _telLabel;
    }
    _telLabel = [[UILabel alloc] initWithFrame:CGRectMake(130, self.buyerLabel.y, 100, 12)];
    _telLabel.font = textFont12;
    _telLabel.textColor = MakeColor(0x27, 0x7d, 0xd7);
    [_telLabel addTapAction:@selector(callPerson:) target:self];
    return _telLabel;
}

-(UILabel *) buyerLabel
{
    if(_buyerLabel) {
        return _buyerLabel;
    }
    _buyerLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.statusImage.bottom+14, 90, 12)];
    _buyerLabel.font = textFont12;
    _buyerLabel.textColor = textcolor;
    return _buyerLabel;
}

-(UILabel *)addressLabel
{
    if(_addressLabel) {
        return _addressLabel;
    }
    _addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.buyerLabel.left, self.buyerLabel.bottom+5, 250, 12)];
    _addressLabel.font = textFont12;
    _addressLabel.textColor = textcolor;
    return _addressLabel;
}

-(UILabel *)numberLabel
{
    if(_numberLabel) {
        return _numberLabel;
    }
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.buyerLabel.left, self.foodLabel.bottom+12, self.bgView.width - self.buyerLabel.left, 40)];
    _numberLabel.textColor = MakeColor(243, 171, 64);
    _numberLabel.font = textFont12;
    UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _numberLabel.width, 0.5)];
    [line setBackgroundColor:color_gray_e8e8e8];
    [_numberLabel addSubview:line];
    return _numberLabel;
}

-(UILabel *) foodLabel
{
    if(_foodLabel) {
        return _foodLabel;
    }
    _foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, self.addressLabel.bottom, self.bgView.width - 40, 45)];
    _foodLabel.numberOfLines = 0;
    _foodLabel.font = textFont12;
    _foodLabel.textColor = MakeColor(141, 173, 221);
    return _foodLabel;
}

-(RSCatchline *)statusImage
{
    if(_statusImage) {
        return _statusImage;
    }
    _statusImage = [[RSCatchline alloc] initWithFrame:CGRectMake(self.bgView.width-45, 0, 45, 45)];
    return _statusImage;
}

-(void)setIntroductionText:(NSAttributedString*)text
{
    self.foodLabel.attributedText = text;
    CGSize size = CGSizeMake(self.foodLabel.width, 1000);

    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [text boundingRectWithSize:size options:options context:nil];
    
    self.foodLabel.height = rect.size.height+10;
    self.numberLabel.top = self.foodLabel.bottom + 8;
    self.bgView.height = self.numberLabel.bottom;
    self.height = self.bgView.height + 10;
}


-(void) setModel:(RSModel *)model
{
    if([model isKindOfClass:[Model class]]) {
        Model *m = (Model *) model;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.nameLabel.text = [NSString stringWithFormat:@"配送人:%@",m.nameStr];
        self.chuLiLabel.text = [NSString stringWithFormat:@"%@",m.dateStr];
        self.buyerLabel.text = [NSString stringWithFormat:@"收货人：%@",m.buyerStr];
        self.telLabel.text = [NSString stringWithFormat:@"%@",m.telStr];
        self.addressLabel.text = [NSString stringWithFormat:@"%@ - %@",m.addressStr,m.room];
        
        NSMutableAttributedString *contentStr = [[NSMutableAttributedString alloc]initWithString:@""];
        for (NSDictionary *dic in m.foodArr) {
            NSMutableAttributedString *tempStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %@  (%@份)\n",[dic objectForKey:@"tag"],[dic objectForKey:@"content"],[dic objectForKey:@"count"]] attributes:[NSDictionary dictionaryWithObjectsAndKeys:color_black_666666, NSForegroundColorAttributeName, textFont12, NSFontAttributeName, nil]];
            [tempStr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:MakeColor(0x59, 0x9a, 0xf8), NSForegroundColorAttributeName, nil] range:NSMakeRange(0, [[dic objectForKey:@"tag"] length])];
            [contentStr appendAttributedString:tempStr];
        }
        [contentStr replaceCharactersInRange:NSMakeRange(contentStr.length - 1, 1) withString:@""];
        [self setIntroductionText:[contentStr copy]];
        self.numberLabel.text = [NSString stringWithFormat:@"任务编号：%@",m.numberStr];
        if ([m.status isEqualToString:@"FINISHED"]) {
            [self.statusImage setTitle:@"已送达" withBgColor:color_blue_287dd8];
        }if ([m.status isEqualToString:@"UNDELIVERED"]) {
            [self.statusImage setTitle:@"未送达" withBgColor:color_red_f9494b];
        }
    }
}

-(void) callPerson:(UITapGestureRecognizer *)tap
{
    if([tap.view isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *) tap.view;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", label.text]]];
    }
}
@end
