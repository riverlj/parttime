//
//  RSCatchline.h
//  RedScarf
//
//  Created by lishipeng on 16/1/14.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSCatchline : UIView
@property(nonatomic, strong) UILabel *label;

-(void) setTitle:(NSString *)title withBgColor:(UIColor *)color;
@end
