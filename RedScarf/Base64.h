//
//  Base64.h
//  RedScarf
//
//  Created by zhangb on 15/10/28.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Base64 : NSObject
+ (NSString *)encodeString:(NSString *)data;

+ (NSString *)decodeString:(NSString *)data;
@end
