//
//  RSSingleTitleModel.m
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSSingleTitleModel.h"

@implementation RSSingleTitleModel
- (id)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] init];
        
        self.str = attriString;
    }
    
    return self;
}
@end
