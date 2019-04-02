//
//  VideoShared.h
//  Product-PEWindow
//
//  Created by huhu on 2019/4/2.
//  Copyright © 2019年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoShared : NSObject
+ (instancetype)shared;
@property(nonatomic,strong) NSMutableArray * videoArr;
@end
