//
//  MenuModel.m
//  RedScarf
//
//  Created by 李江 on 16/3/31.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "MenuModel.h"

@implementation MenuModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"menuId" : @"id",
             @"imgName" : @"iosIco",
             @"url" : @"url",
             @"title" : @"name"
             };
}

- (void)setUrl:(NSString *)url{
    _url = url;
    NSDictionary *urlDic = @{
                             @"rsparttime://user/salary" : @"MoneyOfMonth",
                             @"rsparttime://user/wallet" : @"WalletViewController",
                             @"rsparttime://user/grade" : @"LevelViewController",
                             @"rsparttime://user/auth" : @"UserCertViewController",
                             @"rsparttime://user/settingTime" : @"OrderTimeViewController",
                             @"rsparttime://user/settingAddr" : @"OrderRangeViewController",
                             @"rsparttime://user/setting" : @"SettingViewController",
                             @"rsparttime://task/taskManager" : @"TasksViewController",
                             @"rsparttime://task/finishedTask" : @"FinishViewController",
                             @"rsparttime://task/ceoDisPos" : @"SeparateViewController",
                             @"rsparttime://team/schedule" : @"CheckTaskViewController",
                             @"rsparttime://team/member" : @"TeamMembersViewController",
                             @"rsparttime://user/promotion" : @"PromotionViewController",
                             @"rsparttime://task/userDisPos" : @"SeparateViewController",
                             @"rsparttime://merchant/signin" : @"MerchantSigninViewController"
                             
                             };
    if ([urlDic objectForKey:url]) {
        _vcName = [urlDic objectForKey:url];
    }else{
        _vcName = nil;
    }
}
@end
