//
//  NewsModel.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/18.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return@{@"descript":@"description",@"picList":@"extParam.picList",@"upCount":@"extParam.upCount"};
}

@end
