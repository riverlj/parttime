//
//  MerchantSigninViewController.m
//  RedScarf
//
//  Created by 李江 on 16/10/8.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "MerchantSigninViewController.h"
#import "MerChantSignInModel.h"
#import "MerChantSignInCell.h"
#import "SimulateActionSheet.h"
#import "MissGoodsViewController.h"

@interface MerchantSigninViewController ()<MerChantSignInClickDelegate, SimulateActionSheetDelegate>
{
    SimulateActionSheet *sheet;
    NSArray *keysArray;
    NSArray *valuesArray;
    
    
    UILabel *timeLabel;
}
@end

@implementation MerchantSigninViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    keysArray = @[@"00",@"01",@"02",@"03",@"04",@"05",
                  @"06",@"07",@"08",@"09",@"10",@"11",
                  @"12",@"13",@"14",@"15",@"16",@"17",
                  @"18",@"19",@"20",@"21",@"22",@"23"];
    
    valuesArray = @[@"00",@"01",@"02",@"03",@"04",@"05",@"06",@"07",@"08",@"09",
                    @"10",@"11",@"12",@"13",@"14",@"15",@"16",@"17",@"18",@"19",
                    @"20",@"21",@"22",@"23",@"24",@"25",@"26",@"27",@"28",@"29",
                    @"30",@"31",@"32",@"33",@"34",@"35",@"36",@"37",@"38",@"39",
                    @"40",@"41",@"42",@"43",@"44",@"45",@"46",@"47",@"48",@"49",
                    @"50",@"51",@"52",@"53",@"54",@"55",@"56",@"57",@"58",@"59",];
    
    self.title = @"商家签到";
    self.tableView.height += 49;
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 131, 131)];
    imageView.image = [UIImage imageNamed:@"kongrenwu.png"];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.tableView addSubview:imageView];
    
    imageView.centerX = self.tableView.centerX;
    imageView.centerY = self.tableView.centerY-113;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    label.text = @"无商家数据";
    label.textColor = [NSString colorFromHexString:@"3c3c3c"];
    label.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:label];
    label.y = imageView.bottom;
    
    imageView.hidden = YES;
    label.hidden = YES;


    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = NO;
    self.models = [[NSMutableArray alloc]init];
    self.sections = [NSMutableArray array];
    __weak MerchantSigninViewController *selfWeak = self;
    [[RSToastView shareRSToastView] showHUD:@"加载中..."];
    [MerChantSignInModel getSchoolInfo:^(NSArray *merchants) {
        [[RSToastView shareRSToastView] hidHUD];
        for (int i=0; i<merchants.count; i++) {
            NSMutableArray *tempArray = [NSMutableArray array];
            MerChantSignInModel *model = merchants[i];
            [tempArray addObject:model];
            [self.models addObject:tempArray];
        }
        
        if (merchants.count == 0) {
            imageView.hidden = NO;
            label.hidden = NO;
        }
        [selfWeak.tableView reloadData];
    } failure:^{
        [[RSToastView shareRSToastView] hidHUD];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[MerChantSignInCell class]]) {
        MerChantSignInCell *mcell = (MerChantSignInCell *)cell;
        mcell.merChantSignInClickDelegate = self;
    }
    return cell;
}

-(void)missgoodsClicked:(MerChantSignInModel *)model {
    MissGoodsViewController *missvc = [[MissGoodsViewController alloc] init];
    missvc.goodsid = model.goodsid;
    [self.navigationController pushViewController:missvc animated:YES];
}

-(void)makesureSended:(MerChantSignInModel *)model {
    __weak MerchantSigninViewController *selfWeak = self;
    if (timeLabel) {
        NSString *time = timeLabel.text;
        model.checktime = time;
    }
    
    [MerChantSignInModel makeSureSended:model success:^{
        model.status = @1;
        [selfWeak.tableView reloadData];
    } failure:^{}];
}

-(void)changeSendedTime:(UILabel *)label {
    timeLabel = label;
    
    sheet = [SimulateActionSheet styleDefault];
    sheet.delegate = self;
    NSString *str = timeLabel.text;
    NSArray *array = [str componentsSeparatedByString:@":"];
    NSInteger index1 = [keysArray indexOfObject:array[0]];
    NSInteger index2 = [valuesArray indexOfObject:array[1]];
    [sheet selectRow:index1 inComponent:0 animated:YES];
    [sheet selectRow:index2 inComponent:1 animated:YES];
    [sheet show:self];
}

#pragma mark pickerView delegate
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) {
        return keysArray.count;
    } else {
        return valuesArray.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0) {
        return keysArray[row];
    }else {
        return valuesArray[row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0) {
        [pickerView reloadComponent:1];
    }else {
        
    }
}

-(void)actionCancle{
    [sheet dismiss:self];
}

-(void)actionDone{
    [sheet dismiss:self];
    
    NSUInteger index = [sheet selectedRowInComponent:0];
    NSUInteger index2 = [sheet selectedRowInComponent:1];
    
    NSString * hh = keysArray[index];
    NSString *mm = valuesArray[index2];
    
    timeLabel.text = [NSString stringWithFormat:@"%@:%@", hh,mm];
}

@end
