//
//  ModifyPMViewController.h
//  RedScarf
//
//  Created by zhangb on 15/9/18.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSTableViewController.h"

@protocol ModifyPMViewControllerDelegate <NSObject>

-(void)returnString:(NSString *)string gender:(NSString *)sex judge:(NSString *)from;

@end

@interface ModifyPMViewController : RSTableViewController<UIPickerViewDataSource,UIPickerViewDelegate>

@property(nonatomic,strong) NSString *judgeStr;
@property(nonatomic,assign)id<ModifyPMViewControllerDelegate>delegate1;
@property(nonatomic,strong) NSString *schoolId;
@property(nonatomic,strong)NSString *currentAddress;

@property(nonatomic,strong)NSString *name;
@property(nonatomic,strong)NSString *gender;


@end
