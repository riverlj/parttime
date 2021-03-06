//
//  ModifyPMViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/18.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "ModifyPMViewController.h"

@interface ModifyPMViewController ()


@end

@implementation ModifyPMViewController
{
    UITextField *nameTf;
    NSString *url;
    NSMutableArray *array;
    UIPickerView *pickerView;
    NSMutableArray *majorArray;
    NSMutableArray *addressArray;
}

-(void)viewWillAppear:(BOOL)animated
{
    [self comeBack:nil];
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    array = [NSMutableArray array];
    addressArray = [NSMutableArray array];
    if ([self.judgeStr isEqualToString:@"name"]) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDone)];
        [right setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = right;

        self.title = @"修改姓名";
        [self modifyName];
    }
    if ([self.judgeStr isEqualToString:@"major"]) {
        self.title = @"修改学校专业";
        
        [self getMessage];
    }
    if ([self.judgeStr isEqualToString:@"address"]) {
        UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(didClickDone)];
        [right setTintColor:[UIColor whiteColor]];
        self.navigationItem.rightBarButtonItem = right;
        [self initAddress];
        self.title = @"修改地址";
    }
    if ([self.judgeStr isEqualToString:@"modifyPassword"]) {
        self.title = @"修改密码";
    }
    [self navigationBar];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(void)navigationBar
{
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"comeback"] style:UIBarButtonItemStylePlain target:self action:@selector(didClickLeft)];
    left.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = left;
    
    //隐藏tabbar上的按钮
    UIButton *barBtn = (UIButton *)[self.navigationController.navigationBar viewWithTag:11111];
    [barBtn removeFromSuperview];
}

#pragma mark -- 修改地址
-(void)initAddress
{
    UILabel *currentAddress = [[UILabel alloc] initWithFrame:CGRectMake(25, 5, kUIScreenWidth-50, 40)];
    currentAddress.textColor = MakeColor(125, 125, 125);
   
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"当前地址:%@",self.currentAddress]];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, 5)];
    currentAddress.attributedText = str;
    [self.view addSubview:currentAddress];
    
    UIButton *modifyBtn = [[UIButton alloc] initWithFrame:CGRectMake(25, 51, kUIScreenWidth-50, 45)];
    [modifyBtn setTitle:@" 选择楼栋" forState:UIControlStateNormal];
    modifyBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [modifyBtn setBackgroundColor:[UIColor whiteColor]];
    modifyBtn.tag = 56789;
    [modifyBtn setTitleColor:MakeColor(125, 125, 125) forState:UIControlStateNormal];
    modifyBtn.layer.borderColor = MakeColor(125, 125, 125).CGColor;
    [modifyBtn addTarget:self action:@selector(didClickModifyBtn) forControlEvents:UIControlEventTouchUpInside];
    modifyBtn.layer.cornerRadius = 3;
    modifyBtn.layer.masksToBounds = YES;
    modifyBtn.layer.borderWidth = 0.5;
    [self.view addSubview:modifyBtn];
    
}

