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
    
    [self setExtraCellLineHidden:self.tableView];
    
    [self initTableViewData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    [self comeBack:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)initTableViewData {
        self.models = [NSMutableArray array];
    
    MyprofileModel *model = [[MyprofileModel alloc] initWithTitle:@"版本管理" icon:@"banbenguanli" vcName:@"VersionViewController"];
    [self.models addObject:model];
    model = [[MyprofileModel alloc] initWithTitle:@"意见反馈" icon:@"fankui2x" vcName:@"SuggestionViewController"];
    [self.models addObject:model];
    NSInteger size = [[SDImageCache sharedImageCache] getSize];
    model = [[MyprofileModel alloc] initWithTitle:@"清除缓存" icon:@"icon_clearmem" vcName:@""];
    model.subtitle = [[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"%0.2fM", 1.0*size/1000000] attributes:[NSDictionary dictionaryWithObjectsAndKeys:color_black_666666, NSForegroundColorAttributeName, textFont15, NSFontAttributeName, nil]];
    [model setSelectAction:@selector(clearCache:) target:self];
    [self.models addObject:model];


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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyprofileModel *model = [self.models objectAtIndex:indexPath.row];
    if(model.vcName && ![model.vcName isEqualToString:@""]) {
        UIViewController *vc = [[NSClassFromString(model.vcName) alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    [super tableView:tableView didSelectRowAtIndexPath:indexPath];
    
}

- (void)setExtraCellLineHidden: (UITableView *)tableView{
    UIView *view =[ [UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
    [tableView setTableHeaderView:view];
}

@end
