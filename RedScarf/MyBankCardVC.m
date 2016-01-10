//
//  MyBankCardVC.m
//  RedScarf
//
//  Created by zhangb on 15/9/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "MyBankCardVC.h"
#import "OpenAcountProvince.h"
@interface MyBankCardVC ()
{
    BOOL isEdited;
    NSInteger tag;
    NSString *url;
    UITextField *bankTf;
    UITextField *nameTf;
    UITextField *telTf;
    UIButton *proBtn,*cityBtn,*bankBtn,*bankChildBtn,*taskTypeBtn;
}

@end

@implementation MyBankCardVC

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self refreshView];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    isEdited = NO;
    self.title = @"我的银行卡";
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDone)];
    [self.navigationItem setRightBarButtonItem:right];
    [self initView];
    if(self.bankcard) {
        [self getMsgFromBranchBankId];
    } else {
        self.bankcard = [[RSBankCardModel alloc] init];
    }
}

-(void)getMsgFromBranchBankId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [self showHUD:@"正在加载"];
    [params setObject:[NSString stringWithFormat:@"%ld", self.bankcard.branchBankId] forKey:@"id"];
    [RSHttp payRequestWithURL:@"/bank/getBranchBankById" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSMutableDictionary *dic = [data objectForKey:@"body"];
        self.bankcard.provincename = [dic objectForKey:@"provincename"];
        self.bankcard.cityname = [dic objectForKey:@"cityname"];
        self.bankcard.cityid = [[dic objectForKey:@"cityid"]integerValue];
        self.bankcard.provinceid = [[dic objectForKey:@"provinceid"] integerValue];
        self.bankcard.branchBankName = [dic objectForKey:@"name"];
        self.bankcard.bankId = [[dic objectForKey:@"parentid"] integerValue];
        [self hidHUD];
        [self refreshView];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self showToast:errmsg];
    }];
}

-(void) refreshView
{
    bankTf.text = [self.bankcard showCardNum];
    nameTf.text = self.bankcard.realName;
    telTf.text = self.bankcard.phoneNumber;
    [cityBtn setTitle:self.bankcard.cityname forState:UIControlStateNormal];
    [proBtn setTitle:self.bankcard.provincename forState:UIControlStateNormal];
    [bankBtn setTitle:self.bankcard.bankName forState:UIControlStateNormal];
    [bankChildBtn setTitle:self.bankcard.branchBankName forState:UIControlStateNormal];
    NSString *str = self.bankcard.businessType == 0 ? @"对私业务" : @"对公业务";
    [taskTypeBtn setTitle:str forState:UIControlStateNormal];
}

