//
//  GameDetailModel.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/19.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameDetailModel : NSObject
/** logo*/
@property(nonatomic,copy)NSString * logoUrl;
/** teamTitle*/
@property(nonatomic,copy)NSString * teamName;
/** loseCount*/
@property(nonatomic,copy)NSString * loseCount;
/** winCount*/
@property(nonatomic,copy)NSString * winCount;
/** games*/
@property(nonatomic,copy)NSString * games;
/** losses*/
@property(nonatomic,copy)NSString * losses;
/** winRate*/
@property(nonatomic,copy)NSString * winRate;
@end
