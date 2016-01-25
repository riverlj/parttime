//
//  RSTableViewCell.m
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSTableViewCell.h"

@implementation RSTableViewCell

-(void) setModel:(RSModel *)model
{
    _model = model;
    self.isSelectable = model.isSelectable;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    
    for (UILabel *label in self.contentView.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.highlighted = highlighted;
        }
    }
    for (UILabel *label in self.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            label.highlighted = highlighted;
        }
    }
    
    self.textLabel.highlighted = highlighted;
    self.detailTextLabel.highlighted = highlighted;
}

- (id)initWithStyle:(UITableViewCellStyle)style {
    self = [self initWithStyle:style reuseIdentifier:[[self class] description]];
    return self;
}

- (id)init {
    return [self initWithStyle:UITableViewCellStyleDefault];
}
@end
