//
//  NSString+RSHttp.h
//  RedScarf
//
//  Created by lishipeng on 15/12/7.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(RSHttp)

+ (NSString*)URLencode:(NSString*)originalString stringEncoding:(NSStringEncoding)stringEncoding;

//获取url
-(NSString *) urlWithHost:(NSString *)host;



@end
