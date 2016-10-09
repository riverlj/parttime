//
//  RSLineView.h
//  RSUser
//
//  Created by 李江 on 16/4/11.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSLineView : UIView
+(id)lineViewHorizontalWithFrame:(CGRect)frame Color:(UIColor*)lineColor;
+(id)lineViewVerticalWithFrame:(CGRect)frame Color:(UIColor*)lineColor;

+(UIView *)lineViewHorizontal;
@end
