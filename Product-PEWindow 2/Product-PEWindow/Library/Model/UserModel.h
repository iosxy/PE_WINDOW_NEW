//
//  UserModel.h
//  Product-PEWindow
//
//  Created by 欢瑞世纪 on 2019/3/25.
//  Copyright © 2019 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject
@property (nonatomic,strong) UIImage * headImage;
+ (instancetype)shared;


@end

NS_ASSUME_NONNULL_END
