//
//  AddMembersViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/23.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "AddMembersViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface AddMembersViewController ()

@end

@implementation AddMembersViewController
{
    NSMutableArray *imgArray;
    UIImageView *headView;
    UIButton *papersImg;
    int currentTag;
    UIPickerView *pickerView;
    NSMutableArray *majorArray;
    NSMutableArray *addressArray;
    
    NSData *idData,*idData1;
    NSData *stuData,*stuData1;
    
    UIImage *idImage,*idImage1;
    UIImage *stuImage,*stuImage1;
    
    NSMutableDictionary *imageDic;

}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *navigationView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 64)];
    [self.view addSubview:navigationView];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-60, 10, 160, 54)];
    [self.view addSubview:title];
    title.text = @"添加校园兼职";
    
    UIImageView *back = [[UIImageView alloc] initWithFrame:CGRectMake(15, 20, 30, 40)];
    back.image = [UIImage imageNamed:@"newfanhui"];
    back.userInteractionEnabled = YES;
    [self.view addSubview:back];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(comeToBack)];
    tap.numberOfTapsRequired = 1;
    [back addGestureRecognizer:tap];

    
    
    self.title = @"添加校园兼职";
    imgArray = [NSMutableArray arrayWithObjects:@"xingming2x",@"shouji2x",@"zhuzhi2x",@"shenfen2x",@"xuesheng2x", nil];
    imageDic = [NSMutableDictionary dictionary];
    [self navigationBar];
    [self initView];
}

