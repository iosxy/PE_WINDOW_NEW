//
//  YCHDataBaseManager.h
//  Product3-ILimit
//
//  Created by 游成虎 on 16/4/8.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCHDataBaseManager : NSObject
+ (YCHDataBaseManager *)sharedManager;
- (NSArray *)findAll;
- (BOOL)isAlreadyFavorite:(NSString *)applicationId;
- (BOOL)adFavorite:(NSDictionary *)appInfo;
- (BOOL)deleteFavorite:(NSString *)applicationId;
@end
