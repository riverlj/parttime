//
//  RSHeadView.h
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSHeadView : UIView

@property(nonatomic, strong)UIImageView *headimgView;
@property(nonatomic, strong)UILabel *positionView;

-(void) reload;
@end
