//
//  RSProgressView.h
//  RedScarf
//
//  Created by lishipeng on 15/12/10.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSProgressView : UIImageView

@property(nonatomic, strong) UIImageView *frontView;

//前景色
@property(nonatomic, strong) UIColor *frontcolor;
//背景色
@property(nonatomic, strong) UIColor *backColor;
//背景图片
@property(nonatomic, strong) NSString *backImg;
//前景图片
@property(nonatomic, strong) NSString *frontImg;

@property(nonatomic) float progress;


-(void) setProgress:(float)progress withInterval:(float) interval;
-(void) setFrontcolor:(UIColor *)frontcolor backColor:(UIColor *)backColor;
-(void) setFrontImg:(NSString *)frontImg backImg:(NSString *) backImg;
@end
