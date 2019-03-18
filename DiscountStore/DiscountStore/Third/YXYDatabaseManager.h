//
//  YXYDatabaseManager.h
//  Product3-ILimit
//
//  Created by qianfeng on 16/4/8.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface YXYDatabaseManager : NSObject

//单例
+ (YXYDatabaseManager *)sharedManager;

//查询所有
- (NSArray *)findAllWithTableName:(NSString *)tableName;

//查看是否已经收藏
- (BOOL)isAlreadyFavoriteWithTableName:(NSString *)tableName andnum_iid:(NSString *)num_iid;
//新增收藏
- (BOOL)addFavoriteWithTableName:(NSString *)tableName andDictionary:(NSDictionary *)appInfo;
//删除一条收藏
- (BOOL)deleteFavoriteWithTableName:(NSString *)tableName andnum_iid:(NSString *)num_iid;



@end
