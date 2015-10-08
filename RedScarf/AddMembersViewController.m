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
    
    NSData *idData;
    NSData *studentIdData;
    
    NSMutableDictionary *imageDic;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"添加校园兼职";
    imgArray = [NSMutableArray arrayWithObjects:@"xingming2x",@"shouji2x",@"zhuzhi2x",@"shenfen2x",@"xuesheng2x", nil];
    imageDic = [NSMutableDictionary dictionary];
    [self navigationBar];
    [self initView];
}

-(void)initView
{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
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
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 116+41*3+10+130*i, kUIScreenWidth-40, 40)];
        label.textColor = color155;
        label.font = textFont16;
        [scroll addSubview:label];
        
        papersImg = [[UIButton alloc] initWithFrame:CGRectMake(20, 116+41*3+10+130*i+45, 120, 80)];
        [papersImg addTarget:self action:@selector(upImageView:) forControlEvents:UIControlEventTouchUpInside];
        
        [papersImg setImage:[UIImage imageNamed:@"sn"] forState:UIControlStateNormal];
        [scroll addSubview:papersImg];
        
        if (i == 0) {
            papersImg.tag = 1000;
            label.text = @"身份证照片：";
        }
        if (i == 1) {
            papersImg.tag = 1001;
            label.text = @"学生证照片：";
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
    [saveBtn addTarget:self action:@selector(saveMsg) forControlEvents:UIControlEventTouchUpInside];
}

////////获取地址
-(void)selectAddress
{
    [self getMessage];
}

