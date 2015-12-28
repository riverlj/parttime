//
//  SuggestionViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/15.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "SuggestionViewController.h"
#import "RSPlaceHolderTextView.h"

@interface SuggestionViewController ()

@end

@implementation SuggestionViewController
{
    RSPlaceHolderTextView *suggestionView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self comeBack:nil];
    self.title = @"意见反馈";
    if ([self respondsToSelector:@selector(setAutomaticallyAdjustsScrollViewInsets:)]) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    [self initView];
}

-(void)initView
{
    suggestionView = [[RSPlaceHolderTextView alloc] initWithFrame:CGRectMake(20, 80, kUIScreenWidth-40, 150)];
    suggestionView.delegate = self;
    suggestionView.placeholder= @"请输入您的问题,200字以内。";
    suggestionView.textColor = color155;
    suggestionView.textAlignment = NSTextAlignmentLeft;
    suggestionView.font = textFont14;
    suggestionView.layer.borderWidth = 0.8;
    suggestionView.layer.borderColor = MakeColor(203, 203, 203).CGColor;
    suggestionView.layer.masksToBounds = YES;
    suggestionView.layer.cornerRadius = 5;
    [self.view addSubview:suggestionView];

    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitBtn.frame = CGRectMake(20, suggestionView.frame.size.height+suggestionView.frame.origin.y+20, kUIScreenWidth-40, 45);
    [submitBtn setTitle:@"提交反馈" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 5;
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.backgroundColor = MakeColor(85, 130, 255);
    [self.view addSubview:submitBtn];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
}



-(BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    [textView resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

}

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    suggestionView.text = nil;
    return YES;
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [[self.view viewWithTag:20001] removeFromSuperview];
    CGRect frame = textView.frame;
    
    //键盘高度216
    int offset;
    if (kUIScreenHeigth == 480) {
        offset = frame.origin.y + 19 - (self.view.frame.size.width - 180.0);
        
    }else{
        offset = frame.origin.y + 19 - (self.view.frame.size.width - 110.0);
        
    }
    
    NSTimeInterval animationDuration = 0.30f;
    
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    
    [UIView setAnimationDuration:animationDuration];
    
    //将软键盘Y坐标向上移动offset个单位 以使下面显示软键盘显示
    if (offset > 0 )
        self.view.frame = CGRectMake(0, -offset, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
    
}

-(void)submit:(id)sender
{
    if ([suggestionView.text isEqualToString:@""]) {
        [self alertView:@"请输入内容"];
        return;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"2" forKey:@"source"];
    [params setObject:suggestionView.text forKey:@"content"];
    [RSHttp requestWithURL:@"/user/feedbackAdvice" params:params httpMethod:@"POST" success:^(NSDictionary *data) {
        suggestionView.text = @"";
        [suggestionView resignFirstResponder];
        [self showToast:@"提交成功"];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self showToast:errmsg];
    }];
}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([suggestionView.text isEqualToString:@"\n"])
    {
        [suggestionView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
