//
//  AppSettingModel.h
//  RedScarf
//
//  Created by 李江 on 16/10/21.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSModel.h"

@interface AppBusiness : RSModel<MTLJSONSerializing>
@property (nonatomic, strong)NSNumber *type;
@property (nonatomic, strong)NSString *name;
@end

@interface AppSettingModel : RSModel<MTLJSONSerializing>
@property (nonatomic, strong)NSArray *businesslist;
+(void)getAppSetting;
@end
