//
//  RSCalendar.h
//  RedScarf
//
//  Created by lishipeng on 15/12/8.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSCalendar : UIView
{
    NSDate *_date;
}

@property(nonatomic, strong) UILabel *headView;
@property(nonatomic, strong) UIView *contentView;
@property(nonatomic, strong) NSDate *date;

//选中日期
@property(nonatomic, strong) NSMutableArray *selectedArr;

@end
