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
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 250, 35)];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        [self.groundImage addSubview:self.nameLabel];

        [self.groundImage addSubview:self.foodLabel];
        

        [self.groundImage addSubview:self.numberLabel];
        self.dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth-120, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y, 110, 30)];
        self.dateLabel.textColor = MakeColor(187, 186, 193);

        self.dateLabel.font = [UIFont systemFontOfSize:12];
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
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 10, 250, 35)];
    _nameLabel.font = textFont16;
    return _nameLabel;
}

-(UIImageView *) groundImage
{
    if(_groundImage) {
        return _groundImage;
    }
    _groundImage = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, kUIScreenWidth-30, 115)];
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
    _foodLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, self.nameLabel.frame.size.height+self.nameLabel.frame.origin.y, kUIScreenWidth-80, 30)];
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
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth-120, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y, 110, 30)];
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
    [_roundBtn setImage:nil forState:UIControlStateNormal];
    return _roundBtn;
}


-(void)setIntroductionText:(NSMutableAttributedString*)text
{
    CGRect frame = [self frame];
    [self.foodLabel setAttributedText:text];
    
    self.foodLabel.numberOfLines = 10;
    CGSize size = CGSizeMake(kUIScreenWidth-75, 1000);
    
    CGSize labelSize = [self.foodLabel.text sizeWithFont:self.foodLabel.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    
    self.foodLabel.frame = CGRectMake(self.foodLabel.frame.origin.x, self.foodLabel.frame.origin.y, labelSize.width, labelSize.height);
    frame.size.height = labelSize.height+100;
    self.dateLabel.frame = CGRectMake(kUIScreenWidth-120, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y, 110, 30);
    self.numberLabel.frame = CGRectMake(45, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y, 180, 30);
    self.groundImage.frame = CGRectMake(15, 10, kUIScreenWidth-30, self.foodLabel.frame.size.height+self.foodLabel.frame.origin.y+40);
    self.frame = frame;
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
        self.nameLabel.text = [NSString stringWithFormat:@"%@:%@",room.name,room.mobile];
        //content是个数组
        NSString *contentStr = @"";
        NSMutableArray *lengthArr = [NSMutableArray array];
        NSMutableArray *tagArr = [NSMutableArray array];
        for (NSDictionary *content in room.content) {
            contentStr = [contentStr stringByAppendingFormat:@"%@  %@  (%@份)\n",[content objectForKey:@"tag"],[content objectForKey:@"content"],[content objectForKey:@"count"]];
            NSString *tagStr = [NSString stringWithFormat:@"%@",[content objectForKey:@"tag"] ];
            [tagArr addObject:[NSNumber numberWithUnsignedInteger:tagStr.length]];
            [lengthArr addObject:[NSNumber numberWithUnsignedInteger:contentStr.length]];
        }
        //数量和餐品颜色
        NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:contentStr];
        for (int i = 0; i < lengthArr.count; i++) {
            //份数颜色
            int tagLength = [[tagArr objectAtIndex:i] intValue];
            NSRange tagRange;
            if (i == 0) {
                tagRange = NSMakeRange(0, tagLength);
            }else{
                tagRange = NSMakeRange([[lengthArr objectAtIndex:i-1] intValue], tagLength);
            }
            
            [noteStr addAttribute:NSForegroundColorAttributeName value:colorblue range:tagRange];
            
        }
        [self setIntroductionText:noteStr];
        self.numberLabel.text = [NSString stringWithFormat:@"任务编号:%@",room.snid];
        self.dateLabel.text = room.date;
    }
}


@end