-(void)didClickModifyBtn
{
    [self getMessage];
}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    url = @"/team/apartments";
    if ([self.judgeStr isEqualToString:@"major"]) {
        url = @"/user/department/";
    }
    
    [RSHttp requestWithURL:url params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        if ([self.judgeStr isEqualToString:@"major"]) {
            array = [data objectForKey:@"body"];
        }else{
            addressArray = [[data objectForKey:@"body"] objectForKey:@"apartments"];
            [self initPickerView];
        }
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}
#pragma mark -- 修改姓名
-(void)modifyName
{
    nameTf = [[UITextField alloc] initWithFrame:CGRectMake(25, 20, kUIScreenWidth-50, 40)];
    nameTf.text = self.name;
    nameTf.layer.borderColor = MakeColor(230, 230, 230).CGColor;
    nameTf.layer.borderWidth = 1.0;
    nameTf.layer.masksToBounds = YES;
    nameTf.layer.cornerRadius = 5;
    [self.view addSubview:nameTf];
    
    UIView *view = [[UIButton alloc] initWithFrame:CGRectMake(25, 86, kUIScreenWidth-50, 40)];
    view.tag = 1234;
    view.layer.borderWidth = 1.0;
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5;
    view.layer.borderColor = MakeColor(230, 230, 230).CGColor;
    [self.view addSubview:view];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake((kUIScreenWidth-50)/2, 5, 1, 30)];
    lineView.backgroundColor = MakeColor(230, 230, 230);
    [view addSubview:lineView];
    
    for (int i = 0; i < 2; i++) {
        UIButton *genderBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        genderBtn.frame = CGRectMake((kUIScreenWidth-50)/2*i,0, (kUIScreenWidth-50)/2, 40);
        [genderBtn addTarget:self action:@selector(modifyGender:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:genderBtn];
        
        UIImageView *genderView = [[UIImageView alloc] init];
        [view addSubview:genderView];
        
        if (i == 0) {
            genderBtn.tag = 123;
            [genderBtn setTitle:@"男" forState:UIControlStateNormal];
            if ([self.gender isEqualToString:@"1"]) {
                genderBtn.backgroundColor = MakeColor(231, 239, 254);
            }
            
            genderView.frame = CGRectMake((kUIScreenWidth-50)/4-27, 12, 15, 15);
            genderView.image = [UIImage imageNamed:@"nan2x"];
        }else{
            genderBtn.tag = 321;
            if ([self.gender isEqualToString:@"2"]) {
                genderBtn.backgroundColor = MakeColor(231, 239, 254);
            }
            [genderBtn setTitle:@"女" forState:UIControlStateNormal];
            genderView.frame = CGRectMake((kUIScreenWidth-50)/4*3-27, 12, 12, 15);
            genderView.image = [UIImage imageNamed:@"nv2x"];
        }
    }
}

-(void)modifyGender:(id)sender
{
    UIButton *btn = sender;
    UIButton *button;
    if (btn.tag == 123) {
        
            button = (UIButton *)[[self.view viewWithTag:1234] viewWithTag:321];
            button.backgroundColor = [UIColor whiteColor];
            btn.backgroundColor = MakeColor(231, 239, 254);
    }
    if (btn.tag == 321) {

            btn.backgroundColor = MakeColor(231, 239, 254);
            button = (UIButton *)[[self.view viewWithTag:1234] viewWithTag:123];
            button.backgroundColor = [UIColor whiteColor];
    }
}


#pragma mark -- tableViewDelegate

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
//    cell.backgroundColor = MakeColor(214, 214, 214);
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    NSMutableDictionary *dic = array[indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"name"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([self.judgeStr isEqualToString:@"major"]) {
        //根据学院id获取专业
         NSMutableDictionary *dic = array[indexPath.row];
        [self getMajor:[dic objectForKey:@"id"]];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return array.count;
}

-(void)didClickDone
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    NSString *sex;
    NSInteger major = [pickerView selectedRowInComponent:0];
    if ([self.judgeStr isEqualToString:@"address"]) {
        if (!addressArray.count) {
            [self alertView:@"请选择地址"];
            return;
        }
        [params setObject:[addressArray[major] objectForKey:@"id"] forKey:@"apartment.id"];
    }else{
        if ([nameTf.text isEqualToString:@""]) {
            [self alertView:@"请输入姓名"];
            return;
        }
       
        
        UIButton *gender = (UIButton *)[[self.view viewWithTag:1234] viewWithTag:123];
        if ([gender.backgroundColor isEqual:MakeColor(231, 239, 254)]) {
            sex = @"1";
            [params setObject:@"1" forKey:@"sex"];
        }else{
            sex = @"2";
            [params setObject:@"2" forKey:@"sex"];
        }
        
        
        if ([self.judgeStr isEqualToString:@"name"]) {
            [params setObject:nameTf.text forKey:@"realName"];
        }
        
    }
    [self showHUD:@"保存中..."];
    [RSHttp requestWithURL:@"/user" params:params httpMethod:@"PUT" success:^(NSDictionary *data) {
        [self hidHUD];
        [self alertView:@"修改成功"];
        if ([self.judgeStr isEqualToString:@"name"]) {
            [self.delegate1 returnString:nameTf.text gender:sex judge:@"name"];
        }else{
            [self.delegate1 returnString:[addressArray[major] objectForKey:@"name"] gender:nil judge:@"address"];
        }
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self alertView:errmsg];
    }];
}

