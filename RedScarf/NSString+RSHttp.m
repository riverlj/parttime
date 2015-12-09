//
//  NSString+RSHttp.m
//  RedScarf
//
//  Created by lishipeng on 15/12/7.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "NSString+RSHttp.h"

@implementation NSString(RSHttp)

-(NSString *) urlWithHost:(NSString *)host
{
    if(!host) {
        host = REDSCARF_BASE_URL;
    }
    //如果当前url以http://或https开头，则跳过
    if([self hasPrefix:@"http://"] || [self hasPrefix:@"https://"]) {
        return self;
    }
    return [NSString stringWithFormat:@"%@%@", host, self];
}


+ (NSString*)URLencode:(NSString*)originalString stringEncoding:(NSStringEncoding)stringEncoding
{
    if (originalString == nil) {
        return nil;
    }
    NSArray *escapeChars = [NSArray arrayWithObjects:@";", @"/" , @"?" , @":",@"@" , @"&" , @"=" , @"+" ,@"$", @",",@"!", @"'", @"(", @")", @"*", nil];
    
    NSArray *replaceChars = [NSArray arrayWithObjects:@"%3B" , @"%2F", @"%3F" , @"%3A" , @"%40" , @"%26" , @"%3D" , @"%2B" , @"%24" , @"%2C" ,@"%21", @"%27", @"%28", @"%29", @"%2A", nil];
    
    NSUInteger len =[escapeChars count];
    NSMutableString *temp = [[originalString stringByAddingPercentEscapesUsingEncoding:stringEncoding] mutableCopy];
    for(NSUInteger i = 0; i < len; i++)
    {
        [temp replaceOccurrencesOfString:[escapeChars objectAtIndex:i] withString:[replaceChars objectAtIndex:i] options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    }
    NSString *outStr = [NSString stringWithString:temp];
    return outStr;
}

@end
