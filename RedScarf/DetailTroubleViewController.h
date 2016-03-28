//
//  DetailTroubleViewController.h
//  RedScarf
//
//  Created by 李江 on 16/3/25.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSRefreshTableViewController.h"

@protocol SubmitSuccessDelegate <NSObject>
- (void)submitSuccess;

@end

@interface DetailTroubleViewController : RSRefreshTableViewController<UITextViewDelegate>
@property (nonatomic, copy)NSString *placeholderText;
@property (nonatomic, assign)NSInteger textMaxLength;
@property (nonatomic, copy)NSString *firstReasonCode;
@property (nonatomic, copy)NSString *sns;

@property (nonatomic, weak)id<SubmitSuccessDelegate> submitDelegate;

@end
