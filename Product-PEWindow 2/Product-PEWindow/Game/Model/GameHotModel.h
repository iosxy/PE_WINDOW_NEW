//
//  GameHotModel.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/21.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameHotModel : NSObject
/** id*/
@property(nonatomic,copy)NSString * ID;
@property(nonatomic,copy)NSString * gameName;
@property(nonatomic,copy)NSString * gameRound;
@property(nonatomic,copy)NSString * homeName;
@property(nonatomic,copy)NSString * guestName;
@property(nonatomic,copy)NSString * homeScore;
@property(nonatomic,copy)NSString * guestScore;
@property(nonatomic,copy)NSString * statusDesc;
@property(nonatomic,copy)NSString * lotteryDesc;
@property(nonatomic,copy)NSString * leagueName;
@property(nonatomic,copy)NSString * homePicUrl;
@property(nonatomic,copy)NSString * guestPicUrl;
@property(nonatomic,copy)NSString * startTime;
@property(nonatomic,copy)NSString * itemName;
/** <#annotation#>*/
@property(nonatomic,copy)NSString * homeSupports;
@property(nonatomic,copy)NSString * guestSupports;
@end
