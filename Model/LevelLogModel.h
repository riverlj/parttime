//
//  LevelLogModel.h
//  RedScarf
//
//  Created by lishipeng on 15/12/10.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSModel.h"

@interface LevelLogModel : RSModel<MTLJSONSerializing>

@property(nonatomic) NSInteger id;
@property(nonatomic, strong) NSString *info;
@property(nonatomic) NSInteger growth;
@property(nonatomic, strong) NSString *time;
@end
