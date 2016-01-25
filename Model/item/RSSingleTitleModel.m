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

-(int)cellHeight
{
    return 50;
}
/*@synthesize title = _title;
@synthesize font = _font;
@synthesize textColor = _textColor;
@synthesize textAlignment = _textAlignment;
- (id)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.title = title;
    }
    
    return self;
}
+ (id)itemWithTitle:(NSString *)title {
    return [self itemWithTitle:title font:Font(14)];
}
+ (id)itemWithTitle:(NSString *)title font:(UIFont *)font {
    RSSingleTitleModel *item = [[self alloc] initWithTitle:title];
    item.font = font;
    return item;
}
+ (id)itemWithTitle:(NSString *)title font:(UIFont *)font textColor:(UIColor *)textColor {
    RSSingleTitleModel *item = [self itemWithTitle:title font:font];
    item.textColor = textColor;
    return item;
}
- (int)cellHeightWithWidth:(int)width {
    if (_cellHeight == 0) {
        [_title sizeWithFont:_font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByTruncatingTail].height;
        //[_title boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesFontLeading attributes:(nullable NSDictionary<NSString *,id> *) context:(nullable NSStringDrawingContext *)];
    }
    return _cellHeight;
}*/
@end
