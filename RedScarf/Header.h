//
//  Header.h
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#ifndef RedScarf_Header_h
#define RedScarf_Header_h

#ifdef DEBUG
#define NSLog(s,...) NSLog(@"<%@(%d)> %@",[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__])
#define NSDump(s) NSLog(@"%@", s)
#else
#define NSLog(s,...)
#define NSDump(s)
#endif



#define kUIScreenHeigth  [UIScreen mainScreen].bounds.size.height
#define kUIScreenWidth   [UIScreen mainScreen].bounds.size.width
#define SCREEN_WIDTH kUIScreenWidth
#define SCREEN_HEIGHT kUIScreenHeigth
#define kUITabBarHeight  64

#define RTRectMake(x,y,width,height) CGRectMake(floor(x), floor(y), floor(width), floor(height)) //防止frame出现小数，绘制模糊
#define Font(x) [UIFont systemFontOfSize:x]
#define BoldFont(x) [UIFont boldSystemFontOfSize:x]

#define MakeColor(r, g, b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f]

#define textcolor [UIColor colorWithRed:(75/255.0f) green:(75/255.0f) blue:(75/255.0f) alpha:1.0f]
#define bgcolor [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(248/255.0f) alpha:1.0f]
#define color155 [UIColor colorWithRed:(155/255.0f) green:(155/255.0f) blue:(155/255.0f) alpha:1.0f]
#define color234 [UIColor colorWithRed:(234/255.0f) green:(234/255.0f) blue:(238/255.0f) alpha:1.0f]
#define color242 [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(248/255.0f) alpha:1.0f]
#define color102 [UIColor colorWithRed:(102/255.0f) green:(102/255.0f) blue:(102/255.0f) alpha:1.0f]
#define colorblue [UIColor colorWithRed:(79/255.0f) green:(136/255.0f) blue:(251/255.0f) alpha:1.0f]
#define color232 [UIColor colorWithRed:(232/255.0f) green:(232/255.0f) blue:(232/255.0f) alpha:1.0f]


#define RGB(r, g, b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f]
#define RGBA(r, g, b, a) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)]
//标准色：格式规范
//主色，#5999f8 主色，蓝色 1474ff
#define color_blue_5999f8 MakeColor(0x14, 0x74, 0xff)
//主要用于背景色
#define color_gray_f3f5f7 MakeColor(0xf3, 0xf5, 0xf7)

//USE
#define RS_THRME_COLOR color_blue_5999f8
#define RS_COLOR_BACKGROUND color_gray_f3f5f7
#define RS_Line_Color  RGB(238,238,238)

//强调性颜色，多用于大标题
#define color_black_222222 MakeColor(0x22, 0x22, 0x22)
//次要信息，辅助性文字，标签栏
#define color_black_666666 MakeColor(0x99, 0x99, 0x99)
//用于主要分割线，描边等信息
#define color_gray_cccccc MakeColor(0xcc, 0xcc, 0xcc)
//用于次要分线
#define color_gray_e8e8e8 MakeColor(0xe8, 0xe8, 0xe8)

//灰色标题色
#define color_gray_eeeedf2 MakeColor(0xee, 0xee, 0xf2)


#define color_blue_287dd8 MakeColor(0x28, 0x7d, 0xd8)
//常规红色
#define color_red_e54545 MakeColor(0xe5, 0x45, 0x45)
#define color_red_f9494b MakeColor(0xf9, 0x49, 0x4b)
//常规绿色
#define color_green_65cb99 MakeColor(0x65, 0xcb, 0x99)


#define color_black_333333 MakeColor(0x33, 0x33, 0x33)
#define colorgreen65 MakeColor(0x65, 0xcb, 0x99)
#define color_green_1fc15e MakeColor(0x1f, 0xc1, 0x5e)
#define colorrede5 MakeColor(0xe5, 0x45, 0x45)

#define textFont8 [UIFont systemFontOfSize:8]
#define textFont10 [UIFont systemFontOfSize:10]
#define textFont12 [UIFont systemFontOfSize:12]
#define textFont13 [UIFont systemFontOfSize:13]
#define textFont14 [UIFont systemFontOfSize:14]
#define textFont15 [UIFont systemFontOfSize:15]
#define textFont16 [UIFont systemFontOfSize:16]
#define textFont18 [UIFont systemFontOfSize:18]
#define textFont20 [UIFont systemFontOfSize:20]

#define YOUMENGAPPKEY @"57b8c08f67e58ee25c004e19"
#define WXAPPKEY @"wx725baec806f0cae0"
#define WXAPPSECRET @"74f4ffe983da45d2726895f39171a2de"

#ifdef DEBUG
#define  REDSCARF_BASE_URL @"http://plsy.dev.honglingjinclub.com"
#define  REDSCARF_PAY_URL @"http://paytest.honglingjinclub.com"
#define  REDSCARF_MOBILE_URL @"http://mtest.dev.honglingjinclub.com"
#else
//正式
#define  REDSCARF_BASE_URL @"http://jianzhi.honglingjinclub.com"
#define  REDSCARF_PAY_URL @"https://pay.honglingjinclub.com"
#define  REDSCARF_MOBILE_URL @"http://weixin.honglingjinclub.com"
#endif

#define iPhone4S ([UIScreen mainScreen].bounds.size.height == 480 ? YES : NO)
#define iPhone5S ([UIScreen mainScreen].bounds.size.height == 568 ? YES : NO)
#define iPhone6  ([UIScreen mainScreen].bounds.size.height == 667 ? YES : NO)
#define iPhone6Plus ([UIScreen mainScreen].bounds.size.height == 736 ? YES : NO)

#define IOS7 ([[[UIDevice currentDevice] systemVersion] floatValue]>=7.0f ? YES : NO)
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0f ? YES : NO)
#define IOS9 ([[[UIDevice currentDevice] systemVersion] floatValue]>=9.0f ? YES : NO)



#import "RSHttp.h"
#import "RSCategory.h"
#import "MJRefresh.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ReactiveCocoa.h"
#import "Masonry.h"
#import "UMSocial.h"
#import "WXApi.h"
#import "LayOutConfig.h"
#import "RSToastView.h"

 #endif
