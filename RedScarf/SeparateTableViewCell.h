//
//  SeparateTableViewCell.h
//  RedScarf
//
//  Created by zhangb on 15/10/21.
//  Copyright (c) 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeparateTableViewCell : UITableViewCell

@property(nonatomic,strong)UILabel *typeLabel;
@property(nonatomic,strong)UILabel *foodLabel;
@property(nonatomic,strong)UILabel *numLabel;
-(void)setIntroductionText:(NSString*)text;
@end
