//
//  TeamMembersViewController.h
//  
//
//  Created by zhangb on 15/9/22.
//
//

#import "RSTableViewController.h"

@interface TeamMembersViewController : RSTableViewController<UISearchDisplayDelegate>
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)NSMutableArray *filteredArray;
@property(nonatomic,strong)UISearchDisplayController *searchaDisplay;
@end