#pragma mark -- uipickView

-(void)getMajor:(NSString *)departmentId;
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    app.tocken = [UIUtils replaceAdd:app.tocken];
    
    [params setObject:departmentId forKey:@"departmentId"];
    
    [RSHttp requestWithURL:@"/user/major" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        majorArray = [data objectForKey:@"body"];
        [self initPickerView];
    } failure:^(NSInteger code, NSString *errmsg) {
        
    }];
}

-(void)initPickerView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, kUIScreenHeigth-190-64, view.frame.size.width, 40)];
    head.tag = 103;
    head.backgroundColor = MakeColor(244, 245, 246);
    view.userInteractionEnabled = YES;
    [view addSubview:head];
    view.alpha = 0.2;
    view.backgroundColor = [UIColor blackColor];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cencel)];
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
    view.tag = 101;
    [self.view addSubview:view];
    
    pickerView = [[UIPickerView alloc] init];
    pickerView.tag = 102;
    pickerView.userInteractionEnabled = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.frame = CGRectMake(0, kUIScreenHeigth-160-64, kUIScreenWidth, 160);
    [self.view addSubview:pickerView];
    
    UIButton *makeSureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    makeSureBtn.frame = CGRectMake(0, kUIScreenHeigth-190-64, kUIScreenWidth, 40);
    makeSureBtn.layer.cornerRadius = 3;
    makeSureBtn.tag = 104;
    makeSureBtn.layer.masksToBounds = YES;
    makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    makeSureBtn.backgroundColor = MakeColor(61, 169, 239);
    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [makeSureBtn addTarget:self action:@selector(didClickMakeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:makeSureBtn];
    
}

-(void)cencel
{
    [[self.view viewWithTag:101] removeFromSuperview];
    [[self.view viewWithTag:102] removeFromSuperview];
    [[self.view viewWithTag:103] removeFromSuperview];
    [[self.view viewWithTag:104] removeFromSuperview];
}

-(void)didClickMakeBtn
{
    NSInteger major = [pickerView selectedRowInComponent:0];
    NSLog(@"major = %@",[majorArray[major] objectForKey:@"id"]);
    [[self.view viewWithTag:101] removeFromSuperview];
    [[self.view viewWithTag:102] removeFromSuperview];
    [[self.view viewWithTag:103] removeFromSuperview];
    [[self.view viewWithTag:104] removeFromSuperview];
    if ([self.judgeStr isEqualToString:@"address"]) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:56789];
        [btn setTitle:[addressArray[major] objectForKey:@"name"] forState:UIControlStateNormal];
    }else{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        
        app.tocken = [UIUtils replaceAdd:app.tocken];
        [params setObject:[majorArray[major] objectForKey:@"id"] forKey:@"major.Id"];
        [RSHttp requestWithURL:@"/user" params:params httpMethod:@"PUT" success:^(NSDictionary *data) {
            [self alertView:@"修改成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        } failure:^(NSInteger code, NSString *errmsg) {
            [self alertView:errmsg];
        }];
    }

}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if ([self.judgeStr isEqualToString:@"address"]) {
        return addressArray.count;
    }
    return majorArray.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if ([self.judgeStr isEqualToString:@"address"]) {
        NSMutableDictionary *dic = addressArray[row];
        
        return [dic objectForKey:@"name"];

    }
    NSMutableDictionary *dic = majorArray[row];
    
    return [dic objectForKey:@"name"];
}

@end