-(void)initView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    scrollView.contentSize = CGSizeMake(0, kUIScreenHeigth*1.1);
    scrollView.userInteractionEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    [scrollView addTapAction:@selector(hideKeyboard) target:self];
    self.view = scrollView;
    
    UIView *headView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 25)];
    headView1.backgroundColor = MakeColor(244, 245, 246);
    [scrollView addSubview:headView1];
    
    UILabel *bankAcount = [[UILabel alloc] initWithFrame:CGRectMake(10, headView1.frame.size.height+headView1.frame.origin.y, 80, 45)];
    bankAcount.textAlignment = NSTextAlignmentCenter;
    bankAcount.text = @"银行账号:";
    [scrollView addSubview:bankAcount];
    
    bankTf = [[UITextField alloc] initWithFrame:CGRectMake(bankAcount.width+bankAcount.left, headView1.height+headView1.top, kUIScreenWidth-bankAcount.frame.size.width -15, 45)];
    bankTf.tag = 101;
    bankTf.delegate = self;
    bankTf.textColor = MakeColor(75, 75, 75);
    bankTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    bankTf.font = [UIFont systemFontOfSize:13];
    bankTf.keyboardType = UIKeyboardTypePhonePad;
    [scrollView addSubview:bankTf];
    
    UIView *headView2 = [[UIView alloc] initWithFrame:CGRectMake(0, bankTf.frame.size.height+bankTf.frame.origin.y, kUIScreenWidth, 35)];
    headView2.backgroundColor = MakeColor(244, 245, 246);
    [scrollView addSubview:headView2];
    
    UIImageView *personImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 2, 15)];
    personImageView.backgroundColor = colorblue;
    [headView2 addSubview:personImageView];
    
    UILabel *personLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 35)];
    personLabel.text = @"开户人";
    personLabel.font = textFont14;
    personLabel.textColor = colorblue;
    [headView2 addSubview:personLabel];
    
    nameTf = [[UITextField alloc] initWithFrame:CGRectMake(70, headView2.frame.size.height+headView2.frame.origin.y, kUIScreenWidth-75, 45)];
    nameTf.delegate = self;
    nameTf.textColor = MakeColor(75, 75, 75);
    nameTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    nameTf.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:nameTf];
    
    telTf = [[UITextField alloc] initWithFrame:CGRectMake(70, headView2.frame.size.height+headView2.frame.origin.y+45, kUIScreenWidth-75, 45)];
    telTf.textColor = MakeColor(75, 75, 75);
    telTf.delegate = self;
    telTf.font = [UIFont systemFontOfSize:13];
    telTf.clearButtonMode = UITextFieldViewModeWhileEditing;
    telTf.keyboardType = UIKeyboardTypePhonePad;
    [scrollView addSubview:telTf];
    
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, headView2.frame.size.height+headView2.frame.origin.y+i*45, 60, 45)];
        label.textAlignment = NSTextAlignmentCenter;
        
        [scrollView addSubview:label];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headView2.frame.size.height+headView2.frame.origin.y+(i+1)*45, kUIScreenWidth, 0.5)];
        line.backgroundColor = MakeColor(203, 203, 203);
        [scrollView addSubview:line];
        
        if (i == 0) {
            label.text = @"姓名:";
        }
        if (i == 1) {
            label.text = @"电话:";
        }
    }
    
    UIView *headView3 = [[UIView alloc] initWithFrame:CGRectMake(0, telTf.frame.size.height+telTf.frame.origin.y, kUIScreenWidth, 35)];
    headView3.backgroundColor = MakeColor(244, 245, 246);
    [scrollView addSubview:headView3];
    
    UIImageView *msgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 2, 15)];
    msgImageView.backgroundColor = colorblue;
    [headView3 addSubview:msgImageView];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 35)];
    msgLabel.text = @"开户信息";
    msgLabel.font = textFont14;
    msgLabel.textColor = colorblue;
    [headView3 addSubview:msgLabel];
    
    NSArray *titleArr = [NSArray arrayWithObjects:@"开户省份：",@"开户城市：", @"开户银行：", @"开户支行：", @"账号类型：", nil];
    for (int i = 0; i < 5; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, headView3.height+headView3.top+i*45, 90, 45)];
        label.textAlignment = NSTextAlignmentCenter;
        [scrollView addSubview:label];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headView3.frame.size.height+headView3.frame.origin.y+(i+1)*45, kUIScreenWidth, 0.5)];
        line.backgroundColor = color_gray_cccccc;
        [scrollView addSubview:line];
        label.text = [titleArr objectAtIndex:i];
    }
    proBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, headView3.height+headView3.top, kUIScreenWidth-90, 45)];
    proBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [proBtn setTitleColor:MakeColor(75, 75, 75) forState:UIControlStateNormal];
    proBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    proBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    proBtn.tag = 10000;
    [proBtn addTarget:self action:@selector(proBtn:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:proBtn];
    
    cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, headView3.frame.size.height+headView3.frame.origin.y+45, kUIScreenWidth-90, 45)];
    cityBtn.tag = 10001;
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cityBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [cityBtn setTitleColor:MakeColor(75, 75, 75) forState:UIControlStateNormal];
    [cityBtn addTarget:self action:@selector(cityBtn:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:cityBtn];

    bankBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, headView3.frame.size.height+headView3.frame.origin.y+90, kUIScreenWidth-90, 45)];
    bankBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    bankBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    bankBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    bankBtn.tag = 10002;
    [bankBtn setTitleColor:MakeColor(75, 75, 75) forState:UIControlStateNormal];
    [bankBtn addTarget:self action:@selector(bankBtn:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:bankBtn];

    bankChildBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, headView3.frame.size.height+headView3.frame.origin.y+135, kUIScreenWidth-110, 45)];
    [bankChildBtn setTitleColor:MakeColor(75, 75, 75) forState:UIControlStateNormal];
    bankChildBtn.tag = 10003;
    bankChildBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    bankChildBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingHead;
    bankChildBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    bankChildBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [bankChildBtn addTarget:self action:@selector(bankChildBtn:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:bankChildBtn];
    
    taskTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, headView3.frame.size.height+headView3.frame.origin.y+180, kUIScreenWidth-110, 45)];
    [taskTypeBtn setTitleColor:MakeColor(75, 75, 75) forState:UIControlStateNormal];
    taskTypeBtn.tag = 10004;
    taskTypeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    taskTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    taskTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [taskTypeBtn addTarget:self action:@selector(taskTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:taskTypeBtn];

}

