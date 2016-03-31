//
//  MyprofileModel.h
//  RedScarf
//
//  Created by lishipeng on 15/12/12.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "MenuModel.h"

@interface MyprofileModel : MenuModel<MTLJSONSerializing>

@property(nonatomic, strong) NSAttributedString *subtitle;

-(instancetype) initWithTitle:(NSString *)titile icon:(NSString *)imgName vcName:(NSString *)vcName;
@end
