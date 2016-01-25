//
//  AddMembersViewController.h
//  RedScarf
//
//  Created by lishipeng on 16/1/13.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "AddMemberViewController.h"

@interface AddMembersViewController : AddMemberViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property(nonatomic, strong) RSInputField *phoneTextField;
@property(nonatomic, strong) RSInputField *buildingTextField;
@property(nonatomic, strong) UIPickerView *pickerView;
@property(nonatomic, strong) UIButton *doneToolbar;

@end