-(void)didClickDone
{
    [self hideKeyboard];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(!self.bankcard.cardNum || [self.bankcard.cardNum isEqualToString:@""]) {
        [bankTf becomeFirstResponder];
        [self showToast:@"请填写银行卡号"];
        return;
    }
    if(![self.bankcard.cardNum isCardNum]) {
        [self showToast:@"银行卡号有误"];
        [bankTf becomeFirstResponder];
        return;
    }
    if(!self.bankcard.realName || [self.bankcard.realName isEqualToString:@""]) {
        [self showToast:@"请填写姓名"];
        [nameTf becomeFirstResponder];
        return;
    }
    if(![self.bankcard.realName isCharacter]) {
        [self showToast:@"姓名不合法"];
        [nameTf becomeFirstResponder];
        return;
    }
    if(!self.bankcard.phoneNumber || [self.bankcard.phoneNumber isEqualToString:@""]) {
        [self showToast:@"请填写手机号"];
        [telTf becomeFirstResponder];
        return;
    }
    if(![self.bankcard.phoneNumber isMobile]) {
        [self showToast:@"手机号不合法"];
        [telTf becomeFirstResponder];
        return;
    }
    if(self.bankcard.provinceid == 0 || self.bankcard.cityid == 0) {
        [self showToast:@"请选择银行的地址信息"];
        return;
    }
    if(self.bankcard.bankId == 0 || self.bankcard.branchBankId == 0) {
        [self showToast:@"请选择银行"];
        return;
    }
    if(self.bankcard.id != 0) {
        url = @"/account/updateBankCard";
        [params setObject:[NSString stringWithFormat:@"%ld", self.bankcard.id] forKey:@"id"];
    }else {
        url = @"/account/bindBankCard";
    }
    [params setObject:self.bankcard.realName forKey:@"realName"];
    [params setObject:self.bankcard.cardNum forKey:@"cardNum"];
    [params setObject:self.bankcard.phoneNumber forKey:@"phoneNumber"];
    [params setObject:[NSString stringWithFormat:@"%ld", self.bankcard.branchBankId] forKey:@"branchBankId"];
    [params setObject:[NSString stringWithFormat:@"%ld", self.bankcard.businessType] forKey:@"businessType"];
    [RSHttp payRequestWithURL:url params:params httpMethod:@"POST" success:^(NSDictionary *data) {
        [self showToast:@"保存成功"];
        isEdited = NO;
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
    }];
}

-(void)returnAddress:(NSString *)address aId:(NSString *)aId
{
    if (tag == 10000) {
        if([aId integerValue] != self.bankcard.provinceid) {
            self.bankcard.provinceid = [aId integerValue];
            self.bankcard.provincename = address;
            self.bankcard.cityname = @"";
            self.bankcard.cityid = 0;
            self.bankcard.branchBankName = @"";
            self.bankcard.branchBankId = 0;
            isEdited = YES;
        }
    }
    if (tag == 10001) {
        if([aId integerValue] != self.bankcard.cityid) {
            self.bankcard.cityid = [aId integerValue];
            self.bankcard.cityname = address;
            self.bankcard.branchBankName = @"";
            self.bankcard.branchBankId = 0;
            isEdited = YES;
        }
    }
    if (tag == 10002) {
        if([aId integerValue] != self.bankcard.bankId) {
            self.bankcard.bankName = address;
            self.bankcard.bankId = [aId integerValue];
            self.bankcard.branchBankName = @"";
            self.bankcard.branchBankId = 0;
            isEdited = YES;
        }
    }
    if (tag == 10003) {
        if([aId integerValue] != self.bankcard.branchBankId) {
            self.bankcard.branchBankId = [aId integerValue];
            self.bankcard.branchBankName = address;
            isEdited = YES;
        }
    }
    if (tag == 10004) {
        self.bankcard.businessType = [aId integerValue];
        isEdited = YES;
    }
    [self refreshView];
}

