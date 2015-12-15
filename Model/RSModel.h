//
//  RSModel.h
//  RedScarf
//
//  Created by lishipeng on 15/12/8.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Mantle.h"

@interface RSModel : MTLModel{
    NSString *_cellClassName;
    int _cellHeight;
    SEL _selectAction;
    __weak id _target;
}
@property (nonatomic,copy)NSString *cellClassName;
@property (nonatomic,assign)int cellHeight;
@property (nonatomic) BOOL isSelectable;
@property (nonatomic) int itemid;

- (void)setSelectAction:(SEL)selectAction target:(id)target;
- (int)cellHeightWithWidth:(int)width;
-(NSString *)getClassName;
-(id) getTarget;
-(SEL) getSelectAction;
@end