-(void)comeToBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initView
{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, kUIScreenHeigth-64)];
    scroll.tag = 10000;
    scroll.contentSize = CGSizeMake(0, kUIScreenHeigth*1.2);
    scroll.backgroundColor = bgcolor;
    [self.view addSubview:scroll];
    
    for (int i = 0; i < 2; i++) {
        UITextField *nameTF = [[UITextField alloc] initWithFrame:CGRectMake(20, 15+41*i, kUIScreenWidth-40, 40)];
        nameTF.layer.masksToBounds = YES;
        nameTF.delegate = self;
        nameTF.layer.cornerRadius = 5;
        nameTF.textAlignment = NSTextAlignmentCenter;
        nameTF.backgroundColor = [UIColor whiteColor];
        [scroll addSubview:nameTF];
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(17, 10, 15, 20)];
        [nameTF addSubview:img];
        
        if (i == 0) {
            img.image = [UIImage imageNamed:imgArray[0]];
            nameTF.placeholder = @"姓名";
            nameTF.tag = 100;
        }
        if (i == 1) {
            img.image = [UIImage imageNamed:imgArray[1]];
            nameTF.placeholder = @"手机号码";
            nameTF.tag = 101;
        }
    }
    
    for (int i = 0; i < 3; i++) {
        UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(20, 116+41*i, kUIScreenWidth-40, 40)];
        tf.layer.masksToBounds = YES;
        tf.delegate = self;
        tf.backgroundColor = [UIColor whiteColor];
        tf.layer.cornerRadius = 5;
        tf.textAlignment = NSTextAlignmentCenter;
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 20, 15)];
        
        [tf addSubview:img];
        
        if (i == 0) {
            UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth-40, 40)];
            [btn addTarget:self action:@selector(selectAddress) forControlEvents:UIControlEventTouchUpInside];
            [tf addSubview:btn];
            
            img.frame = CGRectMake(17, 10, 15, 20);
            img.image = [UIImage imageNamed:imgArray[2]];
            tf.placeholder = @"住址";
            tf.tag = 102;
        }
        if (i == 1) {
            img.image = [UIImage imageNamed:imgArray[3]];
            tf.placeholder = @"学生证号";
            tf.tag = 103;
        }
        if (i == 2) {
            img.image = [UIImage imageNamed:imgArray[4]];
            tf.placeholder = @"身份证号";
            tf.tag = 104;
        }
        [scroll addSubview:tf];
    }
   
    for (int i = 0; i < 2; i++) {
        for (int j = 0; j < 2; j++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 116+41*3+10+130*i, kUIScreenWidth-40, 40)];
            label.textColor = color155;
            label.font = textFont16;
            [scroll addSubview:label];
            
            papersImg = [[UIButton alloc] initWithFrame:CGRectMake((kUIScreenWidth-240)/3+j*((kUIScreenWidth-240)/3+120), 116+41*3+10+130*i+45, 120, 80)];
            [papersImg addTarget:self action:@selector(upImageView:) forControlEvents:UIControlEventTouchUpInside];
            
            [scroll addSubview:papersImg];
            
            if (i == 0 && j == 0) {
                papersImg.tag = 1000;
                if (idImage == nil) {
                    [papersImg setImage:[UIImage imageNamed:@"sn"] forState:UIControlStateNormal];
                }else{
                    [papersImg setImage:idImage forState:UIControlStateNormal];
                }
                
                label.text = @"身份证照片：";
            }
            if (i == 1 && j == 0) {
                papersImg.tag = 1001;
                if (stuImage == nil) {
                    [papersImg setImage:[UIImage imageNamed:@"sn"] forState:UIControlStateNormal];
                }else{
                    [papersImg setImage:stuImage forState:UIControlStateNormal];
                }
                label.text = @"学生证照片：";
            }
            if (i == 0 && j == 1) {
                papersImg.tag = 1002;
                if (idImage1 == nil) {
                    [papersImg setImage:[UIImage imageNamed:@"sn"] forState:UIControlStateNormal];
                }else{
                    [papersImg setImage:idImage1 forState:UIControlStateNormal];
                }
            }
            if (i == 1 && j == 1) {
                papersImg.tag = 1003;
                if (stuImage1 == nil) {
                    [papersImg setImage:[UIImage imageNamed:@"sn"] forState:UIControlStateNormal];
                }else{
                    [papersImg setImage:stuImage1 forState:UIControlStateNormal];
                }
            }
        }
    }
        
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveBtn.frame = CGRectMake(20, 116+41*3+10+130*2+15, kUIScreenWidth-40, 50);
    [saveBtn setTitle:@"完成" forState:UIControlStateNormal];
    saveBtn.titleLabel.font = textFont20;
    [scroll addSubview:saveBtn];
    saveBtn.layer.masksToBounds = YES;
    saveBtn.layer.cornerRadius = 5;
    [saveBtn setBackgroundColor:MakeColor(85, 130, 255)];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [saveBtn addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
}

////////获取地址
-(void)selectAddress
{
    [self getMessage];
}

-(void)getMessage
{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [RSHttp requestWithURL:@"/team/apartments" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        addressArray = [[data objectForKey:@"msg"] objectForKey:@"apartments"];
        [self initPickerView];
    } failure:^(NSInteger code, NSString *errmsg) {
    }];
}

