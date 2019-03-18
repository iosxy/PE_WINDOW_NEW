//
//  RedYellowModel.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RedYellowModel : NSObject
/** teamName*/
@property(nonatomic,copy)NSString * teamName;
/** playerName*/
@property(nonatomic,copy)NSString * playerName;
/** yellowCards*/
@property(nonatomic,copy)NSString * yellowCards;
/** redCards*/
@property(nonatomic,copy)NSString * redCards;
/** teamLogo*/
@property(nonatomic,copy)NSString * teamLogoUrl;

@end
