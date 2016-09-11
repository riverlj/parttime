//
//  RSTwoTitleCell.m
//  RedScarf
//
//  Created by 李江 on 16/8/22.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSTwoTitleCell.h"
#import "RSTwoTitleModel.h"

@implementation RSTwoTitleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.oneLabelLabel = [[UILabel alloc] init];
        self.oneLabelLabel.font = Font(15);
        [self.contentView addSubview:self.oneLabelLabel];
        
        self.twotitleLabel = [[UILabel alloc]init];
        self.twotitleLabel.font = Font(15);
        [self.contentView addSubview:self.twotitleLabel];
    }
    return self;
}

-(void)setModel:(RSModel *)model {
    if ([model isKindOfClass:RSTwoTitleModel.class]) {
        RSTwoTitleModel *twotitleModel = (RSTwoTitleModel *)model;
        self.oneLabelLabel.text = twotitleModel.onetitle;
        self.twotitleLabel.text = twotitleModel.twotitle;
    }
}

@end
