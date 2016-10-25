//
//  roomTaskCell.m
//  RedScarf
//
//  Created by 李江 on 16/10/24.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "roomTaskCell.h"

@implementation roomTaskCell
{
    UIView *_contensView;
    UIView *_blankView;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self) {
        self.roomNameLabel = [[UILabel alloc] init];
        self.roomNameLabel.textColor = RS_THRME_COLOR;
        self.roomNameLabel.font = textFont15;
        [self.contentView addSubview:self.roomNameLabel];
        
        self.numTaskLabel =  [[UILabel alloc] init];
        self.numTaskLabel.textColor = rs_color_ffa53a;
        self.numTaskLabel.font = textFont12;
        [self.contentView addSubview:self.numTaskLabel];
        
        self.detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.detailBtn setTitle:@"详情" forState:UIControlStateNormal];
        [self.detailBtn setTitle:@"详情" forState:UIControlStateHighlighted];
        self.detailBtn.titleLabel.font = textFont14;
        [self.detailBtn setTitleColor:RS_THRME_COLOR forState:UIControlStateNormal];
        [self.detailBtn setTitleColor:RS_THRME_COLOR forState:UIControlStateHighlighted];
        [self.detailBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
        [self.detailBtn addTarget:self action:@selector(detailBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

        [self.contentView addSubview:self.detailBtn];
        
        self.sendedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendedBtn.backgroundColor = RS_THRME_COLOR;
        [self.sendedBtn setTitle:@"送达" forState:UIControlStateNormal];
        [self.sendedBtn setTitle:@"送达" forState:UIControlStateHighlighted];
        self.sendedBtn.titleLabel.textColor = [UIColor whiteColor];
        self.sendedBtn.titleLabel.font = textFont15;
        self.sendedBtn.layer.cornerRadius = 4;
        self.sendedBtn.layer.masksToBounds = YES;
        [self.sendedBtn addTarget:self action:@selector(sendedBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.contentView addSubview:self.sendedBtn];
        
        UIView *lineView = [RSLineView lineViewHorizontal];
        lineView.x = 15;
        lineView.y = 43;
        lineView.width = SCREEN_WIDTH - 30;
        [self.contentView addSubview:lineView];
        
        _contensView = [[UIView alloc] init];
        [self.contentView addSubview:_contensView];
        
        _blankView = [[UIView alloc] init];
        _blankView.backgroundColor = RS_COLOR_BACKGROUND;
        [self.contentView addSubview:_blankView];
    }
    
    return self;
}

-(void)setModel:(RoomTaskModel *)model {
    
    self.taskModel = model;
    
    self.roomNameLabel.text = model.room;
    CGSize roomSize =  [self.roomNameLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.numTaskLabel.text = [NSString stringWithFormat:@"(%@份)", model.taskNum];
    CGSize numTaskSize =  [self.numTaskLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    self.roomNameLabel.frame = CGRectMake(15, 0, roomSize.width, 43);
    self.numTaskLabel.frame = CGRectMake(self.roomNameLabel.right + 2, 0, numTaskSize.width, 43);
    self.numTaskLabel.bottom = self.roomNameLabel.bottom;
    
    self.detailBtn.frame = CGRectMake(SCREEN_WIDTH-15-75, 0, 75, 43);
    
    CGFloat tmpHeight = 0;
    
    [_contensView removeAllSubviews];
    for (int i=0; i<model.content.count; i++) {
        UILabel *tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, (SCREEN_WIDTH-30)/4 , 44)];
        tagLabel.textAlignment = NSTextAlignmentLeft;
        tagLabel.textColor = rs_color_222222;
        tagLabel.numberOfLines = 0;
        tagLabel.font = textFont13;
        [_contensView addSubview:tagLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(tagLabel.right, 0, 2*(SCREEN_WIDTH-30)/4, 0)];
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.textColor = rs_color_222222;
        contentLabel.font = textFont12;
        contentLabel.numberOfLines = 1;
        [_contensView addSubview:contentLabel];
        
        UILabel *numLabel = [[UILabel alloc] initWithFrame:CGRectMake(contentLabel.right, 0, (SCREEN_WIDTH-30)/4 , 0)];
        numLabel.textColor = rs_color_222222;
        numLabel.font = textFont13;
        numLabel.textAlignment = NSTextAlignmentRight;
        [_contensView addSubview:numLabel];
        
        RoomContentModel *roomContentModel = model.content[i];
        tagLabel.text = roomContentModel.tag;
        contentLabel.text = roomContentModel.content;
        numLabel.text = [NSString stringWithFormat:@"%@",roomContentModel.count];
        
        CGSize contentSize = [contentLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        CGSize tagLabelSize = [contentLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        CGFloat height = 0;
        if (tagLabelSize.height > contentSize.height) {
            height = tagLabelSize.height;
        }else {
            height = contentSize.height;
        }
        
        tagLabel.height = height + 34;
        contentLabel.height = height + 34;
        numLabel.height = height + 34;
        
        tagLabel.y =  tmpHeight;
        contentLabel.y = tmpHeight;
        numLabel.y = tmpHeight;
        
        UIView *lview = [RSLineView lineViewHorizontal];
        lview.x = 15;
        lview.width = SCREEN_WIDTH - 30;
        lview.y = tagLabel.bottom-1;
        [_contensView addSubview:lview];
        
        tmpHeight = tagLabel.bottom;
    }
    
    _contensView.frame = CGRectMake(0, 44, SCREEN_WIDTH, tmpHeight);
    
    self.sendedBtn.frame = CGRectMake(SCREEN_WIDTH-165, _contensView.bottom + 10, 150, 30);
    
    _blankView.frame = CGRectMake(0, self.sendedBtn.bottom + 10, SCREEN_WIDTH, 6);
    model.cellHeight = _blankView.bottom;
    
}

-(void)detailBtnClicked:(UIButton *)sender {
    if (self.cellEventDelegate && [self.cellEventDelegate respondsToSelector:@selector(detailBtnEvent:)]) {
        [self.cellEventDelegate detailBtnEvent:self.taskModel];
    }
}

-(void)sendedBtnClicked:(UIButton *)sender {
    if (self.cellEventDelegate && [self.cellEventDelegate respondsToSelector:@selector(sendedBtnEvent:)]) {
        [self.cellEventDelegate sendedBtnEvent:self.taskModel];
    }
}

@end
