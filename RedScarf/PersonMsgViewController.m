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

@interface PersonMsgViewController ()

@end

@implementation PersonMsgViewController
{
    UIImageView *headView;
    NSString *judgeGender;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人资料";
    self.view.backgroundColor = MakeColor(241, 242, 248);
    self.tabBarController.tabBar.hidden = YES;
    [self navigationBar];
    [self initTableView];
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

-(void)initTableView
{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, kUIScreenHeigth)];
    scroll.contentSize = CGSizeMake(0, kUIScreenHeigth*1.2);
    scroll.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:scroll];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 130, kUIScreenWidth, 300)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    UIView *view = [[UIView alloc] init];
    self.tableView.tableFooterView = view;
    [scroll addSubview:self.tableView];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 130)];
    bgView.backgroundColor = MakeColor(241, 242, 248);
    [scroll addSubview:bgView];
    
    headView = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-40, 15, 80, 80)];
    headView.image = [UIImage imageNamed:@"touxiang"];
//    headView.backgroundColor = [UIColor redColor];
    headView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickHead:)];
    tap.numberOfTapsRequired = 1;
    [headView addGestureRecognizer:tap];
    headView.layer.masksToBounds = YES;
    headView.layer.cornerRadius = 40;
    [bgView addSubview:headView];
    
    UILabel *ceoLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-12, 88, 25, 12)];
    ceoLabel.text = @"CEO";
    ceoLabel.textAlignment = NSTextAlignmentCenter;
    ceoLabel.font = [UIFont systemFontOfSize:10];
    ceoLabel.layer.masksToBounds = YES;
    ceoLabel.layer.cornerRadius = 4;
    ceoLabel.backgroundColor = MakeColor(69, 126, 251);
    ceoLabel.textColor = [UIColor whiteColor];
    [bgView addSubview:ceoLabel];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth/2-50, 105, 100, 15)];
//    label.backgroundColor = MakeColor(251, 251, 251);
    label.text = self.personMsgArray[3];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = MakeColor(69, 126, 251);;
    label.font = [UIFont systemFontOfSize:15];
    [bgView addSubview:label];
    
    UIButton *loginOutBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    loginOutBtn.frame = CGRectMake(70, self.tableView.frame.size.height+self.tableView.frame.origin.y+20, kUIScreenWidth-140, 40);
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    loginOutBtn.layer.masksToBounds = YES;
    loginOutBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    loginOutBtn.layer.cornerRadius = 5;
    [loginOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginOutBtn setBackgroundColor:[UIColor redColor]];
    [loginOutBtn addTarget:self action:@selector(loginOut) forControlEvents:UIControlEventTouchUpInside];
    
    [scroll addSubview:loginOutBtn];
    
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    NSString *imageFile=[NSTemporaryDirectory() stringByAppendingPathComponent:@"/img.png"];
    NSData *imageData = [[NSData alloc] initWithContentsOfFile:imageFile];
    UIImage *image = [[UIImage alloc] initWithData:imageData];
    if (image != nil)
    {
        headView.image = image;
    }
    [self.navigationController setNavigationBarHidden:NO];
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
    
    //更换头像
    UIImage *image1 = [info objectForKey:UIImagePickerControllerEditedImage];
    
    headView.image = image1;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    NSString *imageFile=[NSTemporaryDirectory() stringByAppendingPathComponent:@"/img.png"];
    
    NSData *imageData = UIImageJPEGRepresentation(image1, 0.5);
    
    [imageData writeToFile:imageFile atomically:YES];
    
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

    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kUIScreenWidth, 10)];
    headerView.backgroundColor = MakeColor(240, 240, 240);
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
        cell.textLabel.text = self.personMsgArray[indexPath.row];
        if (indexPath.row == 0) {
            UIImageView *genderView = [[UIImageView alloc] initWithFrame:CGRectMake(70, 15, 15, 15)];
            if (judgeGender.length) {
                if ([judgeGender isEqualToString:@"1"]) {
                    genderView.image = [UIImage imageNamed:@"nan"];
                }else{
                    genderView.image = [UIImage imageNamed:@"nv"];
                }
            }else{
                if ([[NSString stringWithFormat:@"%@",self.personMsgArray[7]] isEqualToString:@"1"]) {
                    genderView.image = [UIImage imageNamed:@"nan"];
                }else{
                    genderView.image = [UIImage imageNamed:@"nv"];
                }
            }
           
            
            [cell.contentView addSubview:genderView];
        }
        
    }
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth-70, 0, 45, 45)];
    [cell.contentView addSubview:label];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = MakeColor(213, 213, 213);
    
    if (indexPath.section == 1) {
//        if (indexPath.row == 0) {
//            cell.textLabel.text = self.personMsgArray[3];
//            label.text = @"手机号";
//        }
        if (indexPath.row == 0) {
            cell.textLabel.text = self.personMsgArray[4];
            label.text = @"身份证";
        }
        if (indexPath.row == 1) {
            cell.textLabel.text = self.personMsgArray[5];
            label.text = @"学生证";
        }
    }
    if (indexPath.section == 2) {
        
            cell.textLabel.text = self.personMsgArray[6];
            label.frame = CGRectMake(kUIScreenWidth-80, 0, 55, 45);
            label.text = @"修改密码";
       }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ModifyPMViewController *modifyVC = [[ModifyPMViewController alloc] init];
    ModifyPWViewController *modifyPW = [[ModifyPWViewController alloc] init];
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            modifyVC.judgeStr = @"name";
        }
        if (indexPath.row == 1) {
            modifyVC.judgeStr = @"major";
            modifyVC.schoolId = self.schoolId;
        }
        if (indexPath.row == 2) {
            modifyVC.judgeStr = @"address";
            modifyVC.schoolId = self.schoolId;
            modifyVC.currentAddress = self.personMsgArray[2];
        }
        modifyVC.delegate = self;
        [self.navigationController pushViewController:modifyVC animated:YES];
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            modifyPW.titleString = @"查看身份证";
            modifyPW.idString = self.personMsgArray[4];
        }
        if (indexPath.row == 1) {
            modifyPW.titleString = @"查看学生证";
             modifyPW.idString = self.personMsgArray[5];
        }
        [self.navigationController pushViewController:modifyPW animated:YES];
    }
    if (indexPath.section == 2) {
        modifyPW.titleString = @"修改密码";
        [self.navigationController pushViewController:modifyPW animated:YES];
    }
   
}

-(void)returnString:(NSString *)string gender:(NSString *)sex judge:(NSString *)from
{
    if ([from isEqualToString:@"name"]) {
        [self.personMsgArray replaceObjectAtIndex:0 withObject:string];
        judgeGender = sex;
        
    }else if ([from isEqualToString:@"address"]){
        [self.personMsgArray replaceObjectAtIndex:2 withObject:string];
    }
    [self.tableView reloadData];
}

//推出登陆
-(void)loginOut
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"token"];
    [defaults synchronize];
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [app setRoorViewController:loginVC];
    
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
