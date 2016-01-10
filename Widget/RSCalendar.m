//
//  RSCalendar.m
//  RedScarf
//
//  Created by lishipeng on 15/12/8.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSCalendar.h"
@implementation RSCalendarButton
-(instancetype) init
{
    self = [super init];
    if(self) {
        self.layer.borderColor = color_gray_cccccc.CGColor;
        self.layer.borderWidth = 0.5;
        [self setTitle:@"" forState:UIControlStateDisabled];
        [self setBackgroundColor:color_gray_f3f5f7];
        [self setTitleColor:color_black_666666 forState:UIControlStateNormal];
        [self setTitleColor:color_gray_cccccc forState:UIControlStateDisabled];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    }
    return self;
}

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        self.layer.borderColor = color_gray_cccccc.CGColor;
        self.layer.borderWidth = 0.5;
        [self setTitle:@"" forState:UIControlStateDisabled];
        [self setTitleColor:color_black_666666 forState:UIControlStateNormal];
        [self setTitleColor:color_gray_cccccc forState:UIControlStateDisabled];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [self setBackgroundColor:color_gray_f3f5f7];
    }
    return self;
}

-(UILabel *)label
{
    if(_label) {
        return _label;
    }
    _label = [[UILabel alloc] init];
    _label.textColor = [UIColor whiteColor];
    _label.backgroundColor = MakeColor(0xa7, 0xc7, 0xf8);
    _label.textAlignment = NSTextAlignmentCenter;
    return _label;
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.label.width = self.width*0.6;
    self.label.height = self.height*0.6;
    self.label.centerX = self.width/2;
    self.label.centerY = self.height/2;
    self.label.layer.cornerRadius = self.label.width/2;
    self.label.clipsToBounds = YES;
}

-(void) setSelected:(BOOL)selected
{
    self.label.text = self.titleLabel.text;
    if(selected) {
        if(![self.label superview]) {
            [self addSubview:self.label];
        }
    } else {
        if([self.label superview]) {
            [self.label removeFromSuperview];
        }
    }
    [super setSelected:selected];
}

@end


@implementation RSCalendar
{
    CGFloat cellWidth;
    NSUInteger weeks;
}

-(instancetype) init
{
    self = [super init];
    if(self) {
        [self addSubview:self.headView];
        [self addSubview:self.contentView];
        _selectedArr = [NSMutableArray array];
    }
    return self;
}

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.headView];
        [self addSubview:self.contentView];
        _selectedArr = [NSMutableArray array];
    }
    return self;
}

-(void) setSelectedArr:(NSMutableArray *)selectedArr
{
    _selectedArr = selectedArr;
    for(UIView *subview in [self.contentView subviews]) {
        if([subview isKindOfClass:[RSCalendarButton class]]) {
            RSCalendarButton *btn = (RSCalendarButton *)subview;
            BOOL flag = NO;
            for(NSString *day in selectedArr) {
                if([btn.titleLabel.text isEqualToString:day] && btn.enabled) {
                    flag = YES;
                    break;
                }
            }
            [btn setSelected:flag];
        }
    }
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    cellWidth = self.width/7;
    self.contentView.width = self.width;
    self.contentView.height = cellWidth * weeks  + 3*cellWidth/5;
}

-(void) setDate:(NSDate *)date
{
    _date = date;
    if([_contentView superview]) {
        [_contentView removeFromSuperview];
    }
    _contentView = nil;
    self.headView.text = [self.date stringFromDateWithFormat:@"  yyyy年MM月"];
    //周数
    weeks = [self.date numberOfWeeksInCurrentMonth];
    cellWidth = self.width/7;
    //设置日期时把之前的contentView清空
    self.contentView.frame = CGRectMake(0, self.headView.height, self.width, self.height-self.headView.height);
    self.contentView.width = self.width;
    self.contentView.height = cellWidth * weeks  + cellWidth/5*3;
    [self addSubview:self.contentView];
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
    _date = [NSDate date];
    return _date;
}

