//
//  PersonMsgViewController.h
//  RedScarf
//
//  Created by zhangb on 15/9/17.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import "RSTableViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ModifyPMViewController.h"

@interface PersonMsgViewController : RSTableViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,ModifyPMViewControllerDelegate, UIActionSheetDelegate>
{
    AVCaptureSession *_AVSession;
}
@property (nonatomic,strong)AVCaptureSession *AVSession;
@property(nonatomic,strong) NSMutableArray *personMsgArray;
@property(nonatomic,strong) NSString *schoolId;
@property(nonatomic,strong) NSString *position;
@property(nonatomic,strong) NSString *headUrl;

//调用相机
- (void)didClickCamera:(id)sender;
//调用图片库
- (void)didClickLibray:(id)sender;

@end
