//
//  LevelViewController.h
//  RedScarf
//
//  Created by zhangb on 15/11/30.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "RSProgressView.h"

@interface LevelViewController : BaseViewController

//进度条
@property(nonatomic, strong) RSProgressView *progressView;
//经验值
@property(nonatomic, strong) UILabel *countLabel;
//等级排名
@property(nonatomic, strong) UILabel *rankLabel;
//预测成长
@property(nonatomic, strong) UILabel *predictionLabel;
//今日成长值
@property(nonatomic, strong) UILabel *todayLabel;

@property(nonatomic, strong) UIImageView *levelIconView;
@end
