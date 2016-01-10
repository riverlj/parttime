//
//  PersonMsgViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/17.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "PersonMsgViewController.h"
#import "LoginViewController.h"
#import "ModifyPMViewController.h"
#import "ModifyPWViewController.h"
#import "RSAccountModel.h"
#import "RSHeadView.h"

@interface PersonMsgViewController ()

@end

@implementation PersonMsgViewController
{
    RSHeadView *headView;
    NSString *judgeGender,*headString;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self comeBack:nil];
    self.title = @"个人资料";
    [self initTableView];
}


-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMessage];
}


-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [RSHttp requestWithURL:@"/user/info" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        NSDictionary *infoDic = [data objectForKey:@"msg"];
        NSError *error = nil;
        RSAccountModel *model = [MTLJSONAdapter modelOfClass:[RSAccountModel class] fromJSONDictionary:infoDic error:&error];
        [model save];
        NSDictionary *info = [infoDic objectForKey:@"userInfo"];
        if(info) {
            self.headUrl =  [info objectForKey:@"url"];
            
            [self.personMsgArray addObject:[info objectForKey:@"realName"]];
            NSMutableDictionary *apartmentDic = [info objectForKey:@"apartment"];
            //地址
            [self.personMsgArray addObject:[apartmentDic objectForKey:@"name"]];
            //学校
            [self.personMsgArray addObject:[[apartmentDic objectForKey:@"school"] objectForKey:@"name"]];
            self.schoolId = [[apartmentDic objectForKey:@"school"] objectForKey:@"id"];
            
            [self.personMsgArray addObject:[info objectForKey:@"mobilePhone"]];
            [self.personMsgArray addObject:[info objectForKey:@"idCardNo"]];
            [self.personMsgArray addObject:[info objectForKey:@"studentIdCardNo"]];
            [self.personMsgArray addObject:@"密码"];
            [self.personMsgArray addObject:[info objectForKey:@"sex"]];
            [self.personMsgArray addObject:[info objectForKey:@"idCardUrl1"]];
            
            if ([info objectForKey:@"idCardUrl2"] != nil) {
                [self.personMsgArray addObject:[info objectForKey:@"idCardUrl2"]];
            }else{
                [self.personMsgArray addObject:@""];
            }
            
            [self.personMsgArray addObject:[info objectForKey:@"studentIdCardUrl1"]];
            if ([info objectForKey:@"studentIdCardUrl2"] != nil) {
                [self.personMsgArray addObject:[info objectForKey:@"studentIdCardUrl2"]];
            }else{
                [self.personMsgArray addObject:@""];
            }
            
            if (![[info objectForKey:@"position"] isEqualToString:@"校园兼职"]) {
                self.position = @"ceo";
            }
        }
        [self.tableView reloadData];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self showToast:errmsg];
    }];
}



-(void)initTableView
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = color_gray_f3f5f7;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, kUIScreenWidth, 80)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 20, 100, 40)];
    nameLabel.text = @"修改头像";
    nameLabel.font = textFont14;
    [bgView addSubview:nameLabel];
    
    headView = [[RSHeadView alloc] initWithFrame:CGRectMake(kUIScreenWidth-80, 5, 70, 70)];
    [headView addTapAction:@selector(didClickHead:) target:self];
    [bgView addSubview:headView];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 60)];
    UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginOutBtn.frame = CGRectMake(70, self.tableView.height+self.tableView.y+20, kUIScreenWidth-140, 40);
    loginOutBtn.centerX = view.width/2;
    loginOutBtn.centerY = view.height/2;
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    loginOutBtn.layer.masksToBounds = YES;
    loginOutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    loginOutBtn.layer.cornerRadius = 5;
    [loginOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginOutBtn setBackgroundColor:colorrede5];
    [loginOutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:loginOutBtn];
    
    self.tableView.tableHeaderView = bgView;
    self.tableView.tableFooterView = view;
}

//更换👦
- (void)didClickHead:(id)sender
{
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
        
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;//是否可编辑
        //摄像头
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:nil];
    } else{
        //
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你没有摄像头" delegate:self cancelButtonTitle:@"Drat!" otherButtonTitles:@"取消", nil];
        [alert show];
    }
}

//点击Cancel按钮后执行方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:^{
    }];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"你没有摄像头" delegate:nil cancelButtonTitle:@"Drat!" otherButtonTitles:nil];
        [alert show];
    }
    
}
//选中图片进入的代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}


//拍摄完成后要执行的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //更换头像
    UIImage *image1 = [info objectForKey:UIImagePickerControllerEditedImage];
    
    headView.headimgView.image = image1;
    
    headString = [self image2String:image1];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:headString forKey:@"picture"];
    [dic setObject:[defaults objectForKey:@"token"] forKey:@"token"];
    [RSHttp requestWithURL:@"/user/picBase64" params:dic httpMethod:@"POST" success:^(NSDictionary *data) {
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:[data objectForKey:@"msg"] forKey:@"url"];
        [params setObject:[defaults objectForKey:@"token"] forKey:@"token"];
        [RSHttp requestWithURL:@"/user/portrait" params:params httpMethod:@"POST" success:^(NSDictionary *data) {
            [self alertView:@"设置成功"];
            RSAccountModel *model = [RSAccountModel sharedAccount];
            model.headImg = [params valueForKey:@"url"];
            [model save];
            [picker dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSInteger code, NSString *errmsg) {
            [picker dismissViewControllerAnimated:YES completion:nil];
        }];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }];
}

