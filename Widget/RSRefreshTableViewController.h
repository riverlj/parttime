//
//  RSRefreshTableViewController.h
//  RedScarf
//
//  Created by lishipeng on 15/12/30.
//  Copyright © 2015年 zhangb. All rights reserved.
//

#import "RSTableViewController.h"

@interface RSRefreshTableViewController : RSTableViewController

@property(nonatomic, strong) NSString *url;
@property(nonatomic, strong) NSString *httpMethod;
@property(nonatomic, strong) id params;
@property(nonatomic) BOOL useFooterRefresh;
@property(nonatomic) BOOL useHeaderRefresh;
@property(nonatomic) NSInteger pageNum;
@property(nonatomic) NSInteger pageSize;


// 开始http请求
-(void) beginHttpRequest;
// 在网络请求之前调用该方法
-(void) beforeHttpRequest;
// 在网络成功返回时调用该方法
-(void) afterHttpSuccess:(NSDictionary *)data;
// 在网络失败返回时调用该方法
-(void) afterHttpFailure:(NSInteger)code  errmsg:(NSString *)errmsg;

//常规情况下，这两个方法不需要重写
-(void) beforeProcessHttpData;
-(void) afterProcessHttpData:(NSInteger)before afterCount:(NSInteger) after;
@end
