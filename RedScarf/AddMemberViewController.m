//
//  AddMemberViewController.m
//  RedScarf
//
//  Created by lishipeng on 16/1/13.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "AddMemberViewController.h"

@interface AddMemberViewController (){
}


@end

@implementation AddMemberViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self scrolView];
    [self saveBtn];
}

-(UIScrollView *) scrolView
{
    if(_scrolView) {
        return _scrolView;
    }
    _scrolView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:_scrolView];
    [_scrolView addTapAction:@selector(hideKeyboard) target:self];
    _scrolView.contentSize = CGSizeMake(kUIScreenWidth, kUIScreenHeigth * 1.2);
    return _scrolView;
}


-(RSInputField *) nameTextField
{
    if(_nameTextField){
        return _nameTextField;
    }
    _nameTextField = [[RSInputField alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth-36, 45)];
    _nameTextField.textField.placeholder = @"姓名";
    _nameTextField.iconView.image = [UIImage imageNamed:@"user_name"];
    _nameTextField.textField.delegate = self;
    return _nameTextField;
}

-(RSInputField *) idCardTextField
{
    if(_idCardTextField){
        return _idCardTextField;
    }
    _idCardTextField = [[RSInputField alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth-36, 45)];
    _idCardTextField.textField.placeholder = @"身份证号";
    _idCardTextField.iconView.image = [UIImage imageNamed:@"user_idcard"];
    _idCardTextField.textField.delegate = self;
    return _idCardTextField;
}

-(RSInputField *) stuCardTextField
{
    if(_stuCardTextField){
        return _stuCardTextField;
    }
    _stuCardTextField = [[RSInputField alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth-36, 45)];
    _stuCardTextField.textField.placeholder = @"学生证号";
    _stuCardTextField.iconView.image = [UIImage imageNamed:@"user_stucard"];
    _stuCardTextField.textField.delegate = self;
    return _stuCardTextField;
}

-(UIImageView *)imgView
{
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, 80)];
    view.image = [UIImage imageNamed:@"upload"];
    view.layer.cornerRadius = 5;
    view.clipsToBounds = YES;
    view.highlighted = NO;
    return view;
}

-(UIImageView *) id1Img
{
    if(_id1Img) {
        return _id1Img;
    }
    _id1Img = [self imgView];
    [_id1Img addTapAction:@selector(upImageView:) target:self];
    return _id1Img;
}

-(UIImageView *) id2Img
{
    if(_id2Img) {
        return _id2Img;
    }
    _id2Img = [self imgView];
    [_id2Img addTapAction:@selector(upImageView:) target:self];
    return _id2Img;
}

-(UIImageView *) stu1Img
{
    if(_stu1Img) {
        return _stu1Img;
    }
    _stu1Img = [self imgView];
    [_stu1Img addTapAction:@selector(upImageView:) target:self];
    return _stu1Img;
}

-(UIImageView *) stu2Img
{
    if(_stu2Img) {
        return _stu2Img;
    }
    _stu2Img = [self imgView];
    [_stu2Img addTapAction:@selector(upImageView:) target:self];
    return _stu2Img;
}



-(void)upImageView:(id)sender
{
    UITapGestureRecognizer *reg = (UITapGestureRecognizer *)sender;
    currentImgView = (UIImageView *)(reg.view);
    [self hideKeyboard];
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
        [self alertView:@"你没有摄像头"];
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
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        [self alertView:@"当前没有权限打开相册"];
    }
}

-(NSData *) image2Data:(UIImage *)image{
    
    NSData* pictureData = UIImageJPEGRepresentation(image,0.3);//进行图片压缩从0.0到1.0（0.0表示最大压缩，质量最低);
    NSString* pictureDataString = [pictureData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return [pictureDataString dataUsingEncoding:NSUTF8StringEncoding];
}

//选中图片进入的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}


//拍摄完成后要执行的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    currentImgView.image = [info objectForKey:UIImagePickerControllerEditedImage];
    currentImgView.highlighted = YES;
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void) hideKeyboard
{
    [self.nameTextField.textField resignFirstResponder];
    [self.idCardTextField.textField resignFirstResponder];
    [self.stuCardTextField.textField resignFirstResponder];
}

-(UIView *) imagesView
{
    if(_imagesView) {
        return _imagesView;
    }
    _imagesView = [[UIView alloc] initWithFrame:CGRectMake(18, 0, kUIScreenWidth - 36, self.id1Img.height * 2 + 80)];
    UILabel *titleLabel1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, _imagesView.width, 40)];
    titleLabel1.text = @"身份证照片：";
    titleLabel1.textColor = color_black_333333;
    [_imagesView addSubview:titleLabel1];

    self.id1Img.top = titleLabel1.bottom;
    self.id1Img.left = (_imagesView.width - 2*self.id1Img.width - 40)/2;
    [_imagesView addSubview:self.id1Img];
    
    self.id2Img.top = self.id1Img.top;
    self.id2Img.left = self.id1Img.right + 40;
    [_imagesView addSubview:self.id2Img];
    
    UILabel *titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.id2Img.bottom, _imagesView.width, 40)];
    titleLabel2.text = @"学生证照片：";
    titleLabel2.textColor = color_black_333333;
    [_imagesView addSubview:titleLabel2];
    self.stu1Img.top = self.id1Img.bottom + 40;
    self.stu1Img.left = self.id1Img.left;
    [_imagesView addSubview:self.stu1Img];
    
    self.stu2Img.top = self.stu1Img.top;
    self.stu2Img.left = self.id2Img.left;
    [_imagesView addSubview:self.stu2Img];

    return _imagesView;
}

-(UIButton *)saveBtn
{
    if(_saveBtn) {
        return _saveBtn;
    }
    _saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 45)];
    _saveBtn.bottom = kUIScreenHeigth;
    [_saveBtn setBackgroundColor:color_blue_5999f8];
    [self.view addSubview:_saveBtn];
    [_saveBtn setTitle:@"提交" forState:UIControlStateNormal];
    return _saveBtn;
}
@end