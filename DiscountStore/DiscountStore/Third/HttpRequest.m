//
//  HttpRequest.m
//  LOLInfo
//
//  Created by 游成虎 on 16/4/11.
//  Copyright © 2016年 游成虎. All rights reserved.
//

#import "HttpRequest.h"

@implementation HttpRequest

+ (void)startRequestFromUrl:(NSString*)url AndParameter:(NSDictionary*)parameter returnData:(void (^)(NSData * resultData,NSError * error))returnBlock{
    //解析数据
    //请求队列管理者
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //设置默认返回数据类型为二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:url parameters:parameter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //请求数据成功，无报错，回传数据
        returnBlock(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求数据失败，产生报错
        returnBlock(nil,error);
    }];
    
}

@end
