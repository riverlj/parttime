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
@property (nonatomic, strong)NSNumber *apartmentId;


+(void)getBuildingTaskSuccess:(void(^)(NSArray *buildingTaskModels))success failure:(void (^)(void))failure;
@end
