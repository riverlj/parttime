//
//  Header.h
//  RedScarf
//
//  Created by zhangb on 15/8/7.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#ifndef RedScarf_Header_h
#define RedScarf_Header_h

#define kUIScreenHeigth  [UIScreen mainScreen].bounds.size.height
#define kUIScreenWidth   [UIScreen mainScreen].bounds.size.width

#define MakeColor(r, g, b) [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1.0f]
#define textcolor [UIColor colorWithRed:(75/255.0f) green:(75/255.0f) blue:(75/255.0f) alpha:1.0f]
#define bgcolor [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(248/255.0f) alpha:1.0f]
#define color155 [UIColor colorWithRed:(155/255.0f) green:(155/255.0f) blue:(155/255.0f) alpha:1.0f]
#define color234 [UIColor colorWithRed:(234/255.0f) green:(234/255.0f) blue:(238/255.0f) alpha:1.0f]
#define color242 [UIColor colorWithRed:(242/255.0f) green:(242/255.0f) blue:(248/255.0f) alpha:1.0f]

#define color102 [UIColor colorWithRed:(102/255.0f) green:(102/255.0f) blue:(102/255.0f) alpha:1.0f]
#define colorblue [UIColor colorWithRed:(79/255.0f) green:(136/255.0f) blue:(251/255.0f) alpha:1.0f]

#define color232 [UIColor colorWithRed:(232/255.0f) green:(232/255.0f) blue:(232/255.0f) alpha:1.0f]

#define textFont12 [UIFont systemFontOfSize:12]
#define textFont14 [UIFont systemFontOfSize:14]
#define textFont15 [UIFont systemFontOfSize:15]
#define textFont16 [UIFont systemFontOfSize:16]
#define textFont18 [UIFont systemFontOfSize:18]
#define textFont20 [UIFont systemFontOfSize:20]


#define AppKey @"55ded144e0f55ae8fe0015b8"

#define NBColorRGBValue$(rgbValue,a)  [UIColor colorWithRed:((float)((rgbValue & 0xff0000) >> 16))/255.0 green:((float)((rgbValue & 0xff00) >> 8))/255.0 blue:((float)(rgbValue & 0xff))/255.0 alpha:a]

#endif
