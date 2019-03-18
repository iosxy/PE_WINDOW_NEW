//
//  NewsModel.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/18.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject
/** name*/
@property(nonatomic,copy)NSString * name;

/** 描述*/
@property(nonatomic,copy)NSString * descript;

/** 评论数*/
@property(nonatomic,copy)NSString * commentCount;

/** 点赞数*/
@property(nonatomic,copy)NSString * upCount;
/** ID*/
@property(nonatomic,copy)NSString * contentId;
/** 数组*/
@property(nonatomic,strong)NSArray * picList;
/** 显示模式*/
/** coverUrl*/
@property(nonatomic,copy)NSString * coverUrl;
@property(nonatomic,strong)NSString * displayMode;
@end
