//
//  RSAccountModel.h
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSModel.h"

@interface RSAccountModel : RSModel <RSFileStorageProtocol>
- (instancetype)initFromFile;
@end
