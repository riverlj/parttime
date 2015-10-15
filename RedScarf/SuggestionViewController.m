//
//  SuggestionViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/15.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "SuggestionViewController.h"

@interface SuggestionViewController ()

@end

@implementation SuggestionViewController
{
    UITextView *suggestionView;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    self.tabBarController.tabBar.hidden = YES;
    [self navigationBar];
    [self initView];
    
}
-(void)navigationBar
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comeback"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
//    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDone)];
//    right.tintColor = [UIColor whiteColor];
//    self.navigationItem.rightBarButtonItem = right;
    
    //隐藏tabbar上的按钮
    UIButton *barBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [barBtn removeFromSuperview];
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)initView
{
   UILabel * view = [[UILabel alloc] initWithFrame:CGRectMake(25, 85, kUIScreenWidth-50, 40)];
    view.text = @"请输入内容。。";
    view.tag = 20001;
    view.font = [UIFont systemFontOfSize:14];
    view.textColor = MakeColor(75 , 75, 75);
    [self.view addSubview:view];
    
    suggestionView = [[UITextView alloc] initWithFrame:CGRectMake(20, 80, kUIScreenWidth-40, 150)];
    suggestionView.delegate = self;
    suggestionView.text=view.text;
    suggestionView.selectedRange=NSMakeRange(0,0) ;   //起始位置
    suggestionView.selectedRange=NSMakeRange(view.text.length,0);
    [self.view addSubview:suggestionView];
    suggestionView.layer.borderWidth = 0.8;
    suggestionView.layer.borderColor = MakeColor(203, 203, 203).CGColor;
    suggestionView.layer.masksToBounds = YES;
    
    suggestionView.layer.cornerRadius = 5;
    
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
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    [params setObject:@"2" forKey:@"source"];
    suggestionView.text = [suggestionView.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [params setObject:suggestionView.text forKey:@"content"];
    [RedScarf_API requestWithURL:@"/user/feedbackAdvice" params:params httpMethod:@"POST" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            [self alertView:@"提交成功"];
            suggestionView.text = @"";
        }else
        {
            [self alertView:[result objectForKey:@"msg"]];
        }
    }];

}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([suggestionView.text isEqualToString:@"\n"])
    {
        NSLog(@"DDDDDDDD  ==  %@",suggestionView.text);
        [suggestionView resignFirstResponder];
        return NO;
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
