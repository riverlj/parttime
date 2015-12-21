//
//  RSWebViewController.h
//  RedScarf
//
//  Created by lishipeng on 15/12/16.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"

@interface RSWebViewController : BaseViewController<UIWebViewDelegate>

@property(nonatomic,strong)NSString *urlString;

@end
