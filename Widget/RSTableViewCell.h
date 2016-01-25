//
//  RSTableViewCell.h
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RSModel.h"

@interface RSTableViewCell : UITableViewCell{
}
@property (nonatomic,strong)RSModel *model;
@property (nonatomic) BOOL isSelectable;
- (id)initWithStyle:(UITableViewCellStyle)style;
@end
