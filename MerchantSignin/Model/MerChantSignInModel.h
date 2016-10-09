//
//  MerChantSignInModel.h
//  RedScarf
//
//  Created by 李江 on 16/10/8.
//  Copyright © 2016年 zhangb. All rights reserved.
//

#import "RSModel.h"

@interface MerChantSignInModel : RSModel<MTLJSONSerializing>
@property (nonatomic, strong)NSNumber *goodsid;
@property (nonatomic, strong)NSString *mobile;
@property (nonatomic, strong)NSNumber *status;
@property (nonatomic, strong)NSString *goodsname;
@property (nonatomic, strong)NSString *checktime;
@property (nonatomic, strong)NSString *optusername;

+(void)getSchoolInfo:(void(^)(NSArray *merchants))success failure:(void(^)(void))failure;
+ (void)makeSureSended:(MerChantSignInModel *)model success:(void(^)(void))success failure:(void(^)(void))failure ;
+ (void)sendMissGood:(NSDictionary *)params success:(void(^)(void))success failure:(void(^)(void))failure ;
@end
