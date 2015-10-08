//
//  RoomViewController.h
//  RedScarf
//
//  Created by zhangb on 15/8/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"

@interface RoomViewController : BaseViewController

@property(nonatomic,strong)UITableView *detailTableView;

@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)NSString *aId;
@property(nonatomic,strong)NSString *room;
@property(nonatomic,strong)NSString *sn;

@property(nonatomic,strong)NSMutableArray *dataArray;

@end
