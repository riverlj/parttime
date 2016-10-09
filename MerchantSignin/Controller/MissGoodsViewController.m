//
//  MissGoodsViewController.m
//  RedScarf
//
//  Created by 李江 on 16/10/8.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "MissGoodsViewController.h"
#import "RSPlaceHolderTextView.h"
#import "MerChantSignInModel.h"

@interface MissGoodsViewController ()<UITextViewDelegate>
{
    RSPlaceHolderTextView *suggestionView;
    UIButton *submitBtn;
}
@end

@implementation MissGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"餐品遗漏";
    
    suggestionView = [[RSPlaceHolderTextView alloc] initWithFrame:CGRectMake(20, 20, kUIScreenWidth-40, 150)];
    suggestionView.delegate = self;
    suggestionView.placeholder= @"填写错漏餐品的种类，数量(300字内)";
    suggestionView.textColor = color155;
    suggestionView.textAlignment = NSTextAlignmentLeft;
    suggestionView.font = textFont14;
    suggestionView.layer.borderWidth = 0.8;
    suggestionView.layer.borderColor = MakeColor(203, 203, 203).CGColor;
    suggestionView.layer.masksToBounds = YES;
    suggestionView.layer.cornerRadius = 6;
    [self.tableView addSubview:suggestionView];
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    submitBtn.enabled = NO;
    submitBtn.frame = CGRectMake(20, suggestionView.frame.size.height+suggestionView.frame.origin.y+20, kUIScreenWidth-40, 45);
    [submitBtn setTitle:@"确认" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    submitBtn.layer.masksToBounds = YES;
    submitBtn.layer.cornerRadius = 5;
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    submitBtn.backgroundColor = MakeColor(85, 130, 255);
    [self.tableView addSubview:submitBtn];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];

    
    self.tableView.tableFooterView = [UIView new];
}

- (void)submit:(UIButton *)sender {
    if (suggestionView.text.length > 300) {
        [[RSToastView shareRSToastView]showToast:@"最多输入300字"];
        return;
    }
    if (suggestionView.text.length == 0) {
        [[RSToastView shareRSToastView]showToast:@"餐品内容不能为空"];
        return;
    }
    NSDictionary *params = @{
                             @"goodsid" : self.goodsid,
                             @"rate" : suggestionView.text
                             };
    
    __weak MissGoodsViewController *selfB = self;
    [MerChantSignInModel sendMissGood:params success:^{
        [selfB.navigationController popViewControllerAnimated:YES];
    } failure:^{
        
    }];
}

-(void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        submitBtn.enabled = YES;
    }else {
        submitBtn.enabled = NO;
    }
}



@end
