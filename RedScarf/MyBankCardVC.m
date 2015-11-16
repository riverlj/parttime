//
//  MyBankCardVC.m
//  RedScarf
//
//  Created by zhangb on 15/9/14.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "MyBankCardVC.h"
#import "OpenAcountProvince.h"
#import "UIUtils.h"
@interface MyBankCardVC ()
{
    NSString *bankText,*telText,*emailText,*nameText,*bank,*bankId,*cityId,*bankChildId;
    NSInteger tag;
    BOOL editOrSave;
    NSMutableArray *indexArr,*idArr;
    UITextField *bankTf;
    UITextField *nameTf;
    UITextField *telTf;
    UIButton *proBtn,*cityBtn,*bankBtn,*bankChildBtn,*taskTypeBtn;
    NSString *branchBankId,*cardId;
    NSString *idOne,*idTwo,*idThree;
}

@end

@implementation MyBankCardVC

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
}

-(void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"我的银行卡";
    editOrSave = YES;
//    self.navigationController.navigationBar.barTintColor = MakeColor(32, 102, 208);
    self.tabBarController.tabBar.hidden = YES;
    indexArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    idArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"",@"", nil];
    [self getMessage];
    [self navigationBar];
    [self initView];
    
}

-(void)navigationBar
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comeback"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDone)];
//    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
    
    //隐藏tabbar上的按钮
    UIButton *barBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [barBtn removeFromSuperview];
    
}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    __block NSMutableArray *arr = [NSMutableArray array];
    [self showHUD:@"正在加载"];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"withdrawToken"]) {
        [params setObject:[defaults objectForKey:@"withdrawToken"] forKey:@"token"];
    }
    [RedScarf_API zhangbRequestWithURL:[NSString stringWithFormat:@"%@/account/queryBankCard",REDSCARF_PAY_URL] params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if (![[result objectForKey:@"code"] boolValue]) {
            arr = [result objectForKey:@"body"];
            if (arr.count) {
                NSMutableDictionary *dic = [[result objectForKey:@"body"] objectAtIndex:0];
                NSLog(@"dic = %@",dic);
                nameText = [dic objectForKey:@"realName"];
                if (nameText.length) {
                    editOrSave = NO;
                }
                telText = [dic objectForKey:@"phoneNumber"];
                bankText = [dic objectForKey:@"cardNum"];
                branchBankId = [dic objectForKey:@"branchBankId"];
                [idArr replaceObjectAtIndex:3 withObject:[dic objectForKey:@"branchBankId"]];
                cardId = [dic objectForKey:@"id"];
                indexArr[2] = [dic objectForKey:@"bankName"];
                indexArr[3] = [dic objectForKey:@"branchBankName"];
                indexArr[4] = [dic objectForKey:@"businessType"];
                self.navigationItem.rightBarButtonItem.title = @"编辑";
                [self getMsgFromBranchBankId];
            }
            
            [self hidHUD];
           
            
        }else{
            [self alertView:[result objectForKey:@"body"]];
        }
    }];
    
}

-(void)getMsgFromBranchBankId
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    [self showHUD:@"正在加载"];
    [params setObject:branchBankId forKey:@"id"];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"withdrawToken"]) {
        [params setObject:[defaults objectForKey:@"withdrawToken"] forKey:@"token"];
    }
    [RedScarf_API zhangbRequestWithURL:[NSString stringWithFormat:@"%@/bank/getBranchBankById",REDSCARF_PAY_URL] params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if (![[result objectForKey:@"code"] boolValue]) {
            NSMutableDictionary *dic = [result objectForKey:@"body"];
            indexArr[0] = [dic objectForKey:@"provincename"];
            indexArr[1] = [dic objectForKey:@"cityname"];
//            [idArr replaceObjectAtIndex:0 withObject:[dic objectForKey:@"provinceid"]];
//            [idArr replaceObjectAtIndex:1 withObject:[dic objectForKey:@"cityid"]];
//            [idArr replaceObjectAtIndex:2 withObject:[dic objectForKey:@"parentid"]];


        }else{
            [self alertView:[result objectForKey:@"body"]];
        }
        [self initView];
        [self.tableView reloadData];
    }];

}

-(void)initView
{
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, kUIScreenHeigth)];
    [self.view addSubview:scrollView];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake(0, kUIScreenHeigth*1.1);
    scrollView.userInteractionEnabled = YES;
    
    UIView *backgroungView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
    backgroungView.backgroundColor = [UIColor whiteColor];
    backgroungView.tag = 100;
    backgroungView.userInteractionEnabled = YES;
    [scrollView addSubview:backgroungView];
    
    UIView *headView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 25)];
    headView1.backgroundColor = MakeColor(244, 245, 246);
    [backgroungView addSubview:headView1];
    
    UILabel *bankAcount = [[UILabel alloc] initWithFrame:CGRectMake(10, headView1.frame.size.height+headView1.frame.origin.y, 80, 45)];
    bankAcount.textAlignment = NSTextAlignmentCenter;
    bankAcount.text = @"银行账号:";
    [backgroungView addSubview:bankAcount];
    
    bankTf = [[UITextField alloc] initWithFrame:CGRectMake(bankAcount.frame.size.width+bankAcount.frame.origin.x, headView1.frame.size.height+headView1.frame.origin.y, kUIScreenWidth-bankAcount.frame.size.width, 45)];
    bankTf.text = bankText;
    bankTf.userInteractionEnabled = NO;
    bankTf.tag = 101;
    bankTf.delegate = self;
    bankTf.textColor = MakeColor(75, 75, 75);
    bankTf.font = [UIFont systemFontOfSize:13];

    [backgroungView addSubview:bankTf];
    
    UIView *headView2 = [[UIView alloc] initWithFrame:CGRectMake(0, bankTf.frame.size.height+bankTf.frame.origin.y, kUIScreenWidth, 35)];
    headView2.backgroundColor = MakeColor(244, 245, 246);
    [backgroungView addSubview:headView2];
    
    UIImageView *personImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 2, 15)];
    personImageView.backgroundColor = colorblue;
    [headView2 addSubview:personImageView];
    
    UILabel *personLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 35)];
    personLabel.text = @"开户人";
    personLabel.font = textFont14;
    personLabel.textColor = colorblue;
    [headView2 addSubview:personLabel];
    
    nameTf = [[UITextField alloc] initWithFrame:CGRectMake(70, headView2.frame.size.height+headView2.frame.origin.y, kUIScreenWidth-60, 45)];
    nameTf.delegate = self;
    nameTf.textColor = MakeColor(75, 75, 75);
    nameTf.userInteractionEnabled = NO;
    nameTf.text = nameText;
    nameTf.font = [UIFont systemFontOfSize:13];
    [backgroungView addSubview:nameTf];
    
    telTf = [[UITextField alloc] initWithFrame:CGRectMake(70, headView2.frame.size.height+headView2.frame.origin.y+45, kUIScreenWidth-60, 45)];
    telTf.textColor = MakeColor(75, 75, 75);
    telTf.userInteractionEnabled = NO;
    telTf.text = telText;
    telTf.delegate = self;
    telTf.font = [UIFont systemFontOfSize:13];
    [backgroungView addSubview:telTf];
    
    for (int i = 0; i < 2; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, headView2.frame.size.height+headView2.frame.origin.y+i*45, 60, 45)];
        label.textAlignment = NSTextAlignmentCenter;
        
        [backgroungView addSubview:label];
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headView2.frame.size.height+headView2.frame.origin.y+(i+1)*45, kUIScreenWidth, 0.5)];
        line.backgroundColor = MakeColor(203, 203, 203);
        [backgroungView addSubview:line];
        
        if (i == 0) {
            label.text = @"姓名:";
        }
        if (i == 1) {
            label.text = @"电话:";
        }
    }
    
    UIView *headView3 = [[UIView alloc] initWithFrame:CGRectMake(0, telTf.frame.size.height+telTf.frame.origin.y, kUIScreenWidth, 35)];
    headView3.backgroundColor = MakeColor(244, 245, 246);
    [backgroungView addSubview:headView3];
    
    UIImageView *msgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 2, 15)];
    msgImageView.backgroundColor = colorblue;
    [headView3 addSubview:msgImageView];
    
    UILabel *msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 100, 35)];
    msgLabel.text = @"开户信息";
    msgLabel.font = textFont14;
    msgLabel.textColor = colorblue;
    [headView3 addSubview:msgLabel];
    
    for (int i = 0; i < 5; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, headView3.frame.size.height+headView3.frame.origin.y+i*45, 90, 45)];
        label.textAlignment = NSTextAlignmentCenter;
       
        [backgroungView addSubview:label];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, headView3.frame.size.height+headView3.frame.origin.y+(i+1)*45, kUIScreenWidth, 0.5)];
        line.backgroundColor = MakeColor(203, 203, 203);
        [backgroungView addSubview:line];
       
        if (i == 0) {
            label.text = @"开户省份:";
        }
        if (i == 1) {
            label.text = @"开户城市:";
        }
        if (i == 2) {
            label.text = @"开户银行:";
        }
        if (i == 3) {
            label.text = @"开户支行:";
        }
        if (i == 4) {
            label.text = @"账号类型:";
        }
        
    }
    proBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, headView3.frame.size.height+headView3.frame.origin.y, kUIScreenWidth-90, 45)];
    [proBtn setTitle:indexArr[0] forState:UIControlStateNormal];
    proBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [proBtn setTitleColor:MakeColor(75, 75, 75) forState:UIControlStateNormal];
    proBtn.userInteractionEnabled = NO;
    proBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    proBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    proBtn.tag = 10000;
    [proBtn addTarget:self action:@selector(proBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backgroungView addSubview:proBtn];
    
    cityBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, headView3.frame.size.height+headView3.frame.origin.y+45, kUIScreenWidth-90, 45)];
    cityBtn.tag = 10001;
    cityBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    cityBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    cityBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    [cityBtn setTitle:indexArr[1] forState:UIControlStateNormal];
    [cityBtn setTitleColor:MakeColor(75, 75, 75) forState:UIControlStateNormal];

    cityBtn.userInteractionEnabled = NO;
    [cityBtn addTarget:self action:@selector(cityBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backgroungView addSubview:cityBtn];

    bankBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, headView3.frame.size.height+headView3.frame.origin.y+90, kUIScreenWidth-90, 45)];
    bankBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    bankBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    bankBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    bankBtn.tag = 10002;
    [bankBtn setTitle:indexArr[2] forState:UIControlStateNormal];
    [bankBtn setTitleColor:MakeColor(75, 75, 75) forState:UIControlStateNormal];

    bankBtn.userInteractionEnabled = NO;
    [bankBtn addTarget:self action:@selector(bankBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backgroungView addSubview:bankBtn];

    bankChildBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, headView3.frame.size.height+headView3.frame.origin.y+135, kUIScreenWidth-110, 45)];
    [bankChildBtn setTitle:indexArr[3] forState:UIControlStateNormal];
    [bankChildBtn setTitleColor:MakeColor(75, 75, 75) forState:UIControlStateNormal];
    bankChildBtn.tag = 10003;
    bankChildBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    bankChildBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    bankChildBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    bankChildBtn.userInteractionEnabled = NO;
    [bankChildBtn addTarget:self action:@selector(bankChildBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backgroungView addSubview:bankChildBtn];
    
    taskTypeBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, headView3.frame.size.height+headView3.frame.origin.y+180, kUIScreenWidth-110, 45)];
    if (indexArr[4]) {
        if ([indexArr[4] intValue] == 0) {
            [taskTypeBtn setTitle:@"对私业务" forState:UIControlStateNormal];
            
        }else{
            [taskTypeBtn setTitle:@"对公业务" forState:UIControlStateNormal];
            
        }
    }
    
    [taskTypeBtn setTitleColor:MakeColor(75, 75, 75) forState:UIControlStateNormal];
    taskTypeBtn.tag = 10004;
    taskTypeBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    taskTypeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    taskTypeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    taskTypeBtn.userInteractionEnabled = NO;
    [taskTypeBtn addTarget:self action:@selector(taskTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
    [backgroungView addSubview:taskTypeBtn];

}

-(void)didClickDone
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
        bankTf.userInteractionEnabled = YES;
        nameTf.userInteractionEnabled = YES;
        telTf.userInteractionEnabled = YES;
        taskTypeBtn.userInteractionEnabled = YES;
        proBtn.userInteractionEnabled = YES;
        cityBtn.userInteractionEnabled = YES;
        bankBtn.userInteractionEnabled = YES;
        bankChildBtn.userInteractionEnabled = YES;
        for (int i = 0; i < 4; i++) {
            UIButton *btn = (UIButton *)[[self.view viewWithTag:100] viewWithTag:100+i+5];
            btn.userInteractionEnabled = YES;
        }
        self.navigationItem.rightBarButtonItem.title = @"保存";
    }else{
        //点击保存
        if (nameTf.text.length&&bankTf.text.length&&telTf.text.length) {
            
            for (NSString *str in indexArr) {
                if (str == nil) {
                    [self alertView:@"开户信息不能为空"];
                    return;
                }
            }
            
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            NSString *url = @"/account/bindBankCard";            
            if (!editOrSave) {
                url = @"/account/updateBankCard";
                 [params setObject:cardId forKey:@"id"];
//                for (int i = 0; i < indexArr.count; i++) {
//                    indexArr[i] = [indexArr[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//                }
            }
            
            if (![UIUtils isValidateCharacter:nameTf.text]) {
                [self alertView:@"名字为两个以上的汉字"];
                return;
            }
            
            if (![UIUtils isNumber:telTf.text] || telTf.text.length != 11) {
           
                [self alertView:@"手机号输入有误"];
                return;
            }
            bankTf.text = [bankTf.text stringByReplacingOccurrencesOfString:@" " withString:@""];
            if (![UIUtils isNumber:bankTf.text]) {
                
                [self alertView:@"卡号输入有误"];
                return;
            }
            
            NSString *name = nameTf.text;
            //不用转utf8
//            name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
          
            [params setObject:name forKey:@"realName"];
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            if ([defaults objectForKey:@"withdrawToken"]) {
                [params setObject:[defaults objectForKey:@"withdrawToken"] forKey:@"token"];
            }
            [params setObject:bankTf.text forKey:@"cardNum"];
            [params setObject:telTf.text forKey:@"phoneNumber"];
            if ([taskTypeBtn.titleLabel.text isEqualToString:@"对公业务"]) {
                [params setObject:@"1" forKey:@"businessType"];
            }
            if ([taskTypeBtn.titleLabel.text isEqualToString:@"对私业务"]) {
                [params setObject:@"0" forKey:@"businessType"];
            }
            
            [params setObject:idArr[3] forKey:@"branchBankId"];
            
            [RedScarf_API zhangbRequestWithURL:[NSString stringWithFormat:@"%@%@",REDSCARF_PAY_URL,url] params:params httpMethod:@"POST" block:^(id result) {
                NSLog(@"result = %@",result);
                if ([[result objectForKey:@"success"] boolValue]) {
                    for (NSMutableDictionary *dic in [result objectForKey:@"msg"]) {
                        NSLog(@"dic = %@",dic);
                        
                    }
                    [self alertView:@"保存成功"];
                    self.navigationItem.rightBarButtonItem.title = @"编辑";
                    bankTf.userInteractionEnabled = NO;
                    nameTf.userInteractionEnabled = NO;
                    telTf.userInteractionEnabled = NO;
                    proBtn.userInteractionEnabled = NO;
                    taskTypeBtn.userInteractionEnabled = NO;
                    cityBtn.userInteractionEnabled = NO;
                    bankBtn.userInteractionEnabled = NO;
                    bankChildBtn.userInteractionEnabled = NO;
                }else{
                    [self alertView:[result objectForKey:@"body"]];
                }
            }];
            
        }else{
            [self alertView:@"用户信息不能为空"];
        }
        
    }
}

-(void)returnAddress:(NSString *)address aId:(NSString *)aId
{
    if (tag == 10000) {
        cityId = aId;
        [proBtn setTitle:address forState:UIControlStateNormal];
    }
    if (tag == 10001) {
        bankId = aId;
        [cityBtn setTitle:address forState:UIControlStateNormal];
    }
    if (tag == 10002) {
        bankChildId = aId;
        [bankBtn setTitle:address forState:UIControlStateNormal];
    }
    if (tag == 10003) {
        [bankChildBtn setTitle:address forState:UIControlStateNormal];
    }
    if (tag == 10004) {
        [taskTypeBtn setTitle:address forState:UIControlStateNormal];
    }
    branchBankId = aId;
    [idArr replaceObjectAtIndex:tag-10000 withObject:aId];
    [indexArr replaceObjectAtIndex:tag-10000 withObject:address];
    
}

-(void)proBtn:(id)sender
{
    OpenAcountProvince *openAcount = [[OpenAcountProvince alloc] init];
    openAcount.delegate = self;
    UIButton *btn = (UIButton *)sender;
    tag = btn.tag;
    openAcount.titleString = @"开户省份";
    [indexArr replaceObjectAtIndex:1 withObject:@""];
    [indexArr replaceObjectAtIndex:2 withObject:@""];
    [indexArr replaceObjectAtIndex:3 withObject:@""];
    [cityBtn setTitle:@"" forState:UIControlStateNormal];
    [bankBtn setTitle:@"" forState:UIControlStateNormal];
    [bankChildBtn setTitle:@"" forState:UIControlStateNormal];
    [idArr replaceObjectAtIndex:1 withObject:@""];
    [idArr replaceObjectAtIndex:2 withObject:@""];
    [idArr replaceObjectAtIndex:3 withObject:@""];

    [self.navigationController pushViewController:openAcount animated:YES];

}

-(void)cityBtn:(id)sender
{
    OpenAcountProvince *openAcount = [[OpenAcountProvince alloc] init];
    openAcount.delegate = self;
    UIButton *btn = (UIButton *)sender;
    tag = btn.tag;
    idOne = openAcount.Id = idArr[0];
    openAcount.titleString = @"开户城市";
    if ([idOne isEqual:@""]) {
        [self alertView:@"请从省份开始选择"];
        return;
    }
    [indexArr replaceObjectAtIndex:2 withObject:@""];
    [indexArr replaceObjectAtIndex:3 withObject:@""];
    [bankBtn setTitle:@"" forState:UIControlStateNormal];
    [bankChildBtn setTitle:@"" forState:UIControlStateNormal];
    [idArr replaceObjectAtIndex:2 withObject:@""];
    [idArr replaceObjectAtIndex:3 withObject:@""];
    [self.navigationController pushViewController:openAcount animated:YES];
    
}

-(void)bankBtn:(id)sender
{
    OpenAcountProvince *openAcount = [[OpenAcountProvince alloc] init];
    openAcount.delegate = self;
    UIButton *btn = (UIButton *)sender;
    tag = btn.tag;
    openAcount.Id = idArr[0];
    openAcount.titleString = @"开户银行";
    idOne = idArr[0];
    idTwo = idArr[1];
    if ([idOne isEqual:@""]||[idTwo isEqual:@""]) {
        [self alertView:@"请从省份开始选择"];
        return;
    }
    [indexArr replaceObjectAtIndex:3 withObject:@""];
    [bankChildBtn setTitle:@"" forState:UIControlStateNormal];
    [idArr replaceObjectAtIndex:3 withObject:@""];
    [bankChildBtn setTitle:@"" forState:UIControlStateNormal];
    [self.navigationController pushViewController:openAcount animated:YES];
    
}

