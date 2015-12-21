//
//  OrderTimeViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/16.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "OrderTimeViewController.h"

@interface OrderTimeViewController ()

@end

@implementation OrderTimeViewController
{
    UIScrollView *bgView;
    NSArray *dayArray;
    UILabel *monthLabel;
    UILabel *moreMonthLabel;
    NSString *daysText;
    NSString *yearStr;
    NSString *monthStr;
    NSMutableArray *getDaysArray;
    NSMutableArray *getOtherDaysArray;
    NSMutableArray *saveDaysArray;
    NSMutableArray *saveOtherDaysArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"配送时间";
    self.tabBarController.tabBar.hidden = YES;
    dayArray = [NSArray arrayWithObjects:@"日",@"一",@"二",@"三",@"四",@"五",@"六", nil];
    getDaysArray = [NSMutableArray array];
    getOtherDaysArray = [NSMutableArray array];
    saveDaysArray = [NSMutableArray array];
    saveOtherDaysArray = [NSMutableArray array];
    [self navigationBar];

    [self getDate];
    
}


-(void)navigationBar
{
    [self comeBack:nil];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDone)];
    self.navigationItem.rightBarButtonItem = right;
    
    //隐藏tabbar上的按钮
    UIButton *barBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [barBtn removeFromSuperview];
}
-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)getDate
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url = @"/user/setting/time";
    app.tocken = [UIUtils replaceAdd:app.tocken];
    if (self.username.length) {
        [params setObject:self.username forKey:@"username"];
        url = @"/team/user/setting/time";
    }
    [self showHUD:@"正在加载"];
    [RSHttp requestWithURL:url params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSMutableDictionary *dic = [[data objectForKey:@"msg"] objectAtIndex:0];
        NSLog(@"dic = %@",dic);
        NSString *days = [dic objectForKey:@"days"];
        getDaysArray = [[days componentsSeparatedByString:@","] mutableCopy];
        
        NSMutableDictionary *dic1 = [[data objectForKey:@"msg"] objectAtIndex:1];
        NSLog(@"dic = %@",dic1);
        NSString *days1 = [dic1 objectForKey:@"days"];
        getOtherDaysArray = [[days1 componentsSeparatedByString:@","] mutableCopy];
        [self hidHUD];
        [self initBtnView];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self alertView:errmsg];
    }];
}

