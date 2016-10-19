//
//  MyProtocol.h
//  RedScarf
//
//  Created by zhangb on 15/8/20.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MyProtocol <NSObject>
//返回地址界面的aId
-(void)returnAddress:(NSString *)address aId:(NSString *)aId;


@end
