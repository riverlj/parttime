//
//  RSAssignedTaskModel.h
//  RedScarf
//
//  Created by lishipeng on 16/1/4.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSModel.h"
#import "RSTableViewCell.h"

@interface RSTaskModel : RSModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *count;
@property (nonatomic, strong) NSString *tag;
@property (nonatomic, strong) NSString *content;

-(RSTableViewCell *) getCell;
@end

@interface RSAssignedTaskModel : RSModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *mobile;
@property (nonatomic, strong) NSArray *tasks;

-(void) addHeader;
@end


@interface RSDistributionTaskModel : RSModel<MTLJSONSerializing>
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSArray *tasks;
-(void) addHeader;
@end
