//
//  YCHDataBaseManager.m
//  Product3-ILimit
//
//  Created by 游成虎 on 16/4/8.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "YCHDataBaseManager.h"
#import "FMDatabase.h"
#import "GameHotModel.h"
//#import "YCHActivityModel.h"
@interface YCHDataBaseManager ()
/**数据库操作句柄 */
@property(nonatomic,strong)FMDatabase* dataBase;
@end
@implementation YCHDataBaseManager
+ (YCHDataBaseManager *)sharedManager
{
    static YCHDataBaseManager * manager = nil;
 
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[YCHDataBaseManager alloc]init];
        [manager setupDataBase];
    });
    return manager;
}
- (void)setupDataBase

{
    self.dataBase = [FMDatabase databaseWithPath:[NSString stringWithFormat:@"%@/Documents/Database.db",NSHomeDirectory()]];
    BOOL result = [self.dataBase open];
    if (result) {
        NSLog(@"打开数据库成功");
    }
    else
    {
        NSLog(@"打开数据库失败");
    }
    //创建表格
    NSString * sql = @"create table if not exists FAVORITE (ID varchar(32) primary key,ItemName varchar(32) not null,HomeName varchar(128),GuestName varchar(128),HomeScore varchar(128),GuestScore varchar(128),StartTime varchar(128),HomePicUrl varchar(128),GuestPicUrl varchar(128))";
    result = [self.dataBase executeUpdate:sql];
    NSLog(@"%@",NSHomeDirectory());
    if (result) {
        NSLog(@"创建表格成功");
    }else
    {
        NSLog(@"创建表格失败");
    }
}


- (NSArray *)findAll{
    
    FMResultSet * set = [self.dataBase executeQuery: @"select * from FAVORITE"];
    NSMutableArray * results = [NSMutableArray array];
    while (set.next) {
        NSString * ID = [set stringForColumnIndex:0];
         NSString * ItemName = [set stringForColumnIndex:1];
         NSString * HomeName = [set stringForColumnIndex:2];
        NSString * GuestName =[set stringForColumnIndex:3];
        NSString * HomeScore = [set stringForColumnIndex:4];
        NSString * GuestScore = [set stringForColumnIndex:5];
          NSString * startTime = [set stringForColumnIndex:6];
          NSString * HomePicUrl = [set stringForColumnIndex:7];
        NSString * guestPicUrl =[set stringForColumnIndex:8];
        GameHotModel * app = [[GameHotModel alloc]init];
        app.ID = ID;
        app.itemName = ItemName;
        app.homeName = HomeName;
        app.guestName = GuestName;
        app.homeScore = HomeScore;
        app.guestScore = GuestScore;
        app.startTime = startTime;
        app.homePicUrl = HomePicUrl;
        app.guestPicUrl = guestPicUrl;
       [results addObject:app];
    }
    return results;
}
- (BOOL)isAlreadyFavorite:(NSString *)applicationId{
    FMResultSet * set = [self.dataBase executeQueryWithFormat:@"select itemName from FAVORITE where ID=%@", applicationId];
    while(set.next) {
        return YES;
    }
    return NO;
}
- (BOOL)adFavorite:(NSDictionary *)appInfo{
 
      return [self.dataBase executeUpdate:@"insert into FAVORITE values (:ID, :itemName, :HomeName,:GuestName,:HomeScore,:GuestScore,:StartTime,:HomePicUrl,:GuestPicUrl)"
                  withParameterDictionary:appInfo];

}
- (BOOL)deleteFavorite:(NSString *)applicationId{
    
    return [self.dataBase executeUpdateWithFormat:@"delete from favorite where ID=%@",applicationId];
}

@end
