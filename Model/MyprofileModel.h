//
//  MyprofileModel.h
//  RedScarf
//
//  Created by lishipeng on 15/12/12.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSModel.h"

@interface MyprofileModel : RSModel
//标题
@property(nonatomic, strong) NSString *title;
//图片
@property(nonatomic, strong) NSString *imgName;
//需要跳转的vc的名字
@property(nonatomic, strong) NSString *vcName;


-(instancetype) initWithTitle:(NSString *)titile icon:(NSString *)imgName vcName:(NSString *)vcName;
@end
