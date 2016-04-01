//
//  MenuModel.h
//  RedScarf
//
//  Created by 李江 on 16/3/31.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSModel.h"

@interface MenuModel : RSModel <MTLJSONSerializing>
@property (nonatomic, assign)NSInteger menuId;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *url;
@property (nonatomic, copy)NSString *imgName;
@property (nonatomic, copy)NSString *vcName;

@end
