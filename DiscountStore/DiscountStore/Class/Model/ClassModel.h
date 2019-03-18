//
//  ClassModel.h
//  DiscountStore
//
//  Created by 游成虎 on 16/4/21.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassModel : NSObject

/** 图片 */
@property(nonatomic,copy) NSString * pic;
/** title */
@property(nonatomic,copy) NSString * title;
/** url */
@property(nonatomic,copy) NSString * url;

@property (nonatomic,copy) NSString * text;

/** cid */
@property(nonatomic,copy) NSString * cid;


@end
