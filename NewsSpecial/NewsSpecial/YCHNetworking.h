//
//  YCHNetworking.h
//  LOLInfo
//
//  Created by 游成虎 on 16/4/11.
//  Copyright © 2016年 游成虎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YCHNetworking : NSObject
+ (void)startRequestFromUrl:(NSString *)url andParamter:(NSDictionary * )paramter returnData:(void (^)(NSData * data,NSError * error))returnBlock;
@end
