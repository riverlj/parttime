//
//  DistributionCell.h
//  RedScarf
//
//  Created by zhangb on 15/8/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DistributionCell : UITableViewCell

@property(nonatomic,strong)UILabel *addLabel;
@property(nonatomic,strong)UILabel *foodLabel;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UIImageView *groundImage;
@property(nonatomic,strong)UIView *line;

@property(nonatomic,strong)UILabel *rightLabel;

-(void)setIntroductionText:(NSString*)text;

@end
