//
//  MerChantSignInCell.m
//  RedScarf
//
//  Created by 李江 on 16/10/8.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "MerChantSignInCell.h"
#import "MerChantSignInModel.h"

@implementation MerChantSignInCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kleft, 0, 12, 49)];
        imgView.image = [UIImage imageNamed:@"icon_merchant"];
        imgView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:imgView];
        
        self.merchatNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(imgView.right+6, 0, SCREEN_WIDTH-imgView.right-6, 49)];
        self.merchatNameLabel.font = textFont15;
        self.merchatNameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:self.merchatNameLabel];
        
        UIButton *missButton = [UIButton buttonWithType:UIButtonTypeCustom];
        missButton.titleLabel.font = textFont13;
        [missButton setTitle:@"商品遗漏 >" forState:UIControlStateNormal];
        [missButton setTitle:@"商品遗漏 >" forState:UIControlStateHighlighted];
        [missButton setTitleColor:[NSString colorFromHexString:@"7D7D7D"] forState:UIControlStateNormal];
        [missButton setTitleColor:[NSString colorFromHexString:@"7D7D7D"] forState:UIControlStateHighlighted];
        missButton.frame = CGRectMake(SCREEN_WIDTH-94, 0, 94, 49);
        [missButton addTarget:self action:@selector(missGoodsClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:missButton];
        
        missButton.centerY = imgView.centerY;
        
        UIView *lineView = [RSLineView lineViewHorizontalWithFrame:CGRectMake(kleft, 50, SCREEN_WIDTH-20, 1) Color:RS_Line_Color];
        [self.contentView addSubview:lineView];
        
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(kleft, 50, 12, 49)];
        imgView.image = [UIImage imageNamed:@"icon_merchant_time"];
        imgView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:imgView];
        
        UILabel *sendedLabel = [[UILabel alloc] initWithFrame:CGRectMake(imgView.right + 6, 50, 100, 49)];
        sendedLabel.font = textFont14;
        sendedLabel.textColor = [NSString colorFromHexString:@"7d7d7d"];
        sendedLabel.text = @"送达时间";
        CGSize sendedSize = [sendedLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        sendedLabel.width = sendedSize.width;
        [self.contentView addSubview:sendedLabel];
        
        self.timeTextLabel = [[UILabel alloc]initWithFrame:CGRectMake(sendedLabel.right+6, 50, SCREEN_WIDTH-109-sendedLabel.right - 6, 49)];
        NSDate *now = [NSDate date];
        NSString *nowstr = [now stringFromDateWithFormat:@"HH:mm"];
        self.timeTextLabel.font = textFont15;
        self.timeTextLabel.text = nowstr;
        [self.contentView addSubview:self.timeTextLabel];
        [self.timeTextLabel addTapAction:@selector(changeSendTime) target:self];
        self.timeTextLabel.userInteractionEnabled = NO;
        
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.titleLabel.font = textFont13;
        [_sendButton setTitle:@"确认" forState:UIControlStateNormal];
        [_sendButton setTitle:@"确认" forState:UIControlStateHighlighted];
        _sendButton.layer.borderWidth = 1;
        _sendButton.layer.cornerRadius = 4;
        _sendButton.layer.masksToBounds = YES;
        _sendButton.frame = CGRectMake(SCREEN_WIDTH-94-15, 50, 94, 26);
        [_sendButton addTarget:self action:@selector(makesureSend) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.enabled = NO;
        _sendButton.userInteractionEnabled = NO;
        [self.contentView addSubview:_sendButton];
        _sendButton.centerY = imgView.centerY;
    }
    return self;
}

-(void)setModel:(MerChantSignInModel *)model{
    self.merChantSignInModel = model;
    self.merchatNameLabel.text = model.goodsname;
    
    if ([model.status integerValue] == 1) {
        _sendButton.enabled = NO;
        _sendButton.userInteractionEnabled = NO;
        
        _sendButton.layer.borderColor = [NSString colorFromHexString:@"cccccc"].CGColor;
        [_sendButton setTitleColor:[NSString colorFromHexString:@"cccccc"] forState:UIControlStateNormal];
        [_sendButton setTitleColor:[NSString colorFromHexString:@"cccccc"] forState:UIControlStateHighlighted];
        
        self.timeTextLabel.userInteractionEnabled = NO;
        self.timeTextLabel.textColor = [NSString colorFromHexString:@"7d7d7d"];
    }else {
        _sendButton.enabled = YES;
        _sendButton.userInteractionEnabled = YES;
        _sendButton.layer.borderColor = RS_THRME_COLOR.CGColor;
        [_sendButton setTitleColor:RS_THRME_COLOR forState:UIControlStateNormal];
        [_sendButton setTitleColor:RS_THRME_COLOR forState:UIControlStateHighlighted];
        
        self.timeTextLabel.userInteractionEnabled = YES;
        self.timeTextLabel.textColor = [NSString colorFromHexString:@"222222"];

    }
    
    if (model.checktime.length > 0) {
        self.timeTextLabel.text = [model.checktime substringWithRange:NSMakeRange(0, 5)];
    }else {
        self.merChantSignInModel.checktime = self.timeTextLabel.text;
    }
    
    model.cellHeight =99;
}

-(void)changeSendTime{

    if (self.merChantSignInClickDelegate && [self.merChantSignInClickDelegate respondsToSelector:@selector(changeSendedTime:)]) {
        [self.merChantSignInClickDelegate changeSendedTime:self.timeTextLabel];
    }
}

-(void)makesureSend{
    if (self.merChantSignInClickDelegate && [self.merChantSignInClickDelegate respondsToSelector:@selector(makesureSended:)]) {
        [self.merChantSignInClickDelegate makesureSended:self.merChantSignInModel];
    }
}

-(void)missGoodsClicked {
    if (self.merChantSignInClickDelegate && [self.merChantSignInClickDelegate respondsToSelector:@selector(missgoodsClicked:)]) {
        [self.merChantSignInClickDelegate missgoodsClicked:self.merChantSignInModel];
    }
}


@end