-(UILabel *) headView
{
    if(_headView) {
        return _headView;
    }
    _headView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 48)];
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(0, 15, 3, 18)];
    [line setBackgroundColor:color_blue_5999f8];
    [_headView addSubview:line];
    _headView.text = [self.date stringFromDateWithFormat:@"yyyy年MM月"];
    _headView.textAlignment = NSTextAlignmentLeft;
    _headView.font = textFont18;
    _headView.textColor = color_blue_5999f8;
    _headView.backgroundColor = [UIColor clearColor];
    return _headView;
}


-(UIView *) contentView
{
    if(_contentView) {
        return _contentView;
    }
    _contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.headView.bottom, self.width, self.height)];
    NSDate *startDate = [self.date firstDayOfCurrentMonth];
    NSDate *lastDate = [self.date lastDayOfCurrentMonth];
    NSInteger delta = [startDate getWeekIntValueWithDate] - 1;
    //获取起始的日期
    startDate = [startDate dateByAddingTimeInterval:-(delta*86400)];
    NSInteger dayNum = [NSDate getDayNumbertoDay:startDate beforDay:lastDate] +1;
    delta = dayNum%7;
    if(delta > 0) {
        lastDate = [lastDate dateByAddingTimeInterval:(7-delta)*86400];
    }
    
    NSDate *temp = startDate;
    NSInteger total = 0;
    //获取当前的日期的comp
    NSDateComponents *curComp = [self.date YMDComponents];
    NSArray *dict = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for(NSInteger i =0 ; i<[dict count]; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 3*cellWidth/5)];
        label.backgroundColor = color_gray_e8e8e8;
        label.text = dict[i];
        label.textColor = color_black_666666;
        label.textAlignment = NSTextAlignmentCenter;
        label.left = i*cellWidth;
        label.layer.borderColor = color_gray_cccccc.CGColor;
        label.layer.borderWidth = 0.5;
        [_contentView addSubview:label];
    }
    
    NSString *dateString = [NSDate formatNow:@"yyyy-MM-dd"];
    NSDate *curDate = [NSDate dateFromString:dateString];
    //如果比最后日期早
    while([temp compare:lastDate] <= 0) {
        NSInteger i = total / 7;
        NSInteger j = total % 7;
        RSCalendarButton *btn = [[RSCalendarButton alloc]initWithFrame:CGRectMake(0, 0, cellWidth, cellWidth)];
        NSDateComponents *comp = [temp YMDComponents];
        [btn setTitle:[NSString stringWithFormat:@"%ld", [comp day]] forState:UIControlStateNormal];
        //如果不是当月的，不展示
        if([comp month] != [curComp month] || [comp year] != [curComp year]) {
            [btn setEnabled:NO];
        } else if([temp compare:curDate] < 0) {
            [btn setTitle:[NSString stringWithFormat:@"%ld", [comp day]] forState:UIControlStateDisabled];
            [btn setEnabled:NO];
        }
        [btn addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
        btn.left = j * cellWidth;
        btn.top = i * cellWidth + cellWidth/5*3;
        [_contentView addSubview:btn];
        temp = [temp dateByAddingTimeInterval:86400];
        total ++;
    }
    return _contentView;
}

-(void) tapBtn:(id)sender
{
    if([sender isKindOfClass:[RSCalendarButton class]]) {
        RSCalendarButton *button = (RSCalendarButton *)sender;
        if(button.selected) {
            [_selectedArr removeObject:button.titleLabel.text];
        }else {
            [_selectedArr addObject:button.titleLabel.text];
        }
        [button setSelected:!button.selected];
        if(_delegate) {
            NSDateComponents *comp = [self.date YMDComponents];
            comp.day = [button.titleLabel.text integerValue];
            [_delegate dateTaped:[comp date]];
        }
    }
}
@end
