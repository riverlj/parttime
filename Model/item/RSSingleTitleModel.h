//
//  RSSingleTitleModel.h
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSModel.h"

@interface RSSingleTitleModel : RSModel
@property (nonatomic,copy)NSString *title;
@property (nonatomic,strong)UIFont *font;
@property (nonatomic,strong)UIColor *textColor;
@property (nonatomic,assign)NSTextAlignment textAlignment;

- (id)initWithTitle:(NSString *)title;
+ (id)itemWithTitle:(NSString *)title;
+ (id)itemWithTitle:(NSString *)title font:(UIFont *)font;
+ (id)itemWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor;
@end
