//
//  RSTableViewController.h
//  RedScarf
//
//  Created by lishipeng on 15/12/9.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "BaseViewController.h"
#import "RSModel.h"
#import "RSTableViewCell.h"

@protocol MTTableViewControllerDelegate <NSObject>
- (void)tableController:(UIViewController *)controller didSelectRowAtIndexPath:(NSIndexPath *)indexPath selectedItem:(id)item forCell:(UITableViewCell *)cell;
@end

@interface RSTableViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_models;
}
@property (nonatomic,assign)UITableViewStyle tableStyle;
@property (nonatomic,strong)NSMutableArray *models;//不含section信息
@property (nonatomic,strong)NSMutableArray *sections;//section的title数组，数量可以小于items的组数
@property (nonatomic,weak)id/*<MTTableViewControllerDelegate>*/ delegate;

- (id)initWithStyle:(UITableViewStyle)tableStyle;
@end
