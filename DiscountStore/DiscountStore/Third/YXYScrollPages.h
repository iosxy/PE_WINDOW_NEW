//
//  YXYScrollPages.h
//  Day13ScrollPages
//
//  Created by qianfeng on 16/4/7.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TAG_BEGIN 25256
#define SELECTED_COLOR [UIColor colorWithRed:219 / 255.0 green:50 / 255.0 blue:54 / 255.0 alpha:1]


@interface YXYScrollPages : UIView

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles andCallBack:(void(^)(UIScrollView *scrollView, NSUInteger index))callBack;

@end


