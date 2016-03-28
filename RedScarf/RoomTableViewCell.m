//
//  RoomTableViewCell.m
//  RedScarf
//
//  Created by zhangb on 15/8/15.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RoomTableViewCell.h"
#import "Header.h"
#import "RoomMissionModel.h"

@implementation RoomTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = color242;
        [self.contentView addSubview:self.groundImage];
        [self.groundImage addSubview:self.nameLabel];
        [self.groundImage addSubview:self.foodLabel];
        [self.groundImage addSubview:self.numberLabel];
        [self.groundImage addSubview:self.dateLabel];
        [self.groundImage addSubview:self.roundBtn];
    }
    
    return self;
}

-(UILabel *) numberLabel
{
    if(_numberLabel) {
        return _numberLabel;
    }
    _numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y, 180, 30)];
    
    _numberLabel.font = textFont12;
    _numberLabel.numberOfLines = 3;
    _numberLabel.textColor = MakeColor(187, 186, 193);
    return _numberLabel;
}

-(UILabel *) nameLabel
{
    if(_nameLabel) {
        return _nameLabel;
    }
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(51, 10, self.groundImage.width - 51 - 15, 35)];
    _nameLabel.font = textFont15;
    _nameLabel.textColor = color_black_333333;
    _nameLabel.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneNumberClicked:)];
    [_nameLabel addGestureRecognizer:tap];
    return _nameLabel;
}

-(UIImageView *) groundImage
{
    if(_groundImage) {
        return _groundImage;
    }
    _groundImage = [[UIImageView alloc] initWithFrame:CGRectMake(18, 15, kUIScreenWidth-36, 127)];
    _groundImage.backgroundColor = [UIColor whiteColor];
    _groundImage.layer.cornerRadius = 5;
    _groundImage.layer.masksToBounds = YES;
    _groundImage.userInteractionEnabled = YES;
    return _groundImage;
}

-(UILabel *) foodLabel
{
    if(_foodLabel) {
        return _foodLabel;
    }
    _foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom, self.nameLabel.width, 30)];
    _foodLabel.textColor = MakeColor(180, 180, 180);
    _foodLabel.numberOfLines = 0;
    _foodLabel.font = [UIFont systemFontOfSize:12];
    return _foodLabel;
}


-(UILabel *) dateLabel
{
    if(_dateLabel) {
        return _dateLabel;
    }
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.groundImage.width - 105, self.foodLabel.bottom, 100, 30)];
    _dateLabel.textColor = MakeColor(187, 186, 193);
    _dateLabel.font = textFont12;
    return _dateLabel;
}

-(UIButton *) roundBtn
{
    if(_roundBtn) {
        return _roundBtn;
    }
    _roundBtn = [[UIButton alloc] initWithFrame:CGRectMake(10,43, 20, 20)];
    _roundBtn.layer.borderColor = [UIColor grayColor].CGColor;
    _roundBtn.layer.borderWidth = 1.0;
    _roundBtn.layer.cornerRadius = 10;
    _roundBtn.layer.masksToBounds = YES;
    [_roundBtn setImage:[UIImage imageNamed:@"xuanzhong"] forState:UIControlStateSelected];
    [_roundBtn setImage:[UIImage imageNamed:@"weixuanzhong"] forState:UIControlStateNormal];
    return _roundBtn;
}


-(void)setIntroductionText:(NSMutableAttributedString*)text
{
    [self.foodLabel setAttributedText:text];
    CGSize size = CGSizeMake(self.foodLabel.width, 1000);
    
    NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
    CGRect rect = [text boundingRectWithSize:size options:options context:nil];
    self.foodLabel.height = rect.size.height+10;
    
    self.dateLabel.top = self.foodLabel.bottom;
    self.numberLabel.top = self.dateLabel.top;
    self.groundImage.height = self.numberLabel.bottom + 12;
    self.roundBtn.centerY = self.groundImage.height/2;
    self.height = self.groundImage.bottom;
}

- (void)phoneNumberClicked:(UIGestureRecognizer *)sender{
    UILabel *nameAndPhoneLable = (UILabel *)sender.view;
    NSString *nameAndPhoneStr = nameAndPhoneLable.text;
    NSString *phoneStr = [nameAndPhoneStr substringWithRange:NSMakeRange(nameAndPhoneStr.length - 11, 11)];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneStr]]];
}

-(void) setModel:(RSModel *)model
{
    if([model isKindOfClass:[RoomMissionModel class]]) {
        RoomMissionModel *room = (RoomMissionModel *) model;
        if(room.checked) {
            [self.roundBtn setSelected:YES];
        }else {
            [self.roundBtn setSelected:NO];
        }
        
        NSString *nameAndPhone = [NSString stringWithFormat:@"%@:%@",room.name,room.mobile];
        
        NSString *phoneStr = room.mobile;
        NSString *nameStr = room.name;
       
        //数量和餐品颜色
        NSMutableAttributedString *nameAndPhoneAttStr = [[NSMutableAttributedString alloc] initWithString:nameAndPhone];
        NSRange tag1Range = NSMakeRange(nameStr.length+1, phoneStr.length);
        
        [nameAndPhoneAttStr addAttribute:NSForegroundColorAttributeName value:colorblue range:tag1Range];
        [self.nameLabel setAttributedText:nameAndPhoneAttStr];
        
        //content是个数组
        NSString *contentStr = @"";
        NSMutableArray *lengthArr = [NSMutableArray array];
        NSMutableArray *countArr = [NSMutableArray array];
        for (NSDictionary *content in room.content) {
            contentStr = [contentStr stringByAppendingFormat:@"%@                 (%@份)\n",[content objectForKey:@"tag"],[content objectForKey:@"count"]];
            
            NSString *countStr = [NSString stringWithFormat:@"%@",[content objectForKey:@"count"]];
            
            [countArr addObject:[NSNumber numberWithUnsignedInteger:countStr.length+3]];
            [lengthArr addObject:[NSNumber numberWithUnsignedInteger:contentStr.length-1]];
        }
        contentStr = [contentStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        //数量和餐品颜色
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        
        for (int i = 0; i < lengthArr.count; i++) {
            //份数颜色
            int tagLength = [[countArr objectAtIndex:i] intValue];
            int contentLength = [[lengthArr objectAtIndex:i]intValue];
            NSRange tagRange = NSMakeRange(contentLength-tagLength, tagLength);
            [noteStr addAttribute:NSForegroundColorAttributeName value:colorblue range:tagRange];
            
        }
        [self setIntroductionText:noteStr];
        self.numberLabel.text = [NSString stringWithFormat:@"任务编号:%@",room.snid];
        self.dateLabel.text = [room.date substringWithRange:NSMakeRange(0, 10)];
        
    }
    
    
}

- (NSDate *)extractDate:(NSDate *)date {
    //get seconds since 1970
    NSTimeInterval interval = [date timeIntervalSince1970];
    int daySeconds = 24 * 60 * 60;
    //calculate integer type of days
    NSInteger allDays = interval / daySeconds;
    
    return [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
}


@end
