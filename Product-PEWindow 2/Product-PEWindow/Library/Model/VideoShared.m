//
//  VideoShared.m
//  Product-PEWindow
//
//  Created by huhu on 2019/4/2.
//  Copyright © 2019年 qianfeng. All rights reserved.
//

#import "VideoShared.h"

@interface VideoShared()



@end

@implementation VideoShared
+ (instancetype)shared
{
    
    static VideoShared * model ;
    if (!model) {
        model = [[VideoShared alloc]init];
        model.videoArr = [NSMutableArray array];
    }
    return  model;
    
}
@end
