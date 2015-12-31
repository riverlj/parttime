//
//  RSRadioGroup.m
//  RedScarf
//
//  Created by lishipeng on 15/12/30.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSRadioGroup.h"

@implementation RSRadioGroup



-(void) setSelectedIndex:(NSInteger)selectedIndex
{
    NSInteger max = [self.objArr count];
    if(selectedIndex > max) {
        selectedIndex = max;
    }
    if(selectedIndex < 0) {
        selectedIndex = 0;
    }
    _selectedIndex= selectedIndex;
    //在选中的同时，去选择相应的组件
    if(max > 0) {
        NSInteger i = 0;
        for(id obj in self.objArr) {
            if([obj respondsToSelector:@selector(setSelected:)]) {
                if(i == selectedIndex) {
                    [obj setSelected:TRUE];
                }else {
                    [obj setSelected:FALSE];
                }
                i++;
            }
        }
    }
}

-(void) addObj:(id)obj
{
    [self.objArr addObject:obj];
}

-(NSMutableArray *) objArr
{
    if(_objArr) {
        return _objArr;
    }
    _objArr = [[NSMutableArray alloc] init];
    return _objArr;
}

@end
