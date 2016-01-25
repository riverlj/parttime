//
//  BuildingTaskModel.h
//  RedScarf
//
//  Created by lishipeng on 16/1/15.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSModel.h"

@interface BuildingTaskModel : RSModel<MTLJSONSerializing>
@property(nonatomic, strong) NSString *room;
@property(nonatomic) NSInteger taskNum;
@property(nonatomic) BOOL isSelected;
@end
