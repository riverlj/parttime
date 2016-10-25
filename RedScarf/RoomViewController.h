//
//  RoomViewController.h
//  RedScarf
//
//  Created by zhangb on 15/8/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSRefreshTableViewController.h"
#import "DetailTroubleViewController.h"

@interface RoomViewController : RSRefreshTableViewController<UIActionSheetDelegate, SubmitSuccessDelegate>

@property(nonatomic,strong)NSString *titleStr;
@property(nonatomic,strong)NSString *aId;
@property(nonatomic,strong)NSString *room;
@property(nonatomic,strong)NSString *sn;
@property(nonatomic,strong)NSString *type;
@end
