//
//  DetailTroubleViewController.m
//  RedScarf
//
//  Created by 李江 on 16/3/25.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "DetailTroubleViewController.h"

@interface DetailTroubleViewController ()
{
    UILabel *_tipLabel;
    UIButton *_submitBtn;
    UIButton *_cancelBtn;
}
@property (nonatomic, strong)UITextView *textView;

@end

@implementation DetailTroubleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = YES;
        
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(0, 0, 60, 44);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    _cancelBtn.titleLabel.textColor = [UIColor redColor];
    
    _cancelBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
     [_cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[_cancelBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    _submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _submitBtn.frame = CGRectMake(0, 0, 60, 44);
    [_submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    [_submitBtn setTitleColor:textcolor forState:UIControlStateNormal];
    _submitBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [[_submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        if (!self.firstReasonCode) {
            [self showToast:@"一级原因不能为空"];
            return ;
        }
        if (_textView.text.length==0) {
            [self showToast:@"请输入未送达原因"];
            return;
        }

        [self beginHttpRequest];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_submitBtn];
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 74, kUIScreenWidth-20, 200)];
    _textView.text = self.placeholderText;
    self.automaticallyAdjustsScrollViewInsets = NO;
    _textView.delegate = self;
    
    _tipLabel = [[UILabel alloc]init];
    _tipLabel.top = _textView.bottom + 5;
    _tipLabel.left = kUIScreenWidth - 50 - 10;
    _tipLabel.height = 30;
    _tipLabel.width = 50;
    _tipLabel.textAlignment = NSTextAlignmentRight;
    _tipLabel.textColor = [UIColor lightGrayColor];
    _tipLabel.font = [UIFont systemFontOfSize:14];
    _tipLabel.text = [NSString stringWithFormat:@"%zd/%zd",_textView.text.length,self.textMaxLength];
    [self.view addSubview:_tipLabel];

    [[_textView rac_textSignal] subscribeNext:^(NSString* text) {
        _textView.text = text;
        if (text.length > self.textMaxLength) {
            [self showToast:[NSString stringWithFormat:@"最多输入%zd个字",self.textMaxLength]];
        }
        _tipLabel.text = [NSString stringWithFormat:@"%zd/%zd",text.length,self.textMaxLength];
        
    }];
    
    [self.view addSubview:_textView];
    
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_cancelBtn];
    [_cancelBtn setTitleColor:textcolor forState:UIControlStateNormal];
    [_submitBtn setTitleColor:textcolor forState:UIControlStateNormal];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
    _textView.text = _textView.text.length == 0 ? self.placeholderText : _textView.text;
    _tipLabel.text = [NSString stringWithFormat:@"%zd/%zd",_textView.text.length,self.textMaxLength];

}

-(void)beforeHttpRequest{
    [super beforeHttpRequest];
    [self.params setObject:self.sns forKey:@"sns"];
    [self.params setObject:_textView.text forKey:@"reason"];
    [self.params setObject:self.firstReasonCode forKey:@"firstReason"];

}

- (void)afterHttpSuccess:(NSDictionary *)data{
    [super afterHttpSuccess:data];
    NSString * code = [data objectForKey:@"code"];
    if ([code integerValue] == 0) {
        [self showToast:@"提交成功"];
        
        if (self.submitDelegate && [self.submitDelegate respondsToSelector:@selector(submitSuccess)]) {
            [self.submitDelegate submitSuccess];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self showToast:@"提交失败"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(void)textViewDidBeginEditing:(UITextView *)textView{
    if ([_textView.text isEqualToString:self.placeholderText]) {
        _textView.text = @"";
    }
    
    _tipLabel.text = [NSString stringWithFormat:@"%zd/%zd",textView.text.length,self.textMaxLength];
}

@end
