//
//  UIView+AdjustFrame.h
//  Day10-QQZoneiPad
//
//  Created by Naibin on 16/3/8.
//  Copyright © 2016年 Naibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (AdjustFrame)

- (CGPoint)origin;
- (void)setOrigin:(CGPoint) point;

- (CGSize)size;
- (void)setSize:(CGSize) size;

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)tail;
- (void)setTail:(CGFloat)tail;

- (CGFloat)bottom;
- (void)setBottom:(CGFloat)bottom;

- (CGFloat)right;
- (void)setRight:(CGFloat)right;

- (void)setTapActionWithBlock:(void (^)(void))block;

- (void)setLongPressActionWithBlock:(void (^)(void))block;

@end
