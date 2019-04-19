//
//  YCHNetworking.m
//  LOLInfo
//
//  Created by 游成虎 on 16/4/11.
//  Copyright © 2016年 游成虎. All rights reserved.
//

#import "YCHNetworking.h"

@implementation YCHNetworking

+ (void)startRequestFromUrl:(NSString *)url andParamter:(NSDictionary * )paramter returnData:(void (^)(NSData * data,NSError * error))returnBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //设置默认返回数据类型为二进制
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:url parameters:paramter success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //请求数据成功,不报错 ,回传数据
        if (responseObject) {
            returnBlock(responseObject,nil);
        }else {
            NSError * error = [NSError new];
            returnBlock(nil,error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求数据失败
        returnBlock(nil,error);
    }];
}
+ (void)postStartRequestFromUrl:(NSString *)url andParamter:(NSDictionary * )paramter returnData:(void (^)(NSData * data,NSError * error))returnBlock
{
    AFHTTPRequestOperationManager * manager = [AFHTTPRequestOperationManager manager];
    //设置默认返回数据类型为二进制
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes =[NSSet setWithObjects:@"application/json",@"text/json",@"text/javascript",@"text/html",@"text/plain",nil];
    manager.requestSerializer.timeoutInterval = 15.f;
    
    NSDictionary * newPara = @{@"token" : @"" , @"map" : paramter};
    NSLog([NSString stringWithFormat:@"%@" ,newPara]);
    [manager POST:url parameters:newPara success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //请求数据成功,不报错 ,回传数据
        if (responseObject) {
            returnBlock(responseObject,nil);
        }else {
            NSError * error = [NSError new];
            returnBlock(nil,error);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //请求数据失败
        returnBlock(nil,error);
    }];
}


@end
