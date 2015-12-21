//
//  MemberDetailViewController.m
//  RedScarf
//
//  Created by zhangb on 15/9/22.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "MemberDetailViewController.h"
#import "ModifyMemberViewController.h"
#import "OrderTimeViewController.h"

@interface MemberDetailViewController ()

@end

@implementation MemberDetailViewController
{
    NSMutableDictionary *msgDictionary;
    NSString *phoneText;
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getMessage];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgcolor;
    msgDictionary = [NSMutableDictionary dictionary];
    self.title = @"详细信息";
    [self comeBack:nil];
    //[self getMessage];
    //[self initView];
}

-(void)getMessage
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:self.memberId forKey:@"id"];
    [self showHUD:@"正在加载"];
    [RSHttp requestWithURL:@"/team/user/" params:params httpMethod:@"GET" success:^(NSDictionary *data) {
        [self.view removeAllSubviews];
        msgDictionary = [data objectForKey:@"msg"];
        [self initView];
        [self hidHUD];
    } failure:^(NSInteger code, NSString *errmsg) {
        [self alertView:errmsg];
        [self hidHUD];
    }];
}

-(void)initView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, kUIScreenHeigth)];
    [self.view addSubview:bgView];
    
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 25, 70, 70)];
    headView.image = [UIImage imageNamed:@"touxiang"];
    [bgView addSubview:headView];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 33, 70, 35)];
    nameLabel.text = [msgDictionary objectForKey:@"realName"];
    [nameLabel sizeToFit];
    [bgView addSubview:nameLabel];

    UIImageView *genderView = [[UIImageView alloc] initWithFrame:CGRectMake(170, nameLabel.top +3, 12, 15)];
    genderView.left = nameLabel.right + 5;
    if ((NSInteger)[msgDictionary objectForKey:@"sex"] == 1) {
        genderView.image = [UIImage imageNamed:@"nan2x"];
    }else{
        genderView.image = [UIImage imageNamed:@"nv2x"];
    }
    
    [bgView addSubview:genderView];
    
    UILabel *addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 57, kUIScreenWidth-120, 30)];
    addressLabel.font = textFont14;
    addressLabel.textColor = textcolor;
    addressLabel.text = [[msgDictionary objectForKey:@"apartment"] objectForKey:@"name"];
    [bgView addSubview:addressLabel];
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(0, 110+i*51, kUIScreenWidth, 50);
        btn.backgroundColor = [UIColor whiteColor];
        btn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [bgView addSubview:btn];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 110+i*51, 70, 50)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = textFont16;
        [bgView addSubview:label];
        
        UIImageView *detailView = [[UIImageView alloc] initWithFrame:CGRectMake(kUIScreenWidth-30,  110+i*51+18, 10, 15)];
        detailView.image = [UIImage imageNamed:@"you2x"];
        [bgView addSubview:detailView];
        
        if (i == 0) {
            btn.tag = 1000;
            UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(kUIScreenWidth-140, 110, 110, 50)];
            if (phoneText.length) {
                telLabel.text = phoneText;
            }else{
                telLabel.text = [msgDictionary objectForKey:@"mobilePhone"];
            }
            
            telLabel.font = textFont14;
            telLabel.textColor = MakeColor(193, 193, 193);
            [bgView addSubview:telLabel];
            label.text = @"电话";
        }
        if (i == 1) {
            btn.tag = 1001;
            label.text = @"配送时间";
        }
        if (i == 2) {
            btn.tag = 1002;
            label.text = @"配送范围";
        }
        [btn addTarget:self action:@selector(didClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (int i = 0; i < 2; i++) {
        UIButton *Btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [bgView addSubview:Btn];
        Btn.layer.masksToBounds = YES;
        Btn.titleLabel.font = textFont20;
        Btn.layer.cornerRadius = 5;
        Btn.frame = CGRectMake(20, (110+3*51)+i*55+30, kUIScreenWidth-40, 45);
        
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((kUIScreenWidth-40)/2-40,  (110+3*51)+i*55+43, 18, 18)];
        [bgView addSubview:img];
        
        if (i == 0) {
            Btn.tag = 10000;
            [Btn setBackgroundColor:MakeColor(85, 130, 255)];
            [Btn setTitle:@"打电话" forState:UIControlStateNormal];
            [Btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//            UIImage *im = [[UIImage imageNamed:@"dianhua"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//            img.image = im;
        }
        if (i == 1) {
            Btn.tag = 10001;
            img.image = [UIImage imageNamed:@"duanxin"];
            [Btn setBackgroundColor:[UIColor whiteColor]];
            [Btn setTitle:@"发短信" forState:UIControlStateNormal];
            [Btn setTitleColor:color155 forState:UIControlStateNormal];

        }
        [Btn addTarget:self action:@selector(phoneAndMessage:) forControlEvents:UIControlEventTouchUpInside];
    }
    
}

-(void)phoneAndMessage:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if (btn.tag == 10000) {
        if ([msgDictionary objectForKey:@"mobilePhone"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"telprompt://"stringByAppendingString:[msgDictionary objectForKey:@"mobilePhone"]]]];
        }
    }
    if (btn.tag == 10001) {
        if ([msgDictionary objectForKey:@"mobilePhone"]) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"sms://" stringByAppendingString:[msgDictionary objectForKey:@"mobilePhone"]]]];
        }
    }
}

-(void)returnNumber:(NSString *)number
{
    phoneText = number;
}

-(void)didClick:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    ModifyMemberViewController *modifyMemberVC = [[ModifyMemberViewController alloc] init];
    modifyMemberVC.delegate = self;
    if (btn.tag == 1000) {
        modifyMemberVC.title = @"修改电话";
        modifyMemberVC.phoneString = [msgDictionary objectForKey:@"mobilePhone"];
         [self.navigationController pushViewController:modifyMemberVC animated:YES];
    }
    if (btn.tag == 1001) {
//        modifyMemberVC.title = @"修改配送时间";
        OrderTimeViewController *orderTimeVC = [[OrderTimeViewController alloc] init];
        orderTimeVC.username = [msgDictionary objectForKey:@"username"];
        [self.navigationController pushViewController:orderTimeVC animated:YES];
    }
    if (btn.tag == 1002) {
        modifyMemberVC.title = @"修改配送范围";
        modifyMemberVC.username = [msgDictionary objectForKey:@"username"];
         [self.navigationController pushViewController:modifyMemberVC animated:YES];
    }
   
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
