//
//  ListCell.h
//  RedScarf
//
//  Created by zhangb on 15/8/26.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UITableViewCell

@property(nonatomic,strong)UILabel *name;
@property(nonatomic,strong)UILabel *order;
@property(nonatomic,strong)UILabel *totalCount;
@property(nonatomic,strong)UILabel *sort;

@property(nonatomic,strong)UILabel *telLabel;

@property(nonatomic,strong)UIImageView *photoView;

@end