-(void)initBtnView
{
    bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, kUIScreenHeigth)];
    bgView.tag = 50000;
    if (kUIScreenHeigth == 480) {
        bgView.contentSize = CGSizeMake(0, kUIScreenHeigth*1.5);
    }else{
        bgView.contentSize = CGSizeMake(0, kUIScreenHeigth*1.2);
    }
    
    bgView.userInteractionEnabled = YES;
    bgView.scrollEnabled = YES;
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    yearStr = [dateStr substringToIndex:4];
    NSRange dayRange = NSMakeRange(8, 2);
    daysText = [dateStr substringWithRange:dayRange];
    NSRange range = NSMakeRange(5, 2);
    monthStr = [dateStr substringWithRange:range];
    
    monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-50, 10, 100, 30)];
    monthLabel.text = [NSString stringWithFormat:@"%@年%@月",yearStr,monthStr];
    monthLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:monthLabel];
    
    for (int i = 0; i < 7; i++) {
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+(kUIScreenWidth-30)/7*i, 45, (kUIScreenWidth-30)/7, 30)];
        dayLabel.text = dayArray[i];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.backgroundColor = MakeColor(240, 240, 240);
        dayLabel.textColor = MakeColor(96, 96, 96);
        [bgView addSubview:dayLabel];
    }
    
    NSString *weekday = [self getWeekDay:@"first"];
    ////////////////////////////////////
    moreMonthLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-50, 320, 100, 30)];
    if ([monthStr intValue] == 12) {
        NSString *month = [NSString stringWithFormat:@"%d",1];
        NSString *year = [NSString stringWithFormat:@"%d",[yearStr intValue]+1];
        moreMonthLabel.text = [NSString stringWithFormat:@"%@年%d月",year,[month intValue]];

    }else{
        moreMonthLabel.text = [NSString stringWithFormat:@"%@年%d月",yearStr,[monthStr intValue]+1];

    }
    moreMonthLabel.textAlignment = NSTextAlignmentCenter;
    [bgView addSubview:moreMonthLabel];
    
    for (int i = 0; i < 7; i++) {
        UILabel *dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(15+(kUIScreenWidth-30)/7*i, 355, (kUIScreenWidth-30)/7, 30)];
        dayLabel.text = dayArray[i];
        dayLabel.textAlignment = NSTextAlignmentCenter;
        dayLabel.backgroundColor = MakeColor(240, 240, 240);
        dayLabel.textColor = MakeColor(96, 96, 96);
        [bgView addSubview:dayLabel];
    }
    NSString *otherWeekday = [self getWeekDay:@"twice"];

    int num = 0;
    if ([weekday isEqualToString:@"星期一"]) {
        num = 5;
    }
    if ([weekday isEqualToString:@"星期二"]) {
        num = 0;
    }
    if ([weekday isEqualToString:@"星期三"]) {
        num = 1;
    }
    if ([weekday isEqualToString:@"星期四"]) {
        num = 2;
    }
    if ([weekday isEqualToString:@"星期五"]) {
        num = 3;
    }
    if ([weekday isEqualToString:@"星期六"]) {
        num = 4;
    }
    int monthDays = 0,moreMonthDays = 0;
    if ([monthStr isEqualToString:@"01"]) {
        monthDays = 31;;
        moreMonthDays = 28;
    }
    if ([monthStr isEqualToString:@"02"]) {
        monthDays = 28;
        moreMonthDays = 31;
    }

    if ([monthStr isEqualToString:@"03"]) {
        monthDays = 31;
        moreMonthDays = 30;
    }

    if ([monthStr isEqualToString:@"04"]) {
        monthDays = 30;
        moreMonthDays = 31;
    }

    if ([monthStr isEqualToString:@"05"]) {
        monthDays = 31;
        moreMonthDays = 30;
    }

    if ([monthStr isEqualToString:@"06"]) {
        monthDays = 30;
        moreMonthDays = 31;
    }

    if ([monthStr isEqualToString:@"07"]) {
        monthDays = 31;
        moreMonthDays = 31;
    }

    if ([monthStr isEqualToString:@"08"]) {
        monthDays = 31;
        moreMonthDays = 30;
    }

    if ([monthStr isEqualToString:@"09"]) {
        monthDays = 30;
        moreMonthDays = 31;
    }

    if ([monthStr isEqualToString:@"10"]) {
        monthDays = 31;
        moreMonthDays = 30;
    }
    if ([monthStr isEqualToString:@"11"]) {
        monthDays = 30;
        moreMonthDays = 31;
    }

    if ([monthStr isEqualToString:@"12"]) {
        monthDays = 31;
        moreMonthDays = 31;
    }

   
    for (int i = num ; i < monthDays+num ; i++) {
        NSInteger index = i % 7;
        NSInteger page = i / 7;
        
        // 圆角按钮
        UILabel *superLabel = [[UILabel alloc] init];
        UIButton *aBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        superLabel.layer.borderColor = MakeColor(244, 245, 246).CGColor;
        superLabel.layer.borderWidth = 0.8;
        
        aBt.userInteractionEnabled = NO;
        if (kUIScreenWidth == 320) {
            superLabel.frame = CGRectMake(index * 41+17, page  *  45 + 75, 41, 45);
            aBt.frame = CGRectMake(index * 41+24, page  *  45 + 82, 27, 27);
        }else{
            superLabel.frame = CGRectMake(index * 49+17, page  *  45 + 75, 49, 45);
            aBt.frame = CGRectMake(index * 49+24, page  *  45 + 82, 27, 27);
        }
        aBt.layer.cornerRadius = 13;
        aBt.layer.masksToBounds = YES;

        aBt.tag = 100+i;
        
        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;

        int dayCount = [daysText intValue];
        //当天之前日期不能选
        if ((i-num+1)<dayCount+2) {
            [aBt setTitleColor:MakeColor(200, 200, 200) forState:UIControlStateNormal];
        }else{
            [aBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            for (NSString *day in getDaysArray) {
                if ((i-num+1) == [day intValue]) {
                    [aBt setBackgroundColor:MakeColor(150, 184, 245)];
                    [aBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                }
 
            }
            
            [aBt addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        
        [aBt setTitle:[NSString stringWithFormat:@"%d",i-num+1] forState:UIControlStateNormal];
        
        [bgView addSubview:superLabel];
        [bgView addSubview:aBt];
    }
    
    int otherNum = 0;
    if ([otherWeekday isEqualToString:@"星期一"]) {
        otherNum = 5;
    }
    if ([otherWeekday isEqualToString:@"星期二"]) {
        otherNum = 0;
    }
    if ([otherWeekday isEqualToString:@"星期三"]) {
        otherNum = 1;
    }
    if ([otherWeekday isEqualToString:@"星期四"]) {
        otherNum = 2;
    }
    if ([otherWeekday isEqualToString:@"星期五"]) {
        otherNum = 3;
    }
    if ([otherWeekday isEqualToString:@"星期六"]) {
        otherNum = 4;
    }
    
    for (int i = otherNum ; i < moreMonthDays+otherNum ; i++) {
        NSInteger index = i % 7;
        NSInteger page = i / 7;
        
        // 圆角按钮
        UILabel *superLabel = [[UILabel alloc] init];
        UIButton *aBt = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        superLabel.layer.borderColor = MakeColor(244, 245, 246).CGColor;
        superLabel.layer.borderWidth = 0.8;
        
        aBt.userInteractionEnabled = NO;
        aBt.layer.cornerRadius = 13;
        aBt.layer.masksToBounds = YES;
        if (kUIScreenWidth == 320) {
            
            superLabel.frame = CGRectMake(index * 41+17, page  *  45 + 385, 41, 45);
            aBt.frame = CGRectMake(index * 41+24, page  *  45 + 395, 27, 27);
        }else{
            superLabel.frame = CGRectMake(index * 49+17, page  *  45 + 385, 49, 45);
            aBt.frame = CGRectMake(index * 49+24, page  *  45 + 395, 27, 27);
        }
        [aBt setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        aBt.tag = 1000+i;
        for (NSString *day in getOtherDaysArray) {
            if ((i-otherNum+1) == [day intValue]) {
                [aBt setBackgroundColor:MakeColor(150, 184, 245)];
                [aBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            }
        }
        [aBt addTarget:self action:@selector(otherBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        aBt.titleLabel.textAlignment = NSTextAlignmentCenter;
        [aBt setTitle:[NSString stringWithFormat:@"%d",i-otherNum+1] forState:UIControlStateNormal];

        [bgView addSubview:superLabel];
        [bgView addSubview:aBt];
    }
    
}

//获取每月一号是星期几
-(NSString *)getWeekDay:(NSString *)flag
{
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [formatter stringFromDate:date];
    NSString *yearString = [dateStr substringToIndex:4];
    //判断是不是0开头
    NSRange range = NSMakeRange(5, 2);
    NSString *monthString = [dateStr substringWithRange:range];
    NSRange monthRange = NSMakeRange(0, 1);
    NSString *month = [monthString substringWithRange:monthRange];
    if ([month isEqualToString:@"0"]) {
        NSRange r = NSMakeRange(6, 1);
        monthString = [dateStr substringWithRange:r];
    }
    
    NSLog(@"currentdate = %@ yearStr = %@  monthStr = %@",dateStr,yearString,monthString);
    
    NSDateComponents *_comps = [[NSDateComponents alloc] init];
    [_comps setDay:2];
    if ([flag isEqualToString:@"first"]) {
        [_comps setMonth:[monthString integerValue]];
    }else
    {
        if ([monthString intValue] == 12) {
            monthString = [NSString stringWithFormat:@"%d",1];
            yearString = [NSString stringWithFormat:@"%d",[yearString intValue]+1];
        }else{
            [_comps setMonth:[monthString integerValue]+1];
        }
        
    }
    
    [_comps setYear:[yearString integerValue]];
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    NSInteger _weekday = [weekdayComponents weekday];
    if ([yearString intValue] == 2016 && [monthString intValue] == 1) {
        return arrWeek[1];
    }
    return arrWeek[_weekday];
}

-(void)btnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([btn.backgroundColor isEqual:MakeColor(150, 184, 245)]) {
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [getDaysArray removeObject:btn.titleLabel.text];
    }else{
        btn.backgroundColor = MakeColor(150, 184, 245);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [getDaysArray addObject:btn.titleLabel.text];
    }
    
}

-(void)otherBtnAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if ([btn.backgroundColor isEqual:MakeColor(150, 184, 245)]) {
        btn.backgroundColor = [UIColor whiteColor];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [getOtherDaysArray removeObject:btn.titleLabel.text];
    }else{
        btn.backgroundColor = MakeColor(150, 184, 245);
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [getOtherDaysArray addObject:btn.titleLabel.text];
    }
}

-(void)didClickDone
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
        self.navigationItem.rightBarButtonItem.title = @"保存";

        UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:50000];
        for (UIView *view in scroll.subviews) {
            if ([[view class] isSubclassOfClass:[UIButton class]]) {
                view.userInteractionEnabled = YES;
            }
        }
    }else{
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        NSMutableDictionary *dictionary1 = [NSMutableDictionary dictionary];
        NSInteger year = [yearStr integerValue];
        NSInteger month = [monthStr integerValue];
        //本月
        [dictionary setObject:yearStr forKey:@"year"];
        [dictionary setObject:monthStr forKey:@"month"];
        //数组转成字符串
        NSMutableString *currStr = [NSMutableString stringWithFormat:@""];
        for (int i = 0; i < getDaysArray.count; i++) {
            if (i == getDaysArray.count-1) {
                currStr = [[currStr stringByAppendingFormat:@"%@",getDaysArray[i]] mutableCopy];
            }else{
                currStr = [[currStr stringByAppendingFormat:@"%@,",getDaysArray[i]] mutableCopy];
            }

        }
        [dictionary setObject:currStr forKey:@"days"];
        
        //防止在12月时出现问题
        month++;
        if(month >12) {
            month = 1;
            year ++;
        }
        [dictionary1 setObject:[NSString stringWithFormat:@"%ld", year] forKey:@"year"];
        [dictionary1 setObject:[NSString stringWithFormat:@"%ld", month] forKey:@"month"];
        //数组转成字符串
        NSMutableString *currStr1 = [NSMutableString stringWithFormat:@""];
        for (int i = 0; i < getOtherDaysArray.count; i++) {
            if (i == getOtherDaysArray.count-1) {
                currStr1 = [[currStr1 stringByAppendingFormat:@"%@",getOtherDaysArray[i]] mutableCopy];
            }else{
                currStr1 = [[currStr1 stringByAppendingFormat:@"%@,",getOtherDaysArray[i]] mutableCopy];
            }
            
        }
        [dictionary1 setObject:currStr1 forKey:@"days"];
        NSArray *dataArr = @[dictionary, dictionary1];
        NSString *urlString;
        id params = dataArr;
        if (self.username.length) {
            urlString = [NSString stringWithFormat:@"/team/user/setting/time"];
            params = [NSDictionary dictionaryWithObjectsAndKeys:self.username, @"username", dataArr, @"ustList", nil];
        }else{
            urlString = [NSString stringWithFormat:@"/user/setting/time"];
        }
        [self showHUD:@"修改中"];
        [RSHttp requestWithURL:urlString params:params httpMethod:@"PUTJSON" success:^(NSDictionary *data) {
            [self hidHUD];
            [self alertView:@"修改成功"];
            self.navigationItem.rightBarButtonItem.title = @"编辑";
            UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:50000];
            for (UIView *view in scroll.subviews) {
                if ([[view class] isSubclassOfClass:[UIButton class]]) {
                    view.userInteractionEnabled = NO;
                }
            }
        } failure:^(NSInteger code, NSString *errmsg) {
            [self hidHUD];
            [self alertView:errmsg];
        }];
     }
}
@end
