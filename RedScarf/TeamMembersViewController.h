//
//  TeamMembersViewController.h
//  
//
//  Created by zhangb on 15/9/22.
//
//

#import "BaseViewController.h"

@interface TeamMembersViewController : BaseViewController
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)NSArray *array;
@property(nonatomic,strong)NSMutableArray *filteredArray;
@property(nonatomic,strong)UISearchDisplayController *searchaDisplay;
@end
