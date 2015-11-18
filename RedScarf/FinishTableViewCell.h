//
//  FinishTableViewCell.h
//  RedScarf
//
//  Created by zhangb on 15/8/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinishTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *chuLiLabel;
@property(nonatomic,strong)UILabel *buyerLabel;
@property(nonatomic,strong)UILabel *telLabel;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UILabel *foodLabel;
@property(nonatomic,strong)UILabel *dateLabel;
@property(nonatomic,strong)UILabel *numberLabel;
@property(nonatomic,strong)UIButton *noctionBtn;
@property(nonatomic,strong)UIImageView *line;
@property(nonatomic,strong)UIImageView *groundImage;
@property(nonatomic,strong)UIImageView *lineImage;

-(void)setIntroductionText:(NSString*)text;

@end