-(NSString *) image2String:(UIImage *)image{
    
    NSData* pictureData = UIImageJPEGRepresentation(image,0.3);//进行图片压缩从0.0到1.0（0.0表示最大压缩，质量最低);
    
    NSString* pictureDataString = [pictureData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return pictureDataString;
}

#pragma mark -- tableViewDelegate
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
        return 0;

    }
    return 10;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 1;
    }
    if (section == 1) {
        return 2;
    }

    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 10)];
    return headerView;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    if (cell == nil) {
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = MakeColor(91, 91, 91);
    
    if (indexPath.section == 0) {
        
        UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(65, 0, kUIScreenWidth-100, 45)];
        [cell.contentView addSubview:headLabel];
        headLabel.font = textFont14;
        headLabel.textColor = MakeColor(91, 91, 91);
        headLabel.textAlignment = NSTextAlignmentRight;
        if (self.personMsgArray.count) {
             headLabel.text = self.personMsgArray[indexPath.row];
        }
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kUIScreenWidth/2-30, 45)];
        nameLabel.font = textFont15;
        [cell.contentView addSubview:nameLabel];
        
        if (indexPath.row == 0) {
            headLabel.frame = CGRectMake(kUIScreenWidth/2, 0, kUIScreenWidth/2-50, 45);
            nameLabel.text = @"姓名";
            UIImageView *genderView = [[UIImageView alloc] initWithFrame:CGRectMake(headLabel.frame.size.width+headLabel.frame.origin.x+5, 15, 15, 15)];
            if (judgeGender.length) {
                if ([judgeGender isEqualToString:@"1"]) {
                    genderView.image = [UIImage imageNamed:@"nan2x"];
                }else{
                    genderView.frame = CGRectMake(headLabel.frame.size.width+headLabel.frame.origin.x+5, 15, 12, 15);
                    genderView.image = [UIImage imageNamed:@"nv2x"];
                }
            }else{
                if (self.personMsgArray.count) {
                    if ([[NSString stringWithFormat:@"%@",self.personMsgArray[7]] isEqualToString:@"1"]) {
                        genderView.image = [UIImage imageNamed:@"nan2x"];
                    }else{
                        genderView.frame = CGRectMake(headLabel.frame.size.width+headLabel.frame.origin.x+5, 15, 12, 15);
                        genderView.image = [UIImage imageNamed:@"nv2x"];
                    }
                }
                
            }
           
            [cell.contentView addSubview:genderView];
        }
        
        if (indexPath.row == 1) {
            nameLabel.text = @"地址";
        }
        if (indexPath.row == 2) {
            nameLabel.text = @"学校";
        }
        if (indexPath.row == 3) {
            cell.userInteractionEnabled = NO;
            nameLabel.text = @"手机号";
        }
        
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth-70, 0, 45, 45)];
    [cell.contentView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = MakeColor(213, 213, 213);
    
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            cell.textLabel.text = @"身份证信息";
        }
        if (indexPath.row == 1) {
             cell.textLabel.text = @"学生证信息";
        }
    }
    if (indexPath.section == 2) {
         cell.textLabel.text = @"修改密码";
       }
    
    if (indexPath.section == 0 && indexPath.row == 3) {
        
    }else{
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (self.personMsgArray.count) {
        ModifyPMViewController *modifyVC = [[ModifyPMViewController alloc] init];
        ModifyPWViewController *modifyPW = [[ModifyPWViewController alloc] init];
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                modifyVC.name = self.personMsgArray[indexPath.row];
                modifyVC.gender = [NSString stringWithFormat:@"%@",self.personMsgArray[7]];
                modifyVC.judgeStr = @"name";
            }
            if (indexPath.row == 1) {
                modifyVC.judgeStr = @"address";
                modifyVC.schoolId = self.schoolId;
                modifyVC.currentAddress = self.personMsgArray[2];
            }
            if (indexPath.row == 2) {
                modifyVC.judgeStr = @"major";
                modifyVC.schoolId = self.schoolId;
            }
            modifyVC.delegate1 = self;
            [self.navigationController pushViewController:modifyVC animated:YES];
        }
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                modifyPW.titleString = @"查看身份证";
                modifyPW.idString = self.personMsgArray[4];
                modifyPW.idUrl1 = self.personMsgArray[8];
                if (self.personMsgArray[9]) {
                    modifyPW.idUrl2 = self.personMsgArray[9];
                }

            }
            if (indexPath.row == 1) {
                modifyPW.titleString = @"查看学生证";
                modifyPW.idString = self.personMsgArray[5];
                modifyPW.studentUrl1 = self.personMsgArray[10];
                if (self.personMsgArray[11]) {
                    modifyPW.studentUrl2 = self.personMsgArray[11];
                }

            }
            [self.navigationController pushViewController:modifyPW animated:YES];
        }
        if (indexPath.section == 2) {
            modifyPW.titleString = @"修改密码";
            [self.navigationController pushViewController:modifyPW animated:YES];
        }
    }
}

-(void)returnString:(NSString *)string gender:(NSString *)sex judge:(NSString *)from
{
    if ([from isEqualToString:@"name"]) {
        [self.personMsgArray replaceObjectAtIndex:0 withObject:string];
        judgeGender = sex;
        
    }else if ([from isEqualToString:@"address"]){
        [self.personMsgArray replaceObjectAtIndex:1 withObject:string];
    }
    [self.tableView reloadData];
}

//退出登陆
-(void)loginOut
{
    [NSUserDefaults clearValueForKey:@"token"];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [app setRootViewController:loginVC];
}


@end
