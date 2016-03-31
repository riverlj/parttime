//
//  NSDate+RSFormatter.h
//  RedScarf
//
//  Created by lishipeng on 15/12/8.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(RSFormatter)


- (NSUInteger)numberOfDaysInCurrentMonth;

- (NSUInteger)numberOfWeeksInCurrentMonth;

- (NSUInteger)weeklyOrdinality;

- (NSDate *)firstDayOfCurrentMonth;

- (NSDate *)lastDayOfCurrentMonth;

- (NSDate *)dayInThePreviousMonth;

- (NSDate *)dayInTheFollowingMonth;

- (NSDate *)dayInTheFollowingMonth:(int)month;//获取当前日期之后的几个月

- (NSDate *)dayInTheFollowingDay:(int)day;//获取当前日期之后的几个天

- (NSDateComponents *)YMDComponents;

+(NSDate *)dateFromString:(NSString *)dateString;//NSString转NSDate
+(NSDate *)dateFromString:(NSString *)dateString WithFormatter:(NSString *)formatter;

- (NSString *)stringFromDateWithFormat:(NSString *)format;//NSDate转NSString

+ (int)getDayNumbertoDay:(NSDate *)today beforDay:(NSDate *)beforday;

-(int)getWeekIntValueWithDate;



//判断日期是今天,明天,后天,周几
-(NSString *)compareIfTodayWithDate;
//通过数字返回星期几
+(NSString *)getWeekStringFromInteger:(int)week;

//根据时间戳获取相应format格式的时间
+(NSString *)formatTimestamp:(NSInteger)timestamp format:(NSString *)format;
+(NSString *)formatNow:(NSString *)format;
@end
