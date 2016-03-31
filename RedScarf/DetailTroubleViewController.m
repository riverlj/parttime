//
//  DetailTroubleViewController.m
//  RedScarf
//
//  Created by 李江 on 16/3/25.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "DetailTroubleViewController.h"
#import "RSPlaceHolderTextView.h"

@interface DetailTroubleViewController ()
{
    UILabel *_tipLabel;
    UIButton *_submitBtn;
    UIButton *_cancelBtn;
}
@property (nonatomic, strong)RSPlaceHolderTextView *textView;

@end

@implementation DetailTroubleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.hidden = YES;
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelBtn.frame = CGRectMake(0, 0, 60, 44);
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    
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
        if (_textView.text.length > self.textMaxLength) {
            [self showToast:[NSString stringWithFormat:@"最多显示%zd个字",self.textMaxLength]];
            return;
        }

        [self beginHttpRequest];
    }];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:_submitBtn];
    
    _textView = [[RSPlaceHolderTextView alloc]initWithFrame:CGRectMake(10, 74, kUIScreenWidth-20, 200)];
    _textView.placeholder = self.placeholderText;
    _textView.textColor = color155;
    _textView.textAlignment = NSTextAlignmentLeft;
    _textView.font = textFont14;
    _textView.layer.borderWidth = 0.8;
    _textView.layer.borderColor = [color_gray_cccccc CGColor];
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 5;
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _tipLabel = [[UILabel alloc]init];
    _tipLabel.top = _textView.bottom + 5;
    _tipLabel.left = kUIScreenWidth - 50 - 10;
    _tipLabel.height = 30;
    _tipLabel.width = 50;
    _tipLabel.textAlignment = NSTextAlignmentRight;
    _tipLabel.textColor = color_black_666666;
    _tipLabel.font = [UIFont systemFontOfSize:14];
    _tipLabel.text = [NSString stringWithFormat:@"%zd/%zd",_textView.text.length,self.textMaxLength];
    [self.view addSubview:_tipLabel];

    [[_textView rac_textSignal] subscribeNext:^(NSString* text) {
        _textView.text = text;
        _tipLabel.text = [NSString stringWithFormat:@"%zd/%zd",text.length,self.textMaxLength];
        if (text.length > self.textMaxLength) {
            NSString *text = _tipLabel.text;
            NSMutableAttributedString *attr = [[NSMutableAttributedString alloc]initWithString:_tipLabel.text];
            NSRange range = [text rangeOfString:@"/50"];
            [attr addAttribute:NSForegroundColorAttributeName value:color_red_e54545 range:NSMakeRange(0, range.location)
             ];
            [_tipLabel setAttributedText:attr];
        }
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
}

-(void)beforeHttpRequest{
    [super beforeHttpRequest];
    [self.params setValue:self.sns forKey:@"sns"];
    [self.params setValue:_textView.text forKey:@"reason"];
    [self.params setValue:self.firstReasonCode forKey:@"firstReason"];

}

- (void)afterHttpSuccess:(NSDictionary *)data{
    [super afterHttpSuccess:data];
    [self showToast:@"提交成功"];
    if (self.submitDelegate && [self.submitDelegate respondsToSelector:@selector(submitSuccess)]) {
        [self.submitDelegate submitSuccess];
        [self dismissViewControllerAnimated:YES completion:nil];
    }else {
        [self showToast:@"提交失败"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
