//
//  RSTwoTitleCell.m
//  RedScarf
//
//  Created by 李江 on 16/8/22.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSTwoTitleCell.h"

@implementation RSTwoTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.subtitleLabel = [[UILabel alloc]init];
        self.subtitleLabel.font = Font(15);
    }
    return self;
}

@end
