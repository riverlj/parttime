//
//  RSCalendar.h
//  RedScarf
//
//  Created by lishipeng on 15/12/8.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol RSCalendarProtocol
-(void) dateTaped:(NSDate *)date;
@end

@interface RSCalendar : UIView
{
    NSDate *_date;
}

@property(nonatomic, strong) UILabel *headView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) NSDate *date;

//选中日期
@property(nonatomic, strong) NSMutableArray *selectedArr;
@property(nonatomic, weak)id<RSCalendarProtocol> delegate;

@end

@interface RSCalendarButton : UIButton
@property(nonatomic, strong) UILabel *label;
@end