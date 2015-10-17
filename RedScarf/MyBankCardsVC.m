//
//  MyBankCardsVC.m
//  RedScarf
//
//  Created by zhangb on 15/9/2.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "MyBankCardsVC.h"
#import "OpenAcountProvince.h"
#import "UIUtils.h"

@implementation MyBankCardsVC
{
    NSArray *cityArr;
    NSArray *infoArr;
    NSIndexPath *index;
    NSMutableArray *indexArr;
    NSMutableArray *idArr;
    NSString *bankAcount,*name,*tel,*email,*cityId,*bankId,*bankChildId,*bank;
    BOOL editOrSave;
    UITextField *bankTf;
}

-(void)viewDidLoad
{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"我的银行卡";
//    self.navigationController.navigationBar.barTintColor = MakeColor(32, 102, 208);
    self.tabBarController.tabBar.hidden = YES;
    editOrSave = YES;
    cityArr = [NSArray arrayWithObjects:@"开户省份:",@"开户城市:",@"开户银行:",@"开户支行:", nil];
    infoArr = [NSArray arrayWithObjects:@"姓 名:",@"手 机:",@"邮 箱:", nil];
    indexArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    idArr = [NSMutableArray arrayWithObjects:@"",@"",@"",@"", nil];
    [self navigationBar];
    [self getMessage];
    [self initTableView];

}

-(void)navigationBar
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comeback"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDone)];
    right.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = right;
    
    //隐藏tabbar上的按钮
    UIButton *barBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [barBtn removeFromSuperview];
    

}

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    __block NSMutableArray *arr = [NSMutableArray array];
    [RedScarf_API requestWithURL:@"/user/bankCard" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
            arr = [result objectForKey:@"msg"];
            if (arr.count) {
                NSMutableDictionary *dic = [[result objectForKey:@"msg"] objectAtIndex:0];
                NSLog(@"dic = %@",dic);
                name = [dic objectForKey:@"accountName"];
                if (name.length) {
                    editOrSave = NO;
                }
                tel = [dic objectForKey:@"mobilePhone"];
                email = [dic objectForKey:@"email"];
                bankAcount = [dic objectForKey:@"sn"];
                bank = [dic objectForKey:@"id"];
                
                indexArr[0] = [dic objectForKey:@"provinceName"];
                indexArr[1] = [dic objectForKey:@"cityName"];
                indexArr[2] = [dic objectForKey:@"bankName"];
                indexArr[3] = [dic objectForKey:@"branchBankName"];
                
                self.navigationItem.rightBarButtonItem.title = @"编辑";
                self.tableView.userInteractionEnabled = NO;
                [self.tableView reloadData];
            }
           
        }
    }];

}

-(void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.userInteractionEnabled = NO;
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 25;
    }
   
    return 35;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = MakeColor(244, 245, 246);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, 50, 35)];
    label.textColor = MakeColor(75, 75, 75);
    label.font = [UIFont systemFontOfSize:13];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(22, 12, 5, 10)];
    img.image = [UIImage imageNamed:@"head@2x"];
    if (section == 0) {
        view.frame = CGRectMake(0, 0, kUIScreenWidth, 25);
    }else if (section == 1){
        view.frame = CGRectMake(0, 0, kUIScreenWidth, 35);
        [view addSubview:img];
        [view addSubview:label];
        label.text = @"开户人";

    }else if (section == 2){
        view.frame = CGRectMake(0, 0, kUIScreenWidth, 35);
        [view addSubview:img];
        [view addSubview:label];
        label.text = @"开户地";
    }
    return view;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }
    if (section ==1 ) {
        return 3;
    }
   
    return 4;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 100, 45)];
    [cell.contentView addSubview:label];
    if (indexPath.section == 0) {
        label.text = @"银行账号:";
        bankTf = [[UITextField alloc] initWithFrame:CGRectMake(105, 0, kUIScreenWidth-105, 45)];
        bankTf.delegate = self;
        bankTf.textColor = MakeColor(75, 75, 75);
        bankTf.font = [UIFont systemFontOfSize:13];
        bankTf.text = bankAcount;
        bankTf.tag = 109;
        [cell.contentView addSubview:bankTf];
    }
    if (indexPath.section == 1) {
        label.frame = CGRectMake(20, 0, 60, 45);
        label.text = infoArr[indexPath.row];
        
        for (int i = 0; i < 3; i++) {
            UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(80, 0, kUIScreenWidth-100, 50)];
            
            if ([label.text isEqualToString:@"姓 名:"]) {
                if (name.length) {
                     name = [NSString stringWithString:[name stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
                }
                
                tf.text = name;
                tf.tag =100;
            }
            if ([label.text isEqualToString:@"手 机:"]) {
                tf.text = tel;
                tf.tag =101;
            }
            if ([label.text isEqualToString:@"邮 箱:"]) {
                tf.text = email;
                tf.tag =102;
            }
            tf.textColor = MakeColor(75, 75, 75);
            tf.font = [UIFont systemFontOfSize:13];
            tf.delegate = self;
            [cell.contentView addSubview:tf];
        }
    }
    if (indexPath.section == 2) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        label.text = cityArr[indexPath.row];
        UILabel *openAcountLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, kUIScreenWidth-130, 45)];
        openAcountLabel.tag = 111+indexPath.row;
        openAcountLabel.textColor = MakeColor(75, 75, 75);
        openAcountLabel.font = [UIFont systemFontOfSize:13];
        for (int i = 0; i<indexArr.count; i++) {
            indexArr[i] = [NSString stringWithString:[indexArr[i] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        openAcountLabel.text = indexArr[indexPath.row];
        [cell.contentView addSubview:openAcountLabel];
    }
    
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    OpenAcountProvince *openAcount = [[OpenAcountProvince alloc] init];
    openAcount.delegate = self;
    index = indexPath;
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            
            openAcount.titleString = @"开户省份";
            //add
            indexArr[1] = indexArr[2] = indexArr[3] = @"";
        }
        if (indexPath.row == 1) {
            for (int i = 0; i < 1; i++) {
                NSString *length = indexArr[i];
                if (!length.length) {
                    [self alertView:@"请依次输入"];
                    return;
                }
            }
        
            openAcount.Id = cityId;
            openAcount.titleString = @"开户城市";
            //add
            indexArr[2] = indexArr[3] = @"";
        }
        if (indexPath.row == 2) {
            for (int i = 0; i < 2; i++) {
                NSString *length = indexArr[i];
                if (!length.length) {
                    [self alertView:@"请依次输入"];
                    return;
                }
            }

            openAcount.Id = bankId;
            openAcount.titleString = @"开户银行";
            //add
            indexArr[3] = @"";
        }
        if (indexPath.row == 3) {
            for (int i = 0; i < 3; i++) {
                NSString *length = indexArr[i];
                if (!length.length) {
                    [self alertView:@"请依次输入"];
                    return;
                }
            }
          
            openAcount.idArr = idArr;
            openAcount.titleString = @"开户支行";
        }
    }
    [self.navigationController pushViewController:openAcount animated:YES];
}

-(void)returnAddress:(NSString *)address aId:(NSString *)aId
{
    if (index.row == 0) {
        cityId = aId;
    }
    if (index.row == 1) {
        bankId = aId;
    }
    if (index.row == 2) {
        bankChildId = aId;
    }

    [idArr replaceObjectAtIndex:index.row withObject:aId];
    [indexArr replaceObjectAtIndex:index.row withObject:address];
    [self.tableView reloadData];
}

-(void)didClickDone
{
    if ([self.navigationItem.rightBarButtonItem.title isEqualToString:@"编辑"]) {
    
        name = tel = email = bankAcount = @"";
        for (int i = 0; i<indexArr.count; i++) {
            indexArr[i] = @"";
        }
        [self.tableView reloadData];
        self.navigationItem.rightBarButtonItem.title = @"保存";
        self.tableView.userInteractionEnabled = YES;
    }else{
        //点击保存
        if (name.length&&bankAcount.length&&tel.length&&email.length) {
            
            for (NSString *str in indexArr) {
                if (!str.length) {
                    [self alertView:@"开户信息不能为空"];
                    return;
                }
            }
            
            AppDelegate *app = [UIApplication sharedApplication].delegate;
            NSMutableDictionary *params = [NSMutableDictionary dictionary];
            
            app.tocken = [UIUtils replaceAdd:app.tocken];
            
            NSString *post = @"POST";
            if (!editOrSave) {
                [params setObject:bank forKey:@"id"];
                post = @"PUT";
                name = [name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
                for (int i = 0; i < indexArr.count; i++) {
                    indexArr[i] = [indexArr[i] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                }
            }
            if (![UIUtils isValidateEmail:email]) {
                [self alertView:@"邮箱不正确"];
            }
            
            
            [params setObject:app.tocken forKey:@"token"];
            [params setObject:name forKey:@"accountName"];
            bankAcount = [bankAcount stringByReplacingOccurrencesOfString:@" " withString:@""];
            [params setObject:bankAcount forKey:@"sn"];
            [params setObject:tel forKey:@"mobilePhone"];
            [params setObject:email forKey:@"email"];
            
            [params setObject:idArr[0] forKey:@"provinceId"];
            [params setObject:idArr[1] forKey:@"cityId"];
            [params setObject:idArr[2] forKey:@"bankId"];
            [params setObject:idArr[3] forKey:@"branchBankId"];
            
            [params setObject:indexArr[0] forKey:@"provinceName"];
            [params setObject:indexArr[1] forKey:@"cityName"];
            [params setObject:indexArr[2] forKey:@"bankName"];
            [params setObject:indexArr[3] forKey:@"branchBankName"];
            
            [RedScarf_API requestWithURL:@"/user/bankCard" params:params httpMethod:post block:^(id result) {
                NSLog(@"result = %@",result);
                if ([[result objectForKey:@"success"] boolValue]) {
                    for (NSMutableDictionary *dic in [result objectForKey:@"msg"]) {
                        NSLog(@"dic = %@",dic);
                        
                    }
                    [self alertView:@"保存成功"];
                    self.navigationItem.rightBarButtonItem.title = @"编辑";
                    self.tableView.userInteractionEnabled = NO;
                }else{
                    [self alertView:[result objectForKey:@"msg"]];
                }
            }];
            
        }else{
            [self alertView:@"用户信息不能为空"];
        }
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.tabBarController.view viewWithTag:22022].hidden = YES;
    [self.tabBarController.view viewWithTag:11011].hidden = YES;
    [self.tableView reloadData];
}

-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 109) {
        bankAcount = textField.text;
    }
    if (textField.tag == 100) {
        name = textField.text;
    }
    if (textField.tag == 101) {
        tel = textField.text;
    }
    if (textField.tag == 102) {
        email = textField.text;
    }
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

@end
