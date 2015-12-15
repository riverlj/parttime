//
//  RSHomeButton.h
//  RedScarf
//
//  Created by lishipeng on 15/12/14.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSMenuButton : UIButton
@property(nonatomic, strong) UIImageView *image;
@property(nonatomic, strong) UILabel *label;
@property(nonatomic, strong) UIImageView *circleView;

@property(nonatomic) BOOL redPot;
@property(nonatomic, strong) NSString *url;
@property(nonatomic) NSInteger menuid;


-(void) setTitle:(NSString *)title image:(NSString *)image redPot:(BOOL)redPot;

@end
