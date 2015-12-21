//
//  RoomMissionModel.h
//  RedScarf
//
//  Created by lishipeng on 15/12/18.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSModel.h"

@interface RoomMissionModel : RSModel<MTLJSONSerializing>
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *date;
@property(nonatomic, strong) NSString *mobile;
@property(nonatomic, strong) NSString *snid;
@property(nonatomic, strong) NSArray *content;
@property(nonatomic) BOOL checked;
@end
