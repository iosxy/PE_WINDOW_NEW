//
//  TalkModel.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/22.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkModel : NSObject
/** content*/
@property(nonatomic,copy)NSString * content;
/** nickname*/
@property(nonatomic,copy)NSString * nickname;
/** create*/
@property(nonatomic,copy)NSString * createTime;
/** heading*/
@property(nonatomic,copy)NSString * headImg;
@end
