//
//  BannerViewController.h
//  RedScarf
//
//  Created by zhangb on 15/10/16.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"

@interface BannerViewController : BaseViewController<UIWebViewDelegate>

@property(nonatomic,strong)NSString *url;

@end
