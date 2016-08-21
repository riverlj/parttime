//
//  XHCustomShareView.h
//  RedScarf
//
//  Created by 李江 on 16/8/21.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"

@interface XHCustomShareView : UIView
+(instancetype)shareViewWithPresentedViewController:(UIViewController *)controller items:(NSArray *)items title:(NSString *)title image:(UIImage *)image urlResource:(NSString *)url;
-(void)dismissShareView;
@end
