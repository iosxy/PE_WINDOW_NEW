//
//  HomeDetailModel.h
//  DiscountStore
//
//  Created by 游成虎 on 16/4/16.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomeDetailModel : NSObject

@property (nonatomic,copy) NSString * num_iid;

/** title */
@property(nonatomic,copy) NSString * title;

/** origin_price */
@property(nonatomic,copy) NSString * origin_price;

/** now_price */
@property(nonatomic,copy) NSString * now_price;

/** pic_url 图片*/
@property(nonatomic,copy) NSString * pic_url;

/** rp_sold 月销售  笔 */
@property(nonatomic,copy) NSString * rp_sold;

/** is_onsale */
@property(nonatomic,copy) NSString * is_onsale;

/** item_url WEBView */
@property(nonatomic,copy) NSString * item_url;

@end
