//
//  HomePageViewController.h
//  RedScarf
//
//  Created by zhangb on 15/10/9.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "SDCycleScrollView.h"

@interface HomePageViewController : BaseViewController

@property(nonatomic, strong) SDCycleScrollView *cycleScrollView;
@property(nonatomic, strong) UIScrollView *listScrollView;

@end
