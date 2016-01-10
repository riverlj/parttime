//
//  RSTipsView.h
//  RedScarf
//
//  Created by lishipeng on 16/1/5.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSTipsView : UIView
@property(nonatomic, strong)UIImageView *imgView;
@property(nonatomic, strong)UILabel *titleLabel;

-(void) setTitle:(NSString *)title withImg:(NSString *)img;
@end
