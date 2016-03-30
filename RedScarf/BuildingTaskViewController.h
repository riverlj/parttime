//
//  BuildingTaskViewController.h
//  RedScarf
//
//  Created by lishipeng on 16/1/15.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSRefreshTableViewController.h"

@interface BuildingTaskViewController : RSRefreshTableViewController
@property(nonatomic) NSInteger userId;
@property(nonatomic) NSInteger aId;
@property (nonatomic, copy)NSString *apartmentName;

@end
