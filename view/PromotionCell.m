//
//  PromotionCell.m
//  RedScarf
//
//  Created by lishipeng on 16/1/20.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "PromotionCell.h"
#import "PromotionModel.h"
#import "RSUIView.h"

@implementation PromotionCell
{
    UIView *bgView;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        bgView = [[UIView alloc]initWithFrame:CGRectMake(18, 0, kUIScreenWidth - 36, self.contentView.height)];
        bgView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:bgView];
        
        self.rankView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 15, 12, 12)];
        [bgView addSubview:self.rankView];
        
        self.rankLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 14, 14)];
        self.rankLabel.backgroundColor = MakeColor(135, 135, 135);
        self.rankLabel.layer.masksToBounds = YES;
        self.rankLabel.layer.cornerRadius = 7;
        self.rankLabel.textAlignment = NSTextAlignmentCenter;
        self.rankLabel.font = [UIFont systemFontOfSize:10];
        self.rankLabel.textColor = [UIColor whiteColor];
        [bgView addSubview:self.rankLabel];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, (kUIScreenWidth-30)/4-27, 40)];
        self.nameLabel.font = [UIFont systemFontOfSize:13];
        self.nameLabel.textColor = MakeColor(75, 75, 75);
        [bgView addSubview:self.nameLabel];
        
        self.mobileLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-30)/4, 0, (kUIScreenWidth-30)/4+30, 40)];
        self.mobileLabel.font = [UIFont systemFontOfSize:13];
        self.mobileLabel.textColor = MakeColor(75, 75, 75);
        [bgView addSubview:self.mobileLabel];
        
        self.orderCntLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-30)/4*2, 0, (kUIScreenWidth-30)/4, 40)];
        self.orderCntLabel.textAlignment = NSTextAlignmentCenter;
        
        self.orderCntLabel.font = [UIFont systemFontOfSize:13];
        self.orderCntLabel.textColor = MakeColor(75, 75, 75);
        [bgView addSubview:self.orderCntLabel];
        
        self.promotionLabel = [[UILabel alloc] initWithFrame:CGRectMake((kUIScreenWidth-30)/4*3, 0, (kUIScreenWidth-30)/4, 40)];
        self.promotionLabel.textAlignment = NSTextAlignmentCenter;
        self.promotionLabel.font = [UIFont systemFontOfSize:13];
        self.promotionLabel.textColor = MakeColor(75, 75, 75);
        [bgView addSubview:self.promotionLabel];
        [bgView addSubview:[RSUIView lineWithFrame:CGRectMake(0, 0, bgView.width, 0.5)]];
    }
    return self;
}

-(void) setModel:(PromotionModel *)model
{
    [super setModel:model];
    self.nameLabel.text = model.name;
    self.mobileLabel.text = model.mobile;
    self.orderCntLabel.text = model.orderCnt;
    self.promotionLabel.text = model.promotionCnt;
    if(!model.isSelectable) {
        [bgView setBackgroundColor:MakeColor(240, 240, 240)];
        [self.rankView removeFromSuperview];
        [self.rankLabel removeFromSuperview];
    } else {
        if(model.rank < 3) {
            [self.rankLabel removeFromSuperview];
            self.rankView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld", model.rank]];
        } else {
            [self.rankView removeFromSuperview];
            self.rankLabel.text = [NSString stringWithFormat:@"%ld", model.rank];
        }
    }
    
}
@end
