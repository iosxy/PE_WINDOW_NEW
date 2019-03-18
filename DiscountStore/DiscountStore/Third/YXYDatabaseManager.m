//
//  YXYDatabaseManager.m
//  Product3-ILimit
//
//  Created by qianfeng on 16/4/8.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "YXYDatabaseManager.h"
#import "HomeDetailModel.h"


@interface YXYDatabaseManager ()

/** 数据库操作句柄*/
@property (nonatomic,strong)  FMDatabase * database;

@end


@implementation YXYDatabaseManager

//单例
+ (YXYDatabaseManager *)sharedManager
{
    static YXYDatabaseManager * manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YXYDatabaseManager alloc]init];
        [manager setupDatabase];
    });
    return manager;
}

- (void)setupDatabase
{
    //配置数据库
    self.database = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/Documents/database.db",NSHomeDirectory()]];
    BOOL result = [self.database open];
    if (result) {
       
    }
    else
    {
        NSLog(@"打开数据库失败");
    }
    
    
    NSString * sql1 = [NSString stringWithFormat:@"create table if not exists favorite (num_iid varchar(32) primary key, title varchar(128) not null, origin_price varchar(32),now_price varchar(32), pic_url varchar(128))"];
    result = [self.database executeUpdate:sql1];
    if (result) {
        
    }
    else
    {
        NSLog(@"创建表1失败");
    }
    
    NSString * sql2 = [NSString stringWithFormat:@"create table if not exists shoppingcart (num_iid varchar(32) primary key, title varchar(128) not null, origin_price varchar(32),now_price varchar(32), pic_url varchar(128))"];
    result = [self.database executeUpdate:sql2];
    if (result) {
       
    }
    else
    {
        NSLog(@"创建表2失败");
    }
    
    NSString * sql3 = [NSString stringWithFormat:@"create table if not exists cart (num_iid varchar(32) primary key, title varchar(128) not null, origin_price varchar(32),now_price varchar(32), pic_url varchar(128))"];
    result = [self.database executeUpdate:sql3];
    if (result) {
        
    }
    else
    {
        NSLog(@"创建表3失败");
    }
    NSString * sql4 = [NSString stringWithFormat:@"create table if not exists pay (num_iid varchar(32) primary key, title varchar(128) not null, origin_price varchar(32),now_price varchar(32), pic_url varchar(128))"];
    result = [self.database executeUpdate:sql4];
    if (result) {
       
    }
    else
    {
        NSLog(@"创建表4失败");
    }


}

//查询所有
- (NSArray *)findAllWithTableName:(NSString *)tableName
{
    FMResultSet * set = [self.database executeQuery:[NSString stringWithFormat:@"select * from %@",tableName]];
    NSMutableArray * results = [NSMutableArray array];
    while (set.next) {
        NSString * num_iid = [set stringForColumnIndex:0];
         NSString * title = [set stringForColumnIndex:1];
         NSString * origin_price = [set stringForColumnIndex:2];
        NSString * now_price = [set stringForColumnIndex:3];
         NSString * pic_url = [set stringForColumnIndex:4];
      //  NSString * rp_sold = [set stringForColumnIndex:5];
        HomeDetailModel * model = [[HomeDetailModel alloc]init];
        model.num_iid = num_iid;
        model.title = title;
        model.origin_price = origin_price;
        model.now_price = now_price;
        model.pic_url = pic_url;
       // model.rp_sold = rp_sold;
        
        [results addObject:model];
        
    }
    return results;
}
//查看是否已经收藏
- (BOOL)isAlreadyFavoriteWithTableName:(NSString *)tableName andnum_iid:(NSString *)num_iid
{
    FMResultSet * set = [self.database executeQueryWithFormat:@"select name from %@ where num_iid=%@",tableName,num_iid];
    while (set.next) {
        return YES;
    }
    return NO;
}
//新增收藏
//新增收藏
- (BOOL)addFavoriteWithTableName:(NSString *)tableName andDictionary:(NSDictionary *)appInfo
{
    return [self.database executeUpdate:[NSString stringWithFormat:@"insert into %@ values (:num_iid, :title, :origin_price, :now_price, :pic_url)",tableName] withParameterDictionary:appInfo];
    
    
}
//删除一条收藏
- (BOOL)deleteFavoriteWithTableName:(NSString *)tableName andnum_iid:(NSString *)num_iid;
{
    return [self.database executeUpdate:[NSString stringWithFormat:@"delete from %@ where num_iid=%@",tableName,num_iid]];
}


@end