-(void)bankChildBtn:(id)sender
{
    OpenAcountProvince *openAcount = [[OpenAcountProvince alloc] init];
    openAcount.delegate = self;
    UIButton *btn = (UIButton *)sender;
    tag = btn.tag;
    openAcount.idArr = idArr;
    openAcount.titleString = @"开户支行";
    idOne = idArr[0];
    idTwo = idArr[1];
    idThree = idArr[2];
    if ([idOne isEqual:@""]||[idTwo isEqual:@""]||[idThree isEqual:@""]) {
        [self alertView:@"请从省份开始选择"];
        return;
    }
    [self.navigationController pushViewController:openAcount animated:YES];
    
}

-(void)taskTypeBtn:(id)sender
{
    OpenAcountProvince *openAcount = [[OpenAcountProvince alloc] init];
    openAcount.titleString = @"账号类型";
    openAcount.delegate = self;
    UIButton *btn = (UIButton *)sender;
    tag = btn.tag;
    [self.navigationController pushViewController:openAcount animated:YES];
}

//格式化银行账号
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == bankTf) {
        NSString *text = [bankTf text];
        
        NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789\b"];
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
        if ([string rangeOfCharacterFromSet:[characterSet invertedSet]].location != NSNotFound) {
            return NO;
        }
        
        text = [text stringByReplacingCharactersInRange:range withString:string];
        text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        NSString *newString = @"";
        while (text.length > 0) {
            NSString *subString = [text substringToIndex:MIN(text.length, 4)];
            newString = [newString stringByAppendingString:subString];
            if (subString.length == 4) {
                newString = [newString stringByAppendingString:@" "];
            }
            text = [text substringFromIndex:MIN(text.length, 4)];
        }
        
        newString = [newString stringByTrimmingCharactersInSet:[characterSet invertedSet]];
        
        // 限制长度
        if (newString.length >= 27) {
            return NO;
        }
        
        [bankTf setText:newString];
        
        return NO;
        
    }
    return YES;
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
