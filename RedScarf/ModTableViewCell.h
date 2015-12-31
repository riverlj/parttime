//
//  ModTableViewCell.h
//  RedScarf
//
//  Created by zhangb on 15/8/10.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSTableViewCell.h"

@interface ModTableViewCell : RSTableViewCell

@property(nonatomic,strong)UIButton *modifyBtn;
@property(nonatomic,strong)UILabel *addressLabel;
@property(nonatomic,strong)UIImageView *groundImage;

@property(nonatomic,strong)UILabel *taskNum;



@end
