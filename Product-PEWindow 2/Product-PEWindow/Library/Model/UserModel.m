//
//  UserModel.m
//  Product-PEWindow
//
//  Created by 欢瑞世纪 on 2019/3/25.
//  Copyright © 2019 qianfeng. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
+ (instancetype)shared
{
    
    static UserModel * model ;
    if (!model) {
        model = [[UserModel alloc]init];
    }
    return  model;
    
    
}
@end
