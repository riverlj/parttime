//
//  ModifyPWViewController.h
//  RedScarf
//
//  Created by zhangb on 15/9/19.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSTableViewController.h"

@interface ModifyPWViewController : BaseViewController<UITextFieldDelegate>

@property(nonatomic ,strong)NSString *titleString;
@property(nonatomic ,strong)NSString *idString;

@property(nonatomic ,strong)NSString *idUrl1;

@property(nonatomic ,strong)NSString *idUrl2;

@property(nonatomic ,strong)NSString *studentUrl1;

@property(nonatomic ,strong)NSString *studentUrl2;


@end
