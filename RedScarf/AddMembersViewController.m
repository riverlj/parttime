//
//  AddMembersViewController.m
//  RedScarf
//
//  Created by lishipeng on 16/1/13.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "AddMembersViewController.h"
#import "RSUIView.h"

@interface AddMembersViewController (){
    NSMutableArray *pickerArray;
    NSNumber *buildingid;
}

@end

@implementation AddMembersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    pickerArray = [NSMutableArray array];
    self.title = @"添加校园兼职";
    [self.saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
    UIView *view = [RSUIView roundRectViewWithFrame:CGRectMake(18, 18, kUIScreenWidth - 36, 45)];
    [view addSubview:self.nameTextField];
    [self.nameTextField addSubview:[RSUIView lineWithFrame:CGRectMake(0, self.nameTextField.height-0.8, self.nameTextField.width, 0.8)]];
    
    self.phoneTextField.top = self.nameTextField.bottom;
    [view addSubview:self.phoneTextField];
    view.height = self.phoneTextField.bottom;
    [self.scrolView addSubview:view];
    
    view = [RSUIView roundRectViewWithFrame:CGRectMake(18, view.bottom + 18, kUIScreenWidth - 36, 45)];
    [view addSubview:self.buildingTextField];
    [self.buildingTextField addSubview:[RSUIView lineWithFrame:CGRectMake(0, self.buildingTextField.height-0.8, self.buildingTextField.width, 0.8)]];
    self.idCardTextField.top = self.buildingTextField.bottom;
    [view addSubview:self.idCardTextField];
    [self.idCardTextField addSubview:[RSUIView lineWithFrame:CGRectMake(0, self.idCardTextField.height-0.8, self.idCardTextField.width, 0.8)]];
    self.stuCardTextField.top = self.idCardTextField.bottom;
    [view addSubview:self.stuCardTextField];
    view.height = self.stuCardTextField.bottom;
    [self.scrolView addSubview: view];
    
    self.imagesView.top = view.bottom;
    [self.scrolView addSubview:self.imagesView];
    self.scrolView.contentSize = CGSizeMake(kUIScreenWidth, self.imagesView.bottom + 200);
    [self getMessage];

}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self comeBack:nil];
}

-(void) didClickLeft
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

-(RSInputField *) phoneTextField
{
    if(_phoneTextField) {
        return _phoneTextField;
    }
    _phoneTextField = [[RSInputField alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth-36, 45)];
    _phoneTextField.textField.placeholder = @"手机号";
    _phoneTextField.iconView.image = [UIImage imageNamed:@"user_mobile"];
    _phoneTextField.textField.delegate = self;
    _phoneTextField.textField.keyboardType = UIKeyboardTypePhonePad;
    return _phoneTextField;
}

-(RSInputField *) buildingTextField
{
    if(_buildingTextField) {
        return _buildingTextField;
    }
    _buildingTextField = [[RSInputField alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth-36, 45)];
    _buildingTextField.textField.placeholder = @"住址";
    _buildingTextField.iconView.image = [UIImage imageNamed:@"user_address"];
    _buildingTextField.textField.delegate = self;
    _buildingTextField.textField.inputView = self.pickerView;
    _buildingTextField.textField.inputAccessoryView = self.doneToolbar;
    _buildingTextField.textField.clearButtonMode = UITextFieldViewModeNever;
    return _buildingTextField;
}

-(UIPickerView *) pickerView
{
    if(_pickerView) {
        return _pickerView;
    }
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(kUIScreenHeigth - 216, 0, kUIScreenWidth, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    return _pickerView;
}

-(UIButton *) doneToolbar
{
    if(_doneToolbar) {
        return _doneToolbar;
    }
    _doneToolbar = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 40)];
    [_doneToolbar setTitle:@"确定" forState:UIControlStateNormal];
    [_doneToolbar setBackgroundColor:color_blue_5999f8];
    [_doneToolbar addTarget:self action:@selector(selectBuilding) forControlEvents:UIControlEventTouchUpInside];
    return _doneToolbar;
}


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return [pickerArray count];
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [[pickerArray objectAtIndex:row] valueForKey:@"name"];
}

-(void) pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if([pickerArray count] > 0) {
        self.buildingTextField.textField.text = [[pickerArray objectAtIndex:row] valueForKey:@"name"];
        buildingid = [[pickerArray objectAtIndex:row] valueForKey:@"id"];
    }
}

