//
//  HttpRequest.h
//  LOLInfo
//
//  Created by 游成虎 on 16/4/11.
//  Copyright © 2016年 游成虎. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequest : NSObject

+ (void)startRequestFromUrl:(NSString*)url AndParameter:(NSDictionary*)parameter returnData:(void (^)(NSData * resultData,NSError * error))returnBlock;

@end
