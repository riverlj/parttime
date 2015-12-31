//
//  RoomTaskTableViewCell.h
//  RedScarf
//
//  Created by lishipeng on 15/12/31.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSTableViewCell.h"

@interface RoomTaskTableViewCell : RSTableViewCell
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *subTitleLabel;
@property(nonatomic, weak) UITableViewController *delegate;
@end
