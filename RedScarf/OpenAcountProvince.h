//
//  OpenAcountProvince.h
//  RedScarf
//
//  Created by zhangb on 15/9/3.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "MyProtocol.h"

@interface OpenAcountProvince : BaseViewController

@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)NSMutableArray *filteredArray;
@property(nonatomic,strong)UISearchDisplayController *searchaDisplay;
@property(nonatomic,strong)NSMutableArray *dataArray;
@property(nonatomic,strong)NSMutableArray *nameArray;
@property(nonatomic,strong)NSString *titleString;
@property(nonatomic,assign)id<MyProtocol>delegate;

@property(nonatomic,strong)NSString *Id;
@property(nonatomic,strong)NSMutableArray *idArr;


@end
