//
//  RecommendViewController.h
//  RedScarf
//
//  Created by zhangb on 15/8/26.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "UMSocial.h"
@interface RecommendViewController : BaseViewController<UMSocialDataDelegate,UMSocialUIDelegate>

@property(nonatomic,strong)NSString *code;

@end
