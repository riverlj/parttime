//
//  PromotionViewController.h
//  RedScarf
//
//  Created by zhangb on 15/8/25.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSRefreshTableViewController.h"

@interface PromotionViewController : RSRefreshTableViewController

@end


@interface RSTitleView : UIView

@property(nonatomic, strong) UILabel *numLabel;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) NSString *vcName;
@end