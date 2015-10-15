//
//  GoPeiSongTableViewCell.h
//  RedScarf
//
//  Created by zhangb on 15/10/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoPeiSongTableViewCell : UITableViewCell
@property(nonatomic,strong)UILabel *addLabel;
@property(nonatomic,strong)UILabel *foodLabel;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UIButton *detailBtn;

@property(nonatomic,strong)UIImageView *groundImage;

-(void)setIntroductionText:(NSString*)text;

@property(nonatomic,strong)UIImageView *bgImageView;
@end
