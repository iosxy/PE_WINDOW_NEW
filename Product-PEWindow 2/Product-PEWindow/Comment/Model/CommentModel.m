//
//  CommentModel.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "CommentModel.h"

@implementation CommentModel
+ (NSDictionary *)modelCustomPropertyMapper{
    return @{@"ID":@"id",@"picList":@"extParam.picList",@"nickName":@"nickname"};
}
@end
