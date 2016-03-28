//
//  SettingViewController.m
//  RedScarf
//
//  Created by 李江 on 16/3/28.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "SettingViewController.h"
#import "MyprofileModel.h"

@interface SettingViewController (){
    MyprofileModel *clearModel;
}

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";
    
    [self initTableViewData];
}

-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self comeBack:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initTableViewData {
        self.models = [NSMutableArray array];
    
        MyprofileModel *model = [[MyprofileModel alloc] initWithTitle:@"我的" icon:@"test" vcName:@"PersonMsgViewController"];

        NSMutableArray *innerItems = [NSMutableArray array];
        model = [[MyprofileModel alloc] initWithTitle:@"版本管理" icon:@"banbenguanli" vcName:@"VersionViewController"];
        [innerItems addObject:model];
        model = [[MyprofileModel alloc] initWithTitle:@"意见反馈" icon:@"fankui2x" vcName:@"SuggestionViewController"];
        [innerItems addObject:model];
        NSInteger size = [[SDImageCache sharedImageCache] getSize];
        model = [[MyprofileModel alloc] initWithTitle:@"清除缓存" icon:@"icon_clearmem" vcName:@""];
        model.subtitle = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%0.2fM", 1.0*size/1000000] attributes:[NSDictionary dictionaryWithObjectsAndKeys:color_black_666666, NSForegroundColorAttributeName, textFont15, NSFontAttributeName, nil]];
        [innerItems addObject:model];
        [model setSelectAction:@selector(clearCache:) target:self];

        [self.models addObject:innerItems];
        self.sections = [NSMutableArray array];

}

//清空缓存
-(void) clearCache:(MyprofileModel *)model
{
    if([model isKindOfClass:[MyprofileModel class]]) {
        clearModel = (MyprofileModel *)model;
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"你确定要清空缓存？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        
        [[alertView rac_buttonClickedSignal] subscribeNext:^(NSNumber *butIndex) {
            if([butIndex integerValue] == 1){
                [[SDImageCache sharedImageCache] clearDisk];
                [self showToast:@"清理成功"];
                if(clearModel) {
                    clearModel.subtitle = [[NSAttributedString alloc]initWithString:@"0M" attributes:[NSDictionary dictionaryWithObjectsAndKeys:color_black_666666, NSForegroundColorAttributeName, textFont15, NSFontAttributeName, nil]];
                    [self.tableView reloadData];
                }
            }
        }];
        
        [alertView show];
    }
}


@end
