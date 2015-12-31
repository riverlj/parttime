//
//  UserTaskTableViewCell.m
//  RedScarf
//
//  Created by lishipeng on 15/12/31.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "UserTaskTableViewCell.h"
#import "RoomTaskTableViewCell.h"
#import "Model.h"


@implementation UserTaskTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 12, kUIScreenWidth, 16)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = MakeColor(75, 75, 75);
        [self.contentView addSubview:self.titleLabel];
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(5, 40, kUIScreenWidth - 5, 0.5)];
        [line setBackgroundColor:color155];
        [self.contentView addSubview:line];
    }
    return self;
}

-(void)setDelegate:(UITableViewController *)delegate
{
    _delegate = delegate;
    for(UIView * subView in [self.contentView subviews]) {
        if([subView isKindOfClass:[RoomTaskTableViewCell class]]) {
            ((RoomTaskTableViewCell *) subView).delegate = delegate;
        }
    }
}

-(void) setModel:(RSModel *)model
{
    [super setModel:model];
    if([model isKindOfClass:[Model class]]) {
        Model *m = (Model *)model;
        self.titleLabel.text = [NSString stringWithFormat:@"%@%@", m.username, m.mobile];
        CGFloat bottom = self.titleLabel.bottom+12;
        for(NSDictionary *dic in m.tasksArr) {
            Model *temp = [[Model alloc]init];
            temp.cellClassName = @"RoomTaskTableViewCell";
            temp.apartmentName = [dic objectForKey:@"apartmentName"];
            temp.taskNum = [dic objectForKey:@"taskNum"];
            temp.aId = [dic objectForKey:@"apartmentId"];
            RoomTaskTableViewCell *cell = [[RoomTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:temp.cellClassName];
            [cell setModel:temp];
            cell.width = kUIScreenWidth;
            cell.top = bottom;
            cell.delegate = self.delegate;
            bottom += cell.height;
            [self.contentView addSubview:cell];
        }
        self.height = bottom;
    }
}
@end
