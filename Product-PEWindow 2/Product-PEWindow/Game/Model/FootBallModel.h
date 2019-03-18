//
//  FootBallModel.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FootBallModel : NSObject
/** games*/
@property(nonatomic,copy)NSString * games;
@property(nonatomic,copy)NSString * teamName;
@property(nonatomic,copy)NSString * logoUrl;
@property(nonatomic,copy)NSString * goalsFor;
@property(nonatomic,copy)NSString * losses;
@property(nonatomic,copy)NSString * goalsAgainst;
@property(nonatomic,copy)NSString * draws;
@property(nonatomic,copy)NSString * points;
@property(nonatomic,copy)NSString * wins;
@property(nonatomic,copy)NSString * teamId;
@end
