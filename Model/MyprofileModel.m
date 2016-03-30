//
//  MyprofileModel.m
//  RedScarf
//
//  Created by lishipeng on 15/12/12.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "MyprofileModel.h"

@implementation MyprofileModel

+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"title" : @"name",
             @"url" : @"url",
             @"imgName" : @"iosIco",
             };
}

-(instancetype) initWithTitle:(NSString *)title icon:(NSString *)imgName vcName:(NSString *)vcName
{
    self = [self init];
    self.title = title;
    self.imgName = imgName;
    self.vcName = vcName;
    self.cellHeight = 48;
    self.subtitle = [[NSAttributedString alloc]initWithString:@""];
    return self;
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
                             @"rsparttime://user/setting" : @"SettingViewController"
                             };
    if ([urlDic objectForKey:url]) {
        _vcName = [urlDic objectForKey:url];
    }else{
        _vcName = nil;
    }
}

@end
