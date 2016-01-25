//
//  AddMemberViewController.h
//  RedScarf
//
//  Created by lishipeng on 16/1/13.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "RSInputField.h"

@interface AddMemberViewController : BaseViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate, UIActionSheetDelegate>{
    UIImageView *currentImgView;
}
@property(nonatomic, strong) UIScrollView *scrolView;

@property(nonatomic, strong) RSInputField *nameTextField;
@property(nonatomic, strong) RSInputField *idCardTextField;
@property(nonatomic, strong) RSInputField *stuCardTextField;


@property(nonatomic, strong) UIView *imagesView;
@property(nonatomic, strong) UIImageView *id1Img;
@property(nonatomic, strong) UIImageView *id2Img;
@property(nonatomic, strong) UIImageView *stu1Img;
@property(nonatomic, strong) UIImageView *stu2Img;

@property(nonatomic, strong) UIButton *saveBtn;


-(void) hideKeyboard;
-(void)upImageView:(id)sender;
-(NSData *) image2Data:(UIImage *)image;
@end
