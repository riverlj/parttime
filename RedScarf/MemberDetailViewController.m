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
#import "RSUIView.h"
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
    [self beginHttpRequest];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = bgcolor;
    self.url = @"/team/user/";
    msgDictionary = [NSMutableDictionary dictionary];
    self.title = @"详细信息";
    [self comeBack:nil];
}


-(void)beforeHttpRequest
{
    [super beforeHttpRequest];
    [self.params setValue:self.memberId forKey:@"id"];
}

-(void) afterHttpSuccess:(NSDictionary *)data
{
    [self.view removeAllSubviews];
    msgDictionary = [data objectForKey:@"msg"];
    [self initView];
}

-(void)initView
{
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, kUIScreenWidth, kUIScreenHeigth)];
    [self.view addSubview:bgView];
    
    UIImageView *headView = [[UIImageView alloc] initWithFrame:CGRectMake(25, 25, 70, 70)];
    [headView sd_setImageWithURL:[NSURL URLWithString:[[msgDictionary objectForKey:@"url"] urlWithHost:nil]] placeholderImage:[UIImage imageNamed:@"touxiang"]];
    headView.layer.cornerRadius = headView.width/2;
    headView.clipsToBounds = YES;
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
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"TableViewCell"];
        cell.tag = 1000 + i;
        cell.height = 50;
        cell.width = kUIScreenWidth;
        cell.top = i*50 + 110;
        cell.textLabel.textColor = color_black_333333;
        [cell setBackgroundColor:[UIColor whiteColor]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if(i==0) {
            [cell addSubview:[RSUIView lineWithFrame:CGRectMake(0, 0, kUIScreenWidth, 0.5)]];
            cell.textLabel.text = @"电话";
            if (phoneText.length) {
                cell.detailTextLabel.text = phoneText;
            }else{
                cell.detailTextLabel.text = [msgDictionary objectForKey:@"mobilePhone"];
            }
        } else if(i==1) {
            [cell addSubview:[RSUIView lineWithFrame:CGRectMake(18, 0, kUIScreenWidth, 0.5)]];
            cell.textLabel.text = @"配送时间";
        } else {
            [cell addSubview:[RSUIView lineWithFrame:CGRectMake(18, 0, kUIScreenWidth, 0.5)]];
            cell.textLabel.text = @"配送范围";
            [cell addSubview:[RSUIView lineWithFrame:CGRectMake(0, cell.height - 0.5, kUIScreenWidth, 0.5)]];
        }
        [cell addTapAction:@selector(didClick:) target:self];
        [bgView addSubview:cell];
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
        }
        if (i == 1) {
            Btn.tag = 10001;
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
    UIView *btn = ((UITapGestureRecognizer *)sender).view;
    ModifyMemberViewController *modifyMemberVC = [[ModifyMemberViewController alloc] init];
    modifyMemberVC.delegate1 = self;
    if (btn.tag == 1000) {
        modifyMemberVC.title = @"修改电话";
        modifyMemberVC.phoneString = [msgDictionary objectForKey:@"mobilePhone"];
         [self.navigationController pushViewController:modifyMemberVC animated:YES];
    }
    if (btn.tag == 1001) {
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
@end
