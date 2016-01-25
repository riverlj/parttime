//
//  PromotionModel.h
//  RedScarf
//
//  Created by lishipeng on 16/1/20.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSModel.h"

@interface PromotionModel : RSModel<MTLJSONSerializing>
//排名
@property(nonatomic) NSInteger rank;
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *mobile;
@property(nonatomic, strong) NSString *orderCnt;
@property(nonatomic, strong) NSString *promotionCnt;

@end
