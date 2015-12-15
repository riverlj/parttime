//
//  RSModel.m
//  RedScarf
//
//  Created by lishipeng on 15/12/8.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSModel.h"

@implementation RSModel

-(NSString *) getClassName
{
    return [[self class] description];
}

-(void) setSelectAction:(SEL)selectAction target:(id)target
{
    _selectAction = selectAction;
    _target = target;
}

-(id) getTarget
{
    return _target;
}

-(SEL) getSelectAction
{
    return _selectAction;
}

- (int)cellHeightWithWidth:(int)width {
    return self.cellHeight;
}
- (NSString *)cellClassName {
    if (_cellClassName == nil) {
        _cellClassName = [[[[self class] description] stringByReplacingOccurrencesOfString:@"Model" withString:@"Cell"] copy];
    }
    return _cellClassName;
}

@end
