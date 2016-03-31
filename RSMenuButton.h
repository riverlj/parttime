//
//  RSHomeButton.h
//  RedScarf
//
//  Created by lishipeng on 15/12/14.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuModel.h"

@interface RSMenuButton : UIButton
@property(nonatomic, strong) UIImageView *image;
@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UIImageView *circleView;

@property(nonatomic) BOOL redPot;

@property (nonatomic, strong)MenuModel *menuModel;


@end
