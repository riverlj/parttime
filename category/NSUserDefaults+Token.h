//
//  NSUserDefault+Token.h
//  RedScarf
//
//  Created by lishipeng on 15/12/16.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults(Token)

+(NSString *) getValue:(NSString *)key;
+(void) setValue:(NSString *) value forKey:(NSString *)key;
+(void) clearValueForKey:(NSString *) key;
@end
