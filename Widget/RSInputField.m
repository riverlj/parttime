//
//  RSInputField.m
//  RedScarf
//
//  Created by lishipeng on 16/1/13.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSInputField.h"

@implementation RSInputField

-(instancetype) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self addSubview:self.textField];
        [self addSubview:self.sepLine];
    }
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.textField.height = self.height;
    self.leftView.height = self.height;
    self.iconView.centerX = (self.leftView.width - 13)/2;
    self.sepLine.left = self.iconView.right + 13;
    self.sepLine.centerY = self.height/2;
    self.iconView.centerY = self.leftView.height/2;
    self.textField.left = 0;
    self.textField.width = self.width;
}

-(UIImageView *)iconView
{
    if(_iconView) {
        return _iconView;
    }
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    return _iconView;
}

-(UIView *) leftView
{
    if(_leftView) {
        return _leftView;
    }
    _leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 58, 59)];
    [_leftView addSubview:self.iconView];
    return _leftView;
}

-(UITextField *) textField
{
    if(_textField) {
        return _textField;
    }
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(self.leftView.width, 0, self.width - self.leftView.width, self.height)];
    _textField.leftView = self.leftView;
    _textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _textField.leftViewMode = UITextFieldViewModeAlways;
    return _textField;
}

-(UIImageView *) sepLine
{
    if(_sepLine) {
        return _sepLine;
    }
    _sepLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0.5, 16)];
    [_sepLine setBackgroundColor:color_gray_e8e8e8];
    return _sepLine;
}

@end