-(void)initPickerView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
    UIView *head = [[UIView alloc] initWithFrame:CGRectMake(0, kUIScreenHeigth-190, view.frame.size.width, 40)];
    head.tag = 1000003;
    head.backgroundColor = MakeColor(244, 245, 246);
    view.userInteractionEnabled = YES;
    [view addSubview:head];
    view.alpha = 0.2;
    view.backgroundColor = [UIColor blackColor];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cencel)];
    tap.numberOfTapsRequired = 1;
    [view addGestureRecognizer:tap];
    view.tag = 1000001;
    [self.view addSubview:view];
    
    pickerView = [[UIPickerView alloc] init];
    pickerView.tag = 1000002;
    pickerView.userInteractionEnabled = YES;
    pickerView.delegate = self;
    pickerView.dataSource = self;
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.frame = CGRectMake(0, kUIScreenHeigth-160, kUIScreenWidth, 160);
    [self.view addSubview:pickerView];
    
    UIButton *makeSureBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    makeSureBtn.frame = CGRectMake(0, kUIScreenHeigth-190, kUIScreenWidth, 40);
    makeSureBtn.layer.cornerRadius = 3;
    makeSureBtn.tag = 1000004;
    makeSureBtn.layer.masksToBounds = YES;
    makeSureBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    makeSureBtn.backgroundColor = MakeColor(61, 169, 239);
    [makeSureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [makeSureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [makeSureBtn addTarget:self action:@selector(didClickMakeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:makeSureBtn];
    
}

-(void)didClickMakeBtn
{
    NSInteger major = [pickerView selectedRowInComponent:0];
    NSLog(@"major = %@",[addressArray[major] objectForKey:@"id"]);
    
    UITextField *tf = (UITextField *)[[self.view viewWithTag:10000] viewWithTag:102];
    tf.text = [addressArray[major] objectForKey:@"name"];
    [[self.view viewWithTag:1000001] removeFromSuperview];
    [[self.view viewWithTag:1000002] removeFromSuperview];
    [[self.view viewWithTag:1000003] removeFromSuperview];
    [[self.view viewWithTag:1000004] removeFromSuperview];
   
    
}

-(void)cencel
{
    [[self.view viewWithTag:1000001] removeFromSuperview];
    [[self.view viewWithTag:1000002] removeFromSuperview];
    [[self.view viewWithTag:1000003] removeFromSuperview];
    [[self.view viewWithTag:1000004] removeFromSuperview];
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return addressArray.count;
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSMutableDictionary *dic = addressArray[row];
        
    return [dic objectForKey:@"name"];
}

-(void)save
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];

    NSInteger major = [pickerView selectedRowInComponent:0];
    for (int i = 0; i < 5; i++) {
        UITextField *tf = (UITextField *)[[self.view viewWithTag:10000] viewWithTag:100+i];
        if (i == 0) {
            if (tf.text.length) {
                [params setObject:tf.text forKey:@"realName"];
            }else{
                [self alertView:@"请输入姓名"];
                return;
            }
            /*if (![UIUtils isValidateCharacter:tf.text]) {
                [self alertView:@"名字为两个以上的汉字"];
                return;
            }*/
        }
        if (i == 1) {
            if (tf.text.length && tf.text.length == 11) {
                [params setObject:tf.text forKey:@"mobilePhone"];
            }else{
                [self alertView:@"请输入正确的手机号"];
                return;
            }
            BOOL phoneNum = [UIUtils checkPhoneNumInput:tf.text];
            if (!phoneNum) {
                [self alertView:@"输入的手机号有误"];
                return;
            }
        }
        if (i == 2) {
            NSString *str = [addressArray[major] objectForKey:@"id"];
            if (str) {
                [params setObject:[addressArray[major] objectForKey:@"id"] forKey:@"apartment.id"];
            }else{
                [self alertView:@"地址不能为空"];
                return;
            }
            
        }
        if (i == 3) {
            if (tf.text.length) {
                [params setObject:tf.text forKey:@"studentIdCardNo"];
            }else{
                [self alertView:@"请输入学生证号"];
                return;
            }
            
        }
        if (i == 4) {
            if (tf.text.length) {
                [params setObject:tf.text forKey:@"idCardNo"];
            }else{
                [self alertView:@"请输入身份证号"];
                return;
            }
        }
    }

    NSArray *idArray = [NSArray arrayWithObjects:[[NSString alloc] initWithData:idData encoding:NSUTF8StringEncoding],[[NSString alloc] initWithData:idData1 encoding:NSUTF8StringEncoding], nil];
    NSArray *stuArray = [NSArray arrayWithObjects:[[NSString alloc] initWithData:stuData encoding:NSUTF8StringEncoding],[[NSString alloc] initWithData:stuData1 encoding:NSUTF8StringEncoding], nil];
    [params setObject:idArray forKey:@"idCardPics"];
    [params setObject:stuArray forKey:@"studentIdCardPics"];

    [RSHttp postDataWithURL:@"/user/2" params:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        if(idData){
            [formData appendPartWithFormData:idData name:@"idCardPics"];
        }
        if(idData1) {
            [formData appendPartWithFormData:idData1 name:@"idCardPics"];
        }
        if(stuData) {
            [formData appendPartWithFormData:stuData name:@"studentIdCardPics"];
        }
        if(stuData1) {
            [formData appendPartWithFormData:stuData1 name:@"studentIdCardPics"];
        }
    } success:^(NSDictionary *data) {
        [self hidHUD];
        [self alertView:@"添加成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self alertView:errmsg];
    }];
    
    /*[params setObject:idArray forKey:@"idCardPics"];
    [params setObject:stuArray forKey:@"studentIdCardPics"];
    
    [self showHUD:@"正在加载"];
    [RSHttp requestWithURL:[NSString stringWithFormat:@"/user/2?token=%@",app.tocken] params:params httpMethod:@"POST" success:^(NSDictionary *data) {
        [self hidHUD];
        [self alertView:@"添加成功"];
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self alertView:errmsg];
    }];*/
}

