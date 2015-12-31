//
//  RSRadioGroup.h
//  RedScarf
//
//  Created by lishipeng on 15/12/30.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RSRadioGroup : NSObject

@property(nonatomic, strong) NSMutableArray *objArr;
@property(nonatomic) NSInteger selectedIndex;

-(void) addObj:(id) obj;

@end
