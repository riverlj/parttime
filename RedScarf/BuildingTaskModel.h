//
//  BuildingTaskModel.h
//  RedScarf
//
//  Created by lishipeng on 16/1/15.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSModel.h"

@interface RoomContentModel : RSModel<MTLJSONSerializing>
@property (nonatomic ,strong)NSString *tag;
@property (nonatomic ,strong)NSNumber *count;
@property (nonatomic ,strong)NSString *content;
@end

@interface RoomTaskModel : RSModel <MTLJSONSerializing>
@property (nonatomic ,strong)NSString *room;
@property (nonatomic ,strong)NSNumber *taskNum;
@property (nonatomic ,strong)NSArray *content;

+(void)getRoomTask:(NSDictionary *)params success:(void(^)(NSArray *roomTaskModels))success failure:(void (^)(void))failure;
@end

@interface BuildingTaskModel : RSModel<MTLJSONSerializing>
//TODO 无用
@property(nonatomic, strong) NSString *room;
@property(nonatomic, strong) NSString *apartmentName;
@property(nonatomic, strong) NSString *taskNum;
@property(nonatomic) BOOL isSelected;
@property (nonatomic, strong)NSString *apartmentId;


+(void)getBuildingTask:(NSDictionary *)params success:(void(^)(NSArray *buildingTaskModels))success failure:(void (^)(void))failure;
@end
