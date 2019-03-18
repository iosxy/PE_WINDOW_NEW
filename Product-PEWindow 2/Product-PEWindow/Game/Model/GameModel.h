//
//  GameModel.h
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/19.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameModel : NSObject
/** name*/
@property(nonatomic,copy)NSString * boardName;
/** id*/
@property(nonatomic,copy)NSString * ID;
/** logo*/
@property(nonatomic,copy)NSString * logoPath;
/** json*/
@property(nonatomic,copy)NSString * json;
/** sortNo*/
@property(nonatomic,copy)NSString * sortNo;
@end