-(void)selectBuilding
{
    [self.buildingTextField.textField endEditing:YES];
    [self.idCardTextField.textField becomeFirstResponder];
}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self showHUD:@"加载中..."];
    [RSHttp requestWithURL:@"/team/apartments" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [self hidHUD];
        pickerArray = [[data objectForKey:@"msg"] objectForKey:@"apartments"];
        
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
    }];
}

-(void) hideKeyboard
{
    [super hideKeyboard];
    [self.phoneTextField.textField resignFirstResponder];
    [self.buildingTextField.textField resignFirstResponder];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.nameTextField.textField) {
        [self.phoneTextField.textField becomeFirstResponder];
    } else if(textField == self.phoneTextField.textField) {
        [self.phoneTextField.textField becomeFirstResponder];
    } else if(textField == self.buildingTextField.textField) {
        [self.idCardTextField.textField becomeFirstResponder];
    } else if(textField == self.idCardTextField.textField) {
        [self.stuCardTextField.textField becomeFirstResponder];
    }
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == self.buildingTextField.textField && buildingid == 0) {
        self.buildingTextField.textField.text = @"";
    }
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint point = CGPointMake(0, -64);
  
    if(textField == self.buildingTextField.textField) {
        point = CGPointMake(0, 45-64);
    } else if(textField == self.idCardTextField.textField) {
        point = CGPointMake(0, 90-64);
    } else if(textField == self.stuCardTextField.textField) {
        point = CGPointMake(0, 135-64);
    }
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^ {
                         self.scrolView.contentOffset = point;
                     }
                     completion:^(BOOL finished) {
                     }];
}

-(void)save
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(self.nameTextField.textField.text.length) {
        [params setObject:self.nameTextField.textField.text forKey:@"realName"];
    } else {
        [self showToast:@"请输入姓名"];
        [self.nameTextField.textField becomeFirstResponder];
        return;
    }
    
    if(self.phoneTextField.textField.text.length && [self.phoneTextField.textField.text isMobile]) {
        [params setObject:self.phoneTextField.textField.text forKey:@"mobilePhone"];
    } else {
        [self showToast:@"请输入正确的手机号"];
        [self.phoneTextField.textField becomeFirstResponder];
        return;
    }
    
    if(buildingid == 0) {
        [self showToast:@"请选择住址"];
        [self.buildingTextField.textField becomeFirstResponder];
        return;
    }
    [params setObject:buildingid forKey:@"apartment.id"];
    if(self.idCardTextField.textField.text.length) {
        [params setObject:self.idCardTextField.textField.text forKey:@"idCardNo"];
    }else {
        [self showToast:@"请输入身份证号"];
        [self.stuCardTextField.textField becomeFirstResponder];
        return;
    }
    if(self.stuCardTextField.textField.text.length) {
        [params setObject:self.stuCardTextField.textField.text forKey:@"studentIdCardNo"];
    } else {
        [self showToast:@"请输入学生证号"];
        [self.stuCardTextField.textField becomeFirstResponder];
        return;
    }
    if(!self.id1Img.highlighted && !self.id2Img.highlighted) {
        [self showToast:@"请至少提交一张身份证照片"];
        return;
    }
    if(!self.stu2Img.highlighted && !self.stu1Img.highlighted) {
        [self showToast:@"请至少提交一张学生证照片"];
        return;
    }
    
    [RSHttp postDataWithURL:@"/user/2" params:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(self.id1Img.highlighted){
            [formData appendPartWithFormData:[self image2Data:self.id1Img.image] name:@"idCardPics"];
        }
        if(self.id2Img.highlighted) {
            [formData appendPartWithFormData:[self image2Data:self.id2Img.image] name:@"idCardPics"];
        }
        if(self.stu1Img) {
            [formData appendPartWithFormData:[self image2Data:self.stu1Img.image] name:@"studentIdCardPics"];
        }
        if(self.stu2Img) {
            [formData appendPartWithFormData:[self image2Data:self.stu2Img.image] name:@"studentIdCardPics"];
        }
    } success:^(NSDictionary *data) {
        [self hidHUD];
        [self alertView:@"添加成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self alertView:errmsg];
    }];
}

@end
