//
//  RSAssignedTaskModel.m
//  RedScarf
//
//  Created by lishipeng on 16/1/4.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSTaskModel.h"

@implementation RSTaskModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"count": @"count",
             @"tag" : @"tag",
             @"content" : @"content",
        };
}

-(NSString *)cellClassName
{
    return @"SeparateTableViewCell";
}

+(instancetype) normalHeader
{
    RSTaskModel *model = [[RSTaskModel alloc] init];
    model.count = @"数量";
    model.tag = @"商品名称";
    model.content = @"商品详情";
    model.isSelectable = false;
    return model;
}

-(RSTableViewCell *) getCell
{
    RSTableViewCell *cell = [[NSClassFromString(self.cellClassName) alloc] init];
    [cell setModel:self];
    return cell;
}
@end


@implementation RSAssignedTaskModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"nickname": @"nickname",
             @"mobile" : @"mobile",
             @"tasks" : @"tasks",
    };
}

+ (NSValueTransformer *)tasksJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[RSTaskModel class]];
}

-(NSString *)cellClassName
{
    return @"RSTaskTitleViewCell";
}

//添加表头
-(void) addHeader
{
    NSMutableArray *arr = [self.tasks mutableCopy];
    if(arr) {
        [arr insertObject:[RSTaskModel normalHeader] atIndex:0];
    }
    self.tasks = [arr copy];
}
@end


@implementation RSDistributionTaskModel
+(NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name": @"name",
             @"id" : @"id",
             @"tasks" : @"contentList"
             };
}

+ (NSValueTransformer *)tasksJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:[RSTaskModel class]];
}

-(NSString *)cellClassName
{
    return @"RSTaskTitleViewCell";
}

//添加表头
-(void) addHeader
{
    NSMutableArray *arr = [self.tasks mutableCopy];
    if(arr) {
        [arr insertObject:[RSTaskModel normalHeader] atIndex:0];
    }
    self.tasks = [arr copy];
}
@end