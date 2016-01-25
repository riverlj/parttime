//
//  UserCertViewController.m
//  RedScarf
//
//  Created by lishipeng on 16/1/13.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "UserCertViewController.h"
#import "RSCatchline.h"
@interface UserCertViewController (){
    NSArray *arr;
    UIImageView *statusImg;
    UILabel *statusTitle;
    UILabel *statusSubtitile;
}

@end

@implementation UserCertViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"实名认证";
    self.status = 0;
    arr = [NSArray arrayWithObjects: @{@"img":@"round_warning", @"title":@"网络加载失败", @"subtitle":@"请稍后再试"}, @{@"img":@"round_warning", @"title":@"待审核", @"subtitle":@"审核时间为3个工作日，请耐心关注"},
        @{@"img":@"round_ok", @"title":@"审核通过", @"subtitle":@"如需修改，请联系校园CEO。"},
        @{@"img":@"round_error", @"title":@"审核未通过", @"subtitle":@"请填写真实信息后重新提交审核"}, nil];
    
    UIView *statusView = [RSUIView roundRectViewWithFrame:CGRectMake(18, 10, kUIScreenWidth-36, 96)];
    statusImg = [[UIImageView alloc] initWithFrame:CGRectMake(13, 21, 54, 54)];
    [statusView addSubview:statusImg];
    statusTitle = [[UILabel alloc] initWithFrame:CGRectMake(statusImg.right+18, statusImg.top + 10, statusView.width -  statusImg.right - 36, 18)];
    statusTitle.font = textFont18;
    statusTitle.textColor = color_black_333333;
    [statusView addSubview:statusTitle];
    statusSubtitile = [[UILabel alloc] initWithFrame:CGRectMake(statusTitle.left, statusTitle.bottom+11, statusTitle.width+15, 12)];
    statusSubtitile.font = textFont12;
    statusSubtitile.textColor = color_black_333333;
    statusSubtitile.numberOfLines = 0;
    [statusView addSubview:statusSubtitile];
    [self.scrolView addSubview:statusView];

    
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(statusView.left, statusView.bottom+15, statusView.width, 20)];
    label.text = @"填写规范：";
    label.textColor = color_black_666666;
    
    [self.scrolView addSubview:label];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(label.left, label.bottom , label.width, 30)];
    label1.numberOfLines = 0;
    label1.font = textFont12;
    label1.textColor = color_black_666666;
    label1.text = @"1.请上传本人手持身份证照片,要求脸部清晰，照片清晰\n2.信息请与证件内容一致";
    [label1 sizeToFit];
    [self.scrolView addSubview:label1];
    
    
    UIView *view = [RSUIView roundRectViewWithFrame:CGRectMake(18, label1.bottom + 18, kUIScreenWidth - 36, 45)];
    [view addSubview:self.nameTextField];
     [self.nameTextField addSubview:[RSUIView lineWithFrame:CGRectMake(0, self.nameTextField.height-0.8, self.nameTextField.width, 0.8)]];
    
    self.idCardTextField.top = self.nameTextField.bottom;
    [view addSubview:self.idCardTextField];
    [self.idCardTextField addSubview:[RSUIView lineWithFrame:CGRectMake(0, self.idCardTextField.height-0.8, self.idCardTextField.width, 0.8)]];
    
    self.stuCardTextField.top = self.idCardTextField.bottom;
    [view addSubview:self.stuCardTextField];
   
    view.height = self.stuCardTextField.bottom;
    [self.scrolView addSubview: view];
    
    self.imagesView.top = view.bottom;
    [self.scrolView addSubview:self.imagesView];
    
    self.scrolView.contentSize = CGSizeMake(kUIScreenWidth, self.imagesView.bottom + 200);
    
    [self.saveBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    [self.saveBtn addTarget:self action:@selector(identification) forControlEvents:UIControlEventTouchUpInside];
    [self getMessage];
}

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    CGPoint point = CGPointMake(0, -64 + 161);
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear
                     animations:^ {
                         self.scrolView.contentOffset = point;
                     }
                     completion:^(BOOL finished) {
                     }];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    if(textField == self.nameTextField.textField) {
        [self.idCardTextField.textField becomeFirstResponder];
    } else if (textField == self.idCardTextField.textField) {
        [self.stuCardTextField.textField becomeFirstResponder];
    }
    return YES;
}

