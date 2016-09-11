//
//  RSSingleTitleModel.h
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSModel.h"

@interface RSSingleTitleModel : RSModel
@property(nonatomic, strong) NSAttributedString *str;

@property (nonatomic ,strong)NSString *onetitle;


- (id)initWithTitle:(NSString *)title;
@end
