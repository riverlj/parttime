//
//  RSCalendar.m
//  RedScarf
//
//  Created by lishipeng on 15/12/8.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSCalendar.h"

@implementation RSCalendar
{
    CGFloat cellWidth;
    NSUInteger weeks;
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    cellWidth = self.width/7;
}

-(void) setDate:(NSDate *)date
{
    _date = date;
    self.headView.text = [self.date stringFromDateWithFormat:@"yyyy年mm月"];
    self.headView.frame = CGRectMake(0, 0, self.width, cellWidth/2);
    self.contentView.frame = CGRectMake(0, self.headView.height, self.width, self.height-self.headView.height);
    //周数
    weeks = [self.date numberOfWeeksInCurrentMonth];
}

-(void) buttonClicked:(UIButton *)btn
{
    if([btn isSelected]) {
        [btn setSelected:NO];
        [self.selectedArr removeObject:btn.titleLabel.text];
    } else {
        [btn setSelected:YES];
        [self.selectedArr addObject:btn.titleLabel.text];
    }
}

-(NSDate *)date
{
    if(_date) {
        return _date;
    }
    _date = [NSDate dateWithTimeIntervalSinceNow:0];
    return _date;
}

-(UILabel *) headView
{
    if(_headView) {
        return _headView;
    }
    _headView = [[UILabel alloc] init];
    _headView.text = [self.date stringFromDateWithFormat:@"yyyy年mm月"];
    _headView.textAlignment = NSTextAlignmentCenter;
    _headView.backgroundColor = [UIColor clearColor];
    return _headView;
}


@end
