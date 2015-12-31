//
//  RSSingleTitleCell.m
//  RedScarf
//
//  Created by lishipeng on 15/12/28.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSSingleTitleCell.h"
#import "RSSingleTitleModel.h"

@implementation RSSingleTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

-(void) setModel:(RSModel *)model
{
    [super setModel:model];
    if([model isKindOfClass:[RSSingleTitleModel class]]) {
        RSSingleTitleModel *titleModel = (RSSingleTitleModel *)model;
        self.textLabel.attributedText = titleModel.str;
    }
}

@end
