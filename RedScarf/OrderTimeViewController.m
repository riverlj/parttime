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

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
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
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *url = @"/user/setting/time";
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    if (self.username.length) {
        [params setObject:self.username forKey:@"username"];
        url = @"/team/user/setting/time";
    }
    [self showHUD:@"正在加载"];
    [RedScarf_API requestWithURL:url params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            
            NSMutableDictionary *dic = [[result objectForKey:@"msg"] objectAtIndex:0];
            NSLog(@"dic = %@",dic);
            NSString *days = [dic objectForKey:@"days"];
            getDaysArray = [days componentsSeparatedByString:@","];
            
            NSMutableDictionary *dic1 = [[result objectForKey:@"msg"] objectAtIndex:1];
            NSLog(@"dic = %@",dic1);
            NSString *days1 = [dic1 objectForKey:@"days"];
            getOtherDaysArray = [days1 componentsSeparatedByString:@","];
            [self hidHUD];
            [self initBtnView];
        }else
        {
            [self hidHUD];
            [self alertView:[result objectForKey:@"msg"]];
        }
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
    moreMonthLabel.text = [NSString stringWithFormat:@"%@年%d月",yearStr,[monthStr intValue]+1];
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
        [_comps setMonth:[monthString integerValue]+1];
    }
    
    [_comps setYear:[yearString integerValue]];
    NSArray * arrWeek=[NSArray arrayWithObjects:@"星期日",@"星期一",@"星期二",@"星期三",@"星期四",@"星期五",@"星期六", nil];
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *_date = [gregorian dateFromComponents:_comps];
    NSDateComponents *weekdayComponents = [gregorian components:NSWeekdayCalendarUnit fromDate:_date];
    int _weekday = [weekdayComponents weekday];
    NSLog(@" _weekday::%d  %@ %@",_weekday,arrWeek[_weekday],_date);

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
        
        AppDelegate *app = [UIApplication sharedApplication].delegate;
        
        app.tocken = [UIUtils replaceAdd:app.tocken];
//        [params setObject:app.tocken forKey:@"token"];
        
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
        NSMutableDictionary *dictionary1 = [NSMutableDictionary dictionary];
        //本月
        [dictionary setObject:yearStr forKey:@"year"];
        [dictionary setObject:monthStr forKey:@"month"];
        //数组转成字符串
        NSMutableString *currStr = @"";
        for (int i = 0; i < getDaysArray.count; i++) {
            if (i == getDaysArray.count-1) {
                currStr = [currStr stringByAppendingFormat:@"%@",getDaysArray[i]];
            }else{
                currStr = [currStr stringByAppendingFormat:@"%@,",getDaysArray[i]];
            }

        }
        [dictionary setObject:currStr forKey:@"days"];
        
        //下月
        [dictionary1 setObject:yearStr forKey:@"year"];
        [dictionary1 setObject:[NSString stringWithFormat:@"%d",[monthStr intValue]+1] forKey:@"month"];
        //数组转成字符串
        NSMutableString *currStr1 = @"";
        for (int i = 0; i < getOtherDaysArray.count; i++) {
            if (i == getOtherDaysArray.count-1) {
                currStr1 = [currStr1 stringByAppendingFormat:@"%@",getOtherDaysArray[i]];
            }else{
                currStr1 = [currStr1 stringByAppendingFormat:@"%@,",getOtherDaysArray[i]];
            }
            
        }
        [dictionary1 setObject:currStr1 forKey:@"days"];
        //转换json
        NSString *dataString = [[NSString alloc] initWithData:[self toJsonData:dictionary] encoding:NSUTF8StringEncoding];
        NSString *dataString1 = [[NSString alloc] initWithData:[self toJsonData:dictionary1] encoding:NSUTF8StringEncoding];
        NSMutableString *jsonString = [NSMutableString stringWithFormat:@"[%@,%@]",dataString,dataString1];
        jsonString = [jsonString stringByReplacingOccurrencesOfString:@"=" withString:@":"];
        //系统put请求
        NSString *urlString;
        NSData *teamData;
        if (self.username.length) {
            urlString = [NSString stringWithFormat:@"%@/team/user/setting/time?token=%@&&username=%@",REDSCARF_BASE_URL,app.tocken,self.username];
            
            NSMutableString *STR = [NSMutableString stringWithFormat:@"{\n\"ustList\":%@,\n\"username\":\"%@\"\n}",jsonString,self.username];
            teamData = [STR dataUsingEncoding:NSUTF8StringEncoding];
        }else{
            urlString = [NSString stringWithFormat:@"%@/user/setting/time?token=%@&&username=%@",REDSCARF_BASE_URL,app.tocken,self.username];
        }
        
        NSURL *url = [NSURL URLWithString:urlString];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"PUT"];
    
        NSMutableDictionary *content = [NSMutableDictionary dictionary];
        [content setObject:@"application/json; charset=UTF-8" forKey:@"Content-Type"];
        [request setAllHTTPHeaderFields:content];
//        NSLog(@"[self toJsonData:array] = %@",[self toJsonData:array]);
        NSData *DATA = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        if (self.username.length) {
            [request setHTTPBody:teamData];
        }else{
            [request setHTTPBody:DATA];
        }
        
        [NSURLConnection connectionWithRequest:request delegate:self];

    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([dataString containsString:@"true"]) {
        [self alertView:@"修改成功"];
        self.navigationItem.rightBarButtonItem.title = @"编辑";
        UIScrollView *scroll = (UIScrollView *)[self.view viewWithTag:50000];
        for (UIView *view in scroll.subviews) {
            if ([[view class] isSubclassOfClass:[UIButton class]]) {
                view.userInteractionEnabled = NO;
            }
        }
        return;
    }else{
        [self alertView:@"修改失败"];
    }
     NSLog(@"dataString = %@",dataString);
    
}
#pragma mark 将dictionary转为data数据
-(NSData *)toJsonData:(id )dict
{
    NSError *error=nil;
//    NSData *da = [NSJSONSer]
    NSData *Jsondata=[NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    if ([Jsondata length]>0&& error==nil) {
        return Jsondata;
    }
    else
        return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
