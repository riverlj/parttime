//
//  UserTaskTableViewCell.h
//  RedScarf
//
//  Created by lishipeng on 15/12/31.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSTableViewCell.h"

@interface UserTaskTableViewCell : RSTableViewCell
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic, weak) UITableViewController *delegate;
@end
