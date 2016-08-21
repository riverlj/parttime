//
//  RSAlertView.m
//  RSUser
//
//  Created by 李江 on 16/4/8.
//  Copyright © 2016年 RedScarf. All rights reserved.
//

#import "RSToastView.h"

static RSToastView *shareObject = nil;
@implementation RSToastView

+(id)shareRSToastView{
    @synchronized(self)
    {
        if (shareObject == nil)
        {
            shareObject = [[RSToastView alloc]init];
        }
    }
    return shareObject;
}


-(MBProgressHUD *) hud
{
    if(_hud) {
        return _hud;
    }
    _hud = [[MBProgressHUD alloc] initWithView:[UIApplication sharedApplication].keyWindow];
    [[UIApplication sharedApplication].keyWindow addSubview:self.hud];
    return _hud;
}

- (void)showHUD:(NSString *)title
{
    [self hidHUD];
    self.hud = nil;
    self.hud.mode=MBProgressHUDModeIndeterminate;
    self.hud.labelText = title;
    [self.hud show:YES];
}

//隐藏加载
- (void)hidHUD {
    [self.hud hide:YES];
    [self.hud removeFromSuperview];
    self.hud = nil;
}

+(void)alertView:(NSString *)msg
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
    return;
}

-(void)showToast:(NSString *)str
{
    self.hud.labelText = str;
    self.hud.mode = MBProgressHUDModeText;
    self.hud.yOffset = -100;
    [self.hud showAnimated:YES whileExecutingBlock:^{
        sleep(1);
    } completionBlock:^{
        [self.hud removeFromSuperview];
        self.hud = nil;
    }];
    
}
@end
