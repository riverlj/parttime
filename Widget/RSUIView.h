//
//  RSUIView.h
//  RedScarf
//
//  Created by lishipeng on 16/1/13.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSUIView : NSObject 
//返回白色背景的UIView
+(UIView *) roundRectViewWithFrame:(CGRect)frame;
+(UIImageView *) lineWithFrame:(CGRect)frame;
@end