-(void)proBtn:(id)sender
{
    OpenAcountProvince *openAcount = [[OpenAcountProvince alloc] init];
    openAcount.delegate1 = self;
    UIButton *btn = (UIButton *)sender;
    tag = btn.tag;
    openAcount.titleString = @"开户省份";
    [self.navigationController pushViewController:openAcount animated:YES];

}

-(void)cityBtn:(id)sender
{
    OpenAcountProvince *openAcount = [[OpenAcountProvince alloc] init];
    openAcount.delegate1 = self;
    UIButton *btn = (UIButton *)sender;
    tag = btn.tag;
    openAcount.titleString = @"开户城市";
    openAcount.Id = [NSString stringWithFormat:@"%ld", self.bankcard.provinceid];
    [self.navigationController pushViewController:openAcount animated:YES];
    
}

-(void)bankBtn:(id)sender
{
    OpenAcountProvince *openAcount = [[OpenAcountProvince alloc] init];
    openAcount.delegate1 = self;
    UIButton *btn = (UIButton *)sender;
    tag = btn.tag;
    openAcount.titleString = @"开户银行";
    openAcount.Id = [NSString stringWithFormat:@"%ld", self.bankcard.provinceid];
    [self.navigationController pushViewController:openAcount animated:YES];
    
}

-(void)bankChildBtn:(id)sender
{
    OpenAcountProvince *openAcount = [[OpenAcountProvince alloc] init];
    openAcount.delegate1 = self;
    UIButton *btn = (UIButton *)sender;
    tag = btn.tag;
    openAcount.titleString = @"开户支行";
    openAcount.idArr = [NSMutableArray arrayWithObjects:[NSString stringWithFormat:@"%ld", self.bankcard.provinceid], [NSString stringWithFormat:@"%ld", self.bankcard.cityid], [NSString stringWithFormat:@"%ld", self.bankcard.bankId], nil];
    [self.navigationController pushViewController:openAcount animated:YES];
    
}

-(void)taskTypeBtn:(id)sender
{
    OpenAcountProvince *openAcount = [[OpenAcountProvince alloc] init];
    openAcount.titleString = @"账号类型";
    openAcount.delegate1 = self;
    UIButton *btn = (UIButton *)sender;
    tag = btn.tag;
    [self.navigationController pushViewController:openAcount animated:YES];
}

//格式化银行账号
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //如果是银行卡号或者手机号
    if (textField == bankTf ) {
        self.bankcard.cardNum = textField.text;
    } else if(textField == telTf) {
        self.bankcard.phoneNumber = textField.text;
    } else if(textField == nameTf){
        self.bankcard.realName = nameTf.text;
    }
    isEdited = YES;
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self hideKeyboard];
    if(textField == bankTf) {
        [nameTf becomeFirstResponder];
    } else if (textField == nameTf) {
        [telTf becomeFirstResponder];
    }
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    self.bankcard.cardNum = bankTf.text;
    self.bankcard.realName = nameTf.text;
    self.bankcard.phoneNumber = telTf.text;
}

-(void) hideKeyboard
{
    [nameTf resignFirstResponder];
    [bankTf resignFirstResponder];
    [telTf resignFirstResponder];
    self.bankcard.cardNum = bankTf.text;
    self.bankcard.realName = nameTf.text;
    self.bankcard.phoneNumber = telTf.text;
}

-(void) didClickLeft
{
    if(isEdited) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您还没有保存，确定退出么？" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    } else {
        [super didClickLeft];
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0) {
        [super didClickLeft];
    }
}
@end
