//
//  WithdrawModel.h
//  RedScarf
//
//  Created by 李江 on 16/10/14.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSModel.h"

@interface WithdrawViewModel : RSModel
@property (nonatomic, strong)NSString *statustr;
@property (nonatomic, strong)NSString *timestr;
@property (nonatomic, strong)UIColor *rightLabelColor;
@property (nonatomic, strong)NSString *rightText;
@property (nonatomic, strong)NSNumber *status;
@property (nonatomic, assign)Boolean lineDown;
@property (nonatomic, assign)Boolean cellLineHidden;
@property (nonatomic, strong)UIImage *image;

@end

@interface WithdrawModel : RSModel<MTLJSONSerializing>

@property (nonatomic, strong)NSString *requestTime;
@property (nonatomic, strong)NSString *resultTime;
@property (nonatomic, strong)NSString *status;  // 0 1 2 3
@property (nonatomic, strong)NSString *totalFee;
@property (nonatomic, strong)NSString *statusStr;  // 0 1 2 3

@end
