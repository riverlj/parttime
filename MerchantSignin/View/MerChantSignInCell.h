//
//  MerChantSignInCell.h
//  RedScarf
//
//  Created by 李江 on 16/10/8.
//  Copyright © 2016年 zhangb. All rights reserved.
//

@class MerChantSignInModel;
@protocol MerChantSignInClickDelegate <NSObject>

- (void)missgoodsClicked:(MerChantSignInModel *)model;
- (void)makesureSended:(MerChantSignInModel *)model;
- (void)changeSendedTime:(UILabel *)label;


@end

#import "RSTableViewCell.h"
static const CGFloat kleft = 15;

@interface MerChantSignInCell : RSTableViewCell
@property (nonatomic, strong)UILabel *merchatNameLabel;
@property (nonatomic, strong)UILabel *timeTextLabel;
@property (nonatomic, strong)UIButton *sendButton;

@property (nonatomic ,weak) id<MerChantSignInClickDelegate> merChantSignInClickDelegate;

@property (nonatomic, strong)MerChantSignInModel *merChantSignInModel;


@end
