//
//  RSHomeButton.m
//  RedScarf
//
//  Created by lishipeng on 15/12/14.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSMenuButton.h"

@implementation RSMenuButton
-(instancetype) init
{
    self = [super init];
    if(self) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:self.label];
        [self addSubview:self.image];
        [self.layer setBorderWidth:0.5]; //边框宽度
        UIColor *color = color_gray_e8e8e8;
        [self.layer setBorderColor:color.CGColor]; //边框颜色
    }
    return self;
}

-(UILabel *)label
{
    if(_label) {
        return _label;
    }
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, 0, self.width, 14);
    _label.font = textFont14;
    _label.textColor = color155;
    _label.textAlignment = NSTextAlignmentCenter;
    return _label;
}

-(UIImageView *)image
{
    if(_image) {
        return _image;
    }
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    return _image;
}

-(UIImageView *)circleView
{
    if(_circleView) {
        return _circleView;
    }
    _circleView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    _circleView.layer.cornerRadius = 6;
    _circleView.layer.masksToBounds = YES;
    _circleView.backgroundColor = colorrede5;
    return _circleView;
}

-(void) layoutSubviews
{
    self.image.width = self.width/3;
    self.image.height = self.height/3;
    self.image.left = (self.width - self.image.width)/2;
    self.image.top = (self.height - self.image.height - self.label.height - self.height/10)/2;
    self.label.top = self.image.bottom + self.height/10;
    self.label.width = self.width;
    self.circleView.right = self.width - 18;
    self.circleView.top = 18;

}

-(void)setMenuModel:(MenuModel *)menuModel{
    _menuModel = menuModel;
    
    self.label.text = _menuModel.title;
    if([_menuModel.imgName hasPrefix:@"http://"]) {
        [self.image sd_setImageWithURL:[NSURL URLWithString:_menuModel.imgName]];
    } else {
        self.image.image = [UIImage imageNamed:_menuModel.imgName];
    }
}

-(void) setRedPot:(BOOL)redPot
{
    _redPot = redPot;
    if(_redPot) {
        if(![self.circleView superview]) {
            [self addSubview:self.circleView];
        }
    } else {
        if([self.circleView superview]) {
            [self.circleView removeFromSuperview];
        }
    }
}

@end
