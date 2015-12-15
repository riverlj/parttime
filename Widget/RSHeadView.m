//
//  RSHeadView.m
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSHeadView.h"
#import "RSAccountModel.h"
#import "UIImageView+AFNetworking.h"


#define  HEAD_POSTIONVIEW_WIDTH 24
#define  HEAD_POSTIONVIEW_HEIGHT 12

@implementation RSHeadView

-(instancetype) init
{
    self = [super init];
    if(self) {
        [self addSubview:self.headimgView];
        [self reload];
    }
    return self;
}

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.headimgView];
        [self reload];
    }
    return self;
}

-(void) reload
{
    RSAccountModel *model = [RSAccountModel sharedAccount];
    if([model isValid]) {
        [self.headimgView setImageWithURL:[NSURL URLWithString:model.headImg] placeholderImage:[UIImage imageNamed:@"touxiang"]];
        if([model isCEO]) {
            if(![self.positionView superview]) {
                [self addSubview:self.positionView];
            }
        } else {
            if([self.positionView superview]) {
                [self.positionView removeFromSuperview];
            }
        }
    }
    [self resize];
}

-(void) setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self resize];
}

//后新设置大小
-(void)resize
{
    self.headimgView.frame = self.bounds;
    self.positionView.frame = CGRectMake( (self.width - HEAD_POSTIONVIEW_WIDTH)/2, self.height - HEAD_POSTIONVIEW_HEIGHT, HEAD_POSTIONVIEW_WIDTH, HEAD_POSTIONVIEW_HEIGHT);
}

-(UIImageView *) headimgView
{
    if(_headimgView) {
        return _headimgView;
    }
    _headimgView = [[UIImageView alloc] initWithFrame:self.bounds];
    _headimgView.layer.cornerRadius = self.width/2;
    _headimgView.layer.masksToBounds = YES;
    _headimgView.image = [UIImage imageNamed:@"touxiang"];
    return _headimgView;
}

-(UILabel *) positionView
{
    if(_positionView) {
        return _positionView;
    }
    _positionView = [[UILabel alloc] init];
    _positionView.backgroundColor = colorblue;
    _positionView.layer.cornerRadius = 3;
    _positionView.textAlignment = NSTextAlignmentCenter;
    _positionView.layer.masksToBounds = YES;
    _positionView.text = @"ceo";
    _positionView.textColor = [UIColor whiteColor];
    _positionView.font = textFont12;
    return _positionView;
}

@end
