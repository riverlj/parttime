//
//  roomTaskCell.h
//  RedScarf
//
//  Created by 李江 on 16/10/24.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSTableViewCell.h"

@interface roomTaskCell : RSTableViewCell
@property (nonatomic ,strong)UILabel *roomNameLabel;
@property (nonatomic ,strong)UILabel *numTaskLabel;
@property (nonatomic ,strong)UIButton *detailBtn;
@property (nonatomic ,strong)UIButton *sendedBtn;

@end
