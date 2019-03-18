//
//  CommentModel.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
/** content*/
@property(nonatomic,copy)NSString * content;
/** create*/
@property(nonatomic,copy)NSString * createTime;
/** id*/
@property(nonatomic,copy)NSString * ID;
/** picList*/
@property(nonatomic,strong)NSMutableArray * picList;
/** nickName*/
@property(nonatomic,copy)NSString * nickName;
/** updateTime*/
@property(nonatomic,strong)NSString * updateTime;
/** userId*/
@property(nonatomic,copy)NSString * userId;
/** title*/
@property(nonatomic,copy)NSString * title;
/** headImg*/
@property(nonatomic,copy)NSString * headImg;
@end