-(void) identification
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if(self.nameTextField.textField.text.length) {
        [params setObject:self.nameTextField.textField.text forKey:@"realName"];
    } else {
        [self showToast:@"请输入姓名"];
        [self.nameTextField.textField becomeFirstResponder];
        return;
    }
    
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
    
    if(!self.id1Img.sd_imageURL && !self.id1Img.sd_imageURL) {
        [self showToast:@"请至少上传一张身份证照片"];
        return;
    }
    if(!self.stu1Img.sd_imageURL && !self.stu2Img.sd_imageURL) {
        [self showToast:@"请至少上传一张学生证照片"];
        return;
    }
    if(self.id1Img.sd_imageURL) {
        [params setObject:self.id1Img.sd_imageURL forKey:@"idCardUrl1"];
    }
    if(self.id2Img.sd_imageURL) {
        [params setObject:self.id2Img.sd_imageURL  forKey:@"idCardUrl2"];
    }
    if(self.stu1Img.sd_imageURL) {
        [params setObject:self.stu1Img.sd_imageURL forKey:@"studentIdCardUrl1"];
    }
    if(self.stu2Img.sd_imageURL) {
        [params setObject:self.stu2Img.sd_imageURL forKey:@"studentIdCardUrl2"];
    }
    [self showHUD:@"提交中..."];
    [RSHttp requestWithURL:@"/user/identification" params:params httpMethod:@"POST" success:^(NSDictionary *data) {
        [self hidHUD];
        [self showToast:@"提交成功"];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self showToast:errmsg];
    }];
}

//拍摄完成后要执行的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    //上传图片到服务器
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [RSHttp postDataWithURL:@"/user/picBase64" params:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:[self image2Data:[info objectForKey:UIImagePickerControllerEditedImage]]  name:@"picture"];
    } success:^(NSDictionary *data) {
        currentImgView.highlighted = YES;
        [currentImgView sd_setImageWithURL:[data objectForKey:@"msg"]];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self showToast:@"图片上传失败"];
    }];
}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [self showHUD:@"加载中..."];
    [RSHttp requestWithURL:@"/user/identification" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [self hidHUD];
        NSDictionary *dict = [data objectForKey:@"msg"];
        self.nameTextField.textField.text = [dict valueForKey:@"realName"];
        self.idCardTextField.textField.text = [dict valueForKey:@"idCardNo"];
        self.stuCardTextField.textField.text = [dict valueForKey:@"studentIdCardNo"];
        if(![[dict objectForKey:@"idCardUrl1"] isEqualToString:@""]) {
            [self.id1Img sd_setImageWithURL:[dict objectForKey:@"idCardUrl1"] placeholderImage:[UIImage imageNamed:@"upload"]];
        }
        if(![[dict objectForKey:@"idCardUrl2"] isEqualToString:@""]) {
            [self.id2Img sd_setImageWithURL:[dict objectForKey:@"idCardUrl2"] placeholderImage:[UIImage imageNamed:@"upload"]];
        }
        if(![[dict objectForKey:@"studentIdCardUrl1"] isEqualToString:@""]) {
            [self.stu1Img sd_setImageWithURL:[dict objectForKey:@"studentIdCardUrl1"] placeholderImage:[UIImage imageNamed:@"upload"]];
        }
        if(![[dict objectForKey:@"studentIdCardUrl2"] isEqualToString:@""]) {
            [self.stu2Img sd_setImageWithURL:[dict objectForKey:@"studentIdCardUrl2"] placeholderImage:[UIImage imageNamed:@"upload"]];
        }
        self.status = [[dict objectForKey:@"identificationStatus"] integerValue];
        if([arr objectAtIndex:self.status]) {
            NSDictionary *dict =[arr objectAtIndex:self.status];
            statusImg.image = [UIImage imageNamed:[dict valueForKey:@"img"]];
            statusTitle.text = [dict valueForKey:@"title"];
            statusSubtitile.text = [dict valueForKey:@"subtitle"];
        }
    } failure:^(NSInteger code, NSString *errmsg) {
        [self hidHUD];
        [self showToast:errmsg];
    }];
}

-(void)upImageView:(id)sender
{
    if(self.status == 0 || self.status == 2) {
        return;
    }
    [super upImageView:sender];
}

-(void) setStatus:(NSInteger)status
{
    _status = status;
    if(_status == 0 || _status == 2) {
        self.nameTextField.textField.enabled = NO;
        self.idCardTextField.textField.enabled = NO;
        self.stuCardTextField.textField.enabled = NO;
        [self.saveBtn removeFromSuperview];
    }else {
        self.nameTextField.textField.enabled = YES;
        self.idCardTextField.textField.enabled = YES;
        self.stuCardTextField.textField.enabled = YES;
        [self.view addSubview:self.saveBtn];
    }
}

@end
