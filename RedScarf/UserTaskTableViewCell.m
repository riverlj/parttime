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
        self.backgroundColor = color_gray_f3f5f7;
        self.bgView = [[UIImageView alloc]initWithFrame:CGRectMake(18, 0, kUIScreenWidth-36, 48)];
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.masksToBounds = YES;
        [self.bgView setBackgroundColor:[UIColor whiteColor]];
        self.bgView.userInteractionEnabled = YES;
        [self.contentView addSubview:self.bgView];
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 16, 3, 16)];
        [lineView setBackgroundColor:color_blue_5999f8];
        [self.bgView addSubview:lineView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(lineView.right + 5, lineView.top, 200, 16)];
        self.titleLabel.textAlignment = NSTextAlignmentLeft;
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = color_black_222222;
        [self.bgView addSubview:self.titleLabel];
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(18, 48, self.width - 36, 0.5)];
        [line setBackgroundColor:color_gray_e8e8e8];
        [self.bgView addSubview:line];
    }
    return self;
}

-(void)setDelegate:(UITableViewController *)delegate
{
    _delegate = delegate;
    for(UIView * subView in [self.bgView subviews]) {
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
        NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  textFont16, NSFontAttributeName,
                                  color_black_666666, NSForegroundColorAttributeName, nil];
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@ %@", m.username, m.mobile] attributes:attrDict];
        [attrStr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:color_black_222222, NSForegroundColorAttributeName, textFont16, NSFontAttributeName, nil] range:NSMakeRange(0, [m.username length])];
        
        [attrStr setAttributes:[NSDictionary dictionaryWithObjectsAndKeys:colorblue, NSForegroundColorAttributeName, textFont16, NSFontAttributeName, nil] range:NSMakeRange(attrStr.length-m.mobile.length, m.mobile.length)];
        
        self.titleLabel.attributedText = attrStr;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(phoneNumberClicked:)];
        self.titleLabel.userInteractionEnabled = YES;
        [self.titleLabel addGestureRecognizer:tap];
        
        CGFloat bottom = self.titleLabel.bottom+16;
        [self clearSubCell];
        for(NSDictionary *dic in m.tasksArr) {
            Model *temp = [[Model alloc]init];
            temp.cellClassName = @"RoomTaskTableViewCell";
            temp.apartmentName = [dic objectForKey:@"apartmentName"];
            temp.taskNum = [dic objectForKey:@"taskNum"];
            temp.aId = [dic objectForKey:@"apartmentId"];
            temp.userId = m.userId;
            RoomTaskTableViewCell *cell = [[RoomTaskTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:temp.cellClassName];
            cell.width = self.bgView.width;
            [cell setModel:temp];
            cell.width = kUIScreenWidth;
            cell.top = bottom;
            cell.delegate = self.delegate;
            bottom += cell.height;
            [self.bgView addSubview:cell];
        }
        self.bgView.height = bottom;
        self.height = self.bgView.height + 18;
    }
}

//清除subcell
-(void) clearSubCell
{
    self.bottom = self.titleLabel.bottom + 16;
    for(UIView * view in self.bgView.subviews) {
        if([view isKindOfClass:[RSTableViewCell class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)phoneNumberClicked:(UIGestureRecognizer *)sender{
    UILabel *nameAndPhoneLable = (UILabel *)sender.view;
    NSString *nameAndPhoneStr = nameAndPhoneLable.text;
    NSString *phoneStr = [nameAndPhoneStr substringWithRange:NSMakeRange(nameAndPhoneStr.length - 11, 11)];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"telprompt://%@", phoneStr]]];
}

@end