-(void)getMessage
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    app.tocken = [UIUtils replaceAdd:app.tocken];
    [params setObject:app.tocken forKey:@"token"];
    
    [RedScarf_API requestWithURL:@"/team/apartments" params:params httpMethod:@"GET" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([result objectForKey:@"success"]) {
            addressArray = [[result objectForKey:@"msg"] objectForKey:@"apartments"];
            [self initPickerView];
        }
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


////////////////
-(void)saveMsg
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:app.tocken forKey:@"token"];
    
    NSInteger major = [pickerView selectedRowInComponent:0];
    //    NSLog(@"major = %@",[addressArray[major] objectForKey:@"id"]);
    for (int i = 0; i < 4; i++) {
        UITextField *tf = (UITextField *)[[self.view viewWithTag:10000] viewWithTag:100+i];
        if (i == 0) {
            [params setObject:tf.text forKey:@"realName"];
        }
        if (i == 1) {
            [params setObject:tf.text forKey:@"mobilePhone"];
        }
        if (i == 2) {
            [params setObject:[addressArray[major] objectForKey:@"id"] forKey:@"apartment.id"];
        }
        if (i == 3) {
            [params setObject:tf.text forKey:@"studentIdCardNo"];
        }
        if (i == 4) {
            [params setObject:tf.text forKey:@"idCardNo"];
        }
    }

    
    //分界线的标识符
    NSString *TWITTERFON_FORM_BOUNDARY = @"AaB03x";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://192.168.1.47:8080/user?token=%@",app.tocken]]cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:10];
    
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //要上传的图片
    UIImage *image;//=[params objectForKey:@"pic"];
    //得到图片的data
    //NSData* data = UIImagePNGRepresentation(image);
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [params allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++) {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        //如果key不是pic，说明value是字符类型，比如name：Boris
        //if(![key isEqualToString:@"pic"]) {
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //[body appendString:@"Content-Transfer-Encoding: 8bit"];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[params objectForKey:key]];
        //}
    }
    ////添加分界线，换行
    //[body appendFormat:@"%@\r\n",MPboundary];
    
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    //循环加入上传图片
    keys = [imageDic allKeys];
    for(int i = 0; i< [keys count] ; i++){
        //要上传的图片
        image = [imageDic objectForKey:[keys objectAtIndex:i]];
        //得到图片的data
        NSData* data =  UIImagePNGRepresentation(image);
        NSMutableString *imgbody = [[NSMutableString alloc] init];
        //此处循环添加图片文件
        //添加图片信息字段
        //声明pic字段，文件名为boris.png
        //[body appendFormat:[NSString stringWithFormat: @"Content-Disposition: form-data; name=\"File\"; filename=\"%@\"\r\n", [keys objectAtIndex:i]]];
        
        ////添加分界线，换行
        [imgbody appendFormat:@"%@\r\n",MPboundary];
        [imgbody appendFormat:@"Content-Disposition: form-data; name=\"File%d\"; filename=\"%@.png\"\r\n", i, [keys objectAtIndex:i]];
        //声明上传文件的格式
        [imgbody appendFormat:@"Content-Type: image/png\r\n\r\n"];
        
        NSLog(@"上传的图片：%d  %@", i, [keys objectAtIndex:i]);
        
        //将body字符串转化为UTF8格式的二进制
        //[myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
        [myRequestData appendData:[imgbody dataUsingEncoding:NSUTF8StringEncoding]];
        //将image的data加入
        [myRequestData appendData:data];
        [myRequestData appendData:[ @"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    //声明结束符：--AaB03x--
    NSString *end=[[NSString alloc]initWithFormat:@"%@\r\n",endMPboundary];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    //设置HTTPHeader
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    //[request setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
    //[request setValue:@"UTF-8" forHTTPHeaderField:@"Charsert"];
    //设置Content-Length
    [request setValue:[NSString stringWithFormat:@"%lu", (unsigned long)[myRequestData length]] forHTTPHeaderField:@"Content-Length"];
    //设置http body
    [request setHTTPBody:myRequestData];
    //http method
    [request setHTTPMethod:@"POST"];
    
    
    //建立连接，设置代理
    [NSURLConnection connectionWithRequest:request delegate:self];
    
    //设置接受response的data
//    if (conn) {
//        mResponseData = [NSMutableData data];
//    }
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    if ([dataString containsString:@"true"]) {
        [self alertView:@"修改成功"];
        return;
    }else{
        [self alertView:@"修改失败"];
    }
    NSLog(@"dataString = %@",dataString);
    
}

-(void)save
{
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    [params setObject:app.tocken forKey:@"token"];

    NSInteger major = [pickerView selectedRowInComponent:0];
//    NSLog(@"major = %@",[addressArray[major] objectForKey:@"id"]);
    for (int i = 0; i < 4; i++) {
        UITextField *tf = (UITextField *)[[self.view viewWithTag:10000] viewWithTag:100+i];
        if (i == 0) {
            [params setObject:tf.text forKey:@"realName"];
        }
        if (i == 1) {
            [params setObject:tf.text forKey:@"mobilePhone"];
        }
        if (i == 2) {
            [params setObject:[addressArray[major] objectForKey:@"id"] forKey:@"apartment.id"];
        }
        if (i == 3) {
            [params setObject:tf.text forKey:@"studentIdCardNo"];
        }
        if (i == 4) {
            [params setObject:tf.text forKey:@"idCardNo"];
        }
    }
//    [params setObject:studentIdData forKey:@"studentIdCardPics"];
//
//    [params setObject:idData forKey:@"idCardPics"];


    
    [self showHUD:@"正在加载"];
    [RedScarf_API requestWithURL:[NSString stringWithFormat:@"/user?token=%@",app.tocken] params:params httpMethod:@"POST" block:^(id result) {
        NSLog(@"result = %@",result);
        if ([[result objectForKey:@"success"] boolValue]) {
           
        }else
        {
            [self alertView:[result objectForKey:@"msg"]];
        }
        [self hidHUD];
    }];

}

-(void)upImageView:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    currentTag = btn.tag;
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
        // [self presentModalViewController:pichker animated:YES];
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
    
//    if (imageDic.count == 2) {
        if (btn.tag == 1000) {
            [imageDic setObject:image1 forKey:@"idCardPics"];
        }else{
            [imageDic setObject:image1 forKey:@"studentIdCardPics"];
        }

//    }else{
//        [imageArray addObject:image1];
//    }
    
    
       [btn setImage:image1 forState:UIControlStateNormal];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *imageFile=[NSTemporaryDirectory() stringByAppendingPathComponent:@"/img.png"];
    
    NSData *imageData = UIImagePNGRepresentation(image1);
    if (btn.tag == 1000) {
        idData = imageData;
    }else{
        studentIdData = imageData;
    }
    
    [imageData writeToFile:imageFile atomically:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

//- (NSString *)saveImage:(UIImage *)tempImage WithName:(NSString *)imageName{
//    NSData* imageData;
//    
//    //判断图片是不是png格式的文件
//    if (UIImagePNGRepresentation(tempImage)) {
//        //返回为png图像。
//        imageData = UIImagePNGRepresentation(tempImage);
//    }else {
//        //返回为JPEG图像。
//        imageData = UIImageJPEGRepresentation(tempImage, 1.0);
//    }
//    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
//    
//    NSString* documentsDirectory = [paths objectAtIndex:0];
//    
//    NSString* fullPathToFile = [documentsDirectory stringByAppendingPathComponent:imageName];
//    
//    NSArray *nameAry=[fullPathToFile componentsSeparatedByString:@"/"];
//    NSLog(@"===fullPathToFile===%@",fullPathToFile);
//    NSLog(@"===FileName===%@",[nameAry objectAtIndex:[nameAry count]-1]);
//    
//    [imageData writeToFile:fullPathToFile atomically:NO];
//    return fullPathToFile;
//}


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


-(void)didClickLeft
{
    [self.navigationController popViewControllerAnimated:YES];
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
