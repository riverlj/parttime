//
//  SimulateActionSheet.m
//  SimulateActionSheet
//
//  Created by 张 聪 on 15/1/14.
//  Copyright (c) 2015年 张 聪. All rights reserved.
//

#import "SimulateActionSheet.h"
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RS_COLOR_C2 [NSString colorFromHexString:@"515151"]
#define RS_Background_Color [NSString colorFromHexString:@"f8f8f8"]
#define RS_COLOR_C3 [NSString colorFromHexString:@"7d7d7d"]
#define RS_FONT_F3 Font(14)


@interface SimulateActionSheet(){
    UIColor *toolBarColor;
    UIColor *textColorNormal;
    UIColor *textColorPressed;
    UIColor *pickerBgColor;
}
@end

@implementation SimulateActionSheet
+(instancetype)styleDefault{
    SimulateActionSheet* sheet = [[SimulateActionSheet alloc]initWithFrame:CGRectMake(
                                                                                     0,
                                                                                     0,
                                                                                     SCREEN_WIDTH,
                                                                                     SCREEN_HEIGHT)];
    
    [sheet setBackgroundColor:[UIColor clearColor]];
    sheet.toolBar = [sheet actionToolBar];
    sheet.pickerView = [sheet actionPicker];
    [sheet addSubview:sheet.toolBar];
    [sheet addSubview:sheet.pickerView];
    
    return sheet;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    if (self != nil) {
        toolBarColor = RS_Background_Color;
        textColorNormal = RGBACOLOR(0, 146.0, 255.0, 1);
        textColorPressed = RGBACOLOR(209.0, 213.0, 219.0, 0.9);
        pickerBgColor = [UIColor whiteColor];
    }
    
    return self;
}
-(void)setupInitPostion:(UIViewController *)controller{
    [UIApplication.sharedApplication.keyWindow?UIApplication.sharedApplication.keyWindow:UIApplication.sharedApplication.windows[0]
                                                                              addSubview:self];
    [self.superview bringSubviewToFront:self];
    CGFloat pickerViewYpositionHidden = UIScreen.mainScreen.bounds.size.height;
    [self.pickerView setFrame:CGRectMake(self.pickerView.frame.origin.x,
                                         pickerViewYpositionHidden,
                                         self.pickerView.frame.size.width,
                                         self.pickerView.frame.size.height)];
    [self.toolBar setFrame:CGRectMake(self.toolBar.frame.origin.x,
                                      pickerViewYpositionHidden,
                                      self.toolBar.frame.size.width,
                                      self.toolBar.frame.size.height)];
}
-(void)show:(UIViewController *)controller{
    [self setupInitPostion:controller];
    
    CGFloat toolBarYposition = UIScreen.mainScreen.bounds.size.height -
    (self.pickerView.frame.size.height + self.toolBar.frame.size.height);
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.5]];
                         [controller.view setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
                         [controller.navigationController.navigationBar setTintAdjustmentMode:UIViewTintAdjustmentModeDimmed];
                         
                         [self.toolBar setFrame:CGRectMake(self.toolBar.frame.origin.x,
                                                            toolBarYposition,
                                                            self.toolBar.frame.size.width,
                                                            self.toolBar.frame.size.height)];
                         
                         [self.pickerView setFrame:CGRectMake(self.pickerView.frame.origin.x,
                                                     toolBarYposition+self.toolBar.frame.size.height,
                                                     self.pickerView.frame.size.width,
                                                     self.pickerView.frame.size.height)];
                     }
                     completion:nil];

}
-(void)dismiss:(UIViewController *)controller{
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [self setBackgroundColor:[UIColor clearColor]];
                         [controller.view setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
                         [controller.navigationController.navigationBar setTintAdjustmentMode:UIViewTintAdjustmentModeNormal];
                         [self.subviews enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                             UIView* v = (UIView*)obj;
                             [v setFrame:CGRectMake(v.frame.origin.x,
                                                    UIScreen.mainScreen.bounds.size.height,
                                                    v.frame.size.width,
                                                    v.frame.size.height)];
                         }];
                     }
                     completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];

}

-(UIView *)actionToolBar{
    UIView *tools = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    tools.backgroundColor = toolBarColor;
    UIButton *cancle = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [cancle setTitle:@"取消" forState:UIControlStateNormal];
    [cancle setTitleColor:RS_COLOR_C2 forState:UIControlStateHighlighted];
    [cancle setTitleColor:RS_COLOR_C2 forState:UIControlStateNormal];
    [cancle addTarget:self action:@selector(actionCancle) forControlEvents:UIControlEventTouchUpInside];
    [cancle sizeToFit];
    [tools addSubview:cancle];
    
    cancle.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *cancleConstraintLeft = [NSLayoutConstraint constraintWithItem:cancle attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:tools attribute:NSLayoutAttributeLeading multiplier:1.0f constant:10.0f];
    NSLayoutConstraint *cancleConstrainY = [NSLayoutConstraint constraintWithItem:cancle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tools attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    NSLayoutConstraint *cancleConstrainW = [NSLayoutConstraint constraintWithItem:cancle attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:70];
    [cancle setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [tools addConstraint:cancleConstraintLeft];
    [tools addConstraint:cancleConstrainY];
    [tools addConstraint:cancleConstrainW];
    
    UILabel *tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    tipLabel.text = @"选择送达时间";
    tipLabel.font = RS_FONT_F3;
    tipLabel.textColor = RS_COLOR_C3;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [tools addSubview:tipLabel];
    
    UIButton *ok = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [ok setTitle:@"确定" forState:UIControlStateNormal];
    [ok setTitleColor:RS_THRME_COLOR forState:UIControlStateNormal];
    [ok setTitleColor:RS_THRME_COLOR forState:UIControlStateHighlighted];
    [ok addTarget:self action:@selector(actionDone) forControlEvents:UIControlEventTouchUpInside];
    [ok sizeToFit];
    [tools addSubview:ok];
    
    ok.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *okConstraintRight = [NSLayoutConstraint constraintWithItem:ok attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:tools attribute:NSLayoutAttributeTrailing multiplier:1.0f constant:-10.0f];
    NSLayoutConstraint *okConstraintY = [NSLayoutConstraint constraintWithItem:ok attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:tools attribute:NSLayoutAttributeCenterY multiplier:1.0f constant:0];
    
     NSLayoutConstraint *okConstraintW = [NSLayoutConstraint constraintWithItem:ok attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:70];
    [ok setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [tools addConstraint:okConstraintRight];
    [tools addConstraint:okConstraintY];
    [tools addConstraint:okConstraintW];
    

    return tools;
}

-(UIPickerView *)actionPicker;{
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 44, SCREEN_WIDTH, 216)];
    picker.showsSelectionIndicator=YES;
    [picker setBackgroundColor:pickerBgColor];
    
    return picker;
}

-(void)selectRow:(NSInteger)row inComponent:(NSInteger)component animated:(BOOL)anime{
    [_pickerView selectRow:row inComponent:component animated:anime];
}

-(NSInteger)selectedRowInComponent:(NSInteger)component{
    return [_pickerView selectedRowInComponent:component];
}

-(void)actionDone{
    if([_delegate respondsToSelector:@selector(actionDone)]){
        [_delegate actionDone];
    }
}

-(void)actionCancle{
    if ([_delegate respondsToSelector:@selector(actionCancle)]) {
        [_delegate actionCancle];
    }
}
-(void)setDelegate:(id<SimulateActionSheetDelegate>)delegate{
    _delegate = delegate;
    _pickerView.delegate = delegate;
}
@end
