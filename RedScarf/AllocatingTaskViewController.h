//
//  AllocatingTaskViewController.h
//  RedScarf
//
//  Created by lishipeng on 15/12/31.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSRefreshTableViewController.h"

@interface AllocatingTaskViewController : RSRefreshTableViewController<UISearchDisplayDelegate>

@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UISearchDisplayController *searchDisplay;
@property(nonatomic,strong)NSString *aId;
@property(nonatomic,strong)NSString *room;
@property(nonatomic,strong)NSString *userId;
@end