-(void)upImageView:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    currentTag = (int)btn.tag;
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"设置头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机",@"打开图库", nil];
    [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self didClickCamera:nil];
            break;
        case 1:
            [self didClickLibray:nil];
            break;
        default:
            break;
    }
}

//调用相机
- (void)didClickCamera:(id)sender
{
    //判断是否可以打开相机
    if ([UIImagePickerController  isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera ]) {
        
        UIImagePickerController *pichker = [[UIImagePickerController alloc] init];
        pichker.delegate = self;
        pichker.allowsEditing = YES;//是否可编辑
        //摄像头
        pichker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:pichker animated:YES completion:nil];
        
        
    } else{
        //
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你没有摄像头" delegate:self cancelButtonTitle:@"Drat!" otherButtonTitles:@"取消", nil];
        [alert show];
    }
    
}

//点击Cancel按钮后执行方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}

//调用图片库
- (void)didClickLibray:(id)sender
{
    //相册是可以用模拟器打开的
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.allowsEditing = YES;//是否可以编辑
        
        //打开相册选择照片
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //[self presentModalViewController:picker  animated:YES];
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
}

-(NSString *) image2String:(UIImage *)image{
    
    NSData* pictureData = UIImageJPEGRepresentation(image,0.3);//进行图片压缩从0.0到1.0（0.0表示最大压缩，质量最低);
    NSString* pictureDataString = [pictureData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return pictureDataString;
}
-(NSData *) image2Data:(UIImage *) image
{
    //判断图片是不是png格式的文件
    if (UIImagePNGRepresentation(image)) {
        //返回为png图像。
        return UIImagePNGRepresentation(image);
    }else {
        //返回为JPEG图像。
        return UIImageJPEGRepresentation(image, 1.0);
    }
    return nil;
}

//选中图片进入的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissModalViewControllerAnimated:YES];
}


//拍摄完成后要执行的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIButton *btn = (UIButton *)[[self.view viewWithTag:10000] viewWithTag:currentTag];

    UIImage *image1 = [info objectForKey:UIImagePickerControllerEditedImage];
    
    [btn setImage:image1 forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    if (btn.tag == 1000) {
        idData = [[self image2String:image1] dataUsingEncoding:NSUTF8StringEncoding];
        idImage = image1;
    }else if (btn.tag == 1001) {
        stuData = [[self image2String:image1] dataUsingEncoding:NSUTF8StringEncoding];
        stuImage = image1;
    }else if (btn.tag == 1002) {
        idData1 = [[self image2String:image1] dataUsingEncoding:NSUTF8StringEncoding];
        idImage1 = image1;
    }else if (btn.tag == 1003) {
        stuData1 = [[self image2String:image1] dataUsingEncoding:NSUTF8StringEncoding];
        stuImage1 = image1;
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark 结束时恢复界面高度
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.view.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view endEditing:YES];
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
