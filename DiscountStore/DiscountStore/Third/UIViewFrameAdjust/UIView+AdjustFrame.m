//
//  UIView+AdjustFrame.m
//  Day10-QQZoneiPad
//
//  Created by Naibin on 16/3/8.
//  Copyright © 2016年 Naibin. All rights reserved.
//

#import "UIView+AdjustFrame.h"
#import <objc/runtime.h>

static char kFCCActionHandlerTapBlockKey;
static char kFCCActionHandlerTapGestureKey;
static char kFCCActionHandlerLongPressBlockKey;
static char kFCCActionHandlerLongPressGestureKey;

@implementation UIView (AdjustFrame)

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint) point {
    self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
}

- (CGSize)size {
    return self.frame.size;
}

- (void)setSize:(CGSize) size {
    self.frame = CGRectMake(self.x, self.y, size.width, size.height);
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {
    self.frame = CGRectMake(x, self.y, self.width, self.height);
}

- (CGFloat)y {
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y {
    self.frame = CGRectMake(self.x, y, self.width, self.height);
}

- (CGFloat)height {
    return self.frame.size.height;
}
- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(self.x, self.y, self.width, height);
}

- (CGFloat)width {
    return self.frame.size.width;
}
- (void)setWidth:(CGFloat)width {
    self.frame = CGRectMake(self.x, self.y, width, self.height);
}

- (CGFloat)tail {
    return self.y + self.height;
}

- (void)setTail:(CGFloat)tail {
    self.frame = CGRectMake(self.x, tail - self.height, self.width, self.height);
}

- (CGFloat)bottom {
    return self.tail;
}

- (void)setBottom:(CGFloat)bottom {
    [self setTail:bottom];
}

- (CGFloat)right {
    return self.x + self.width;
}

- (void)setRight:(CGFloat)right {
    self.frame = CGRectMake(right - self.width, self.y, self.width, self.height);
}

- (void)setTapActionWithBlock:(void (^)(void))block
{
    UITapGestureRecognizer *gesture = objc_getAssociatedObject(self, &kFCCActionHandlerTapGestureKey);
    
    if (!gesture)
    {
        gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForTapGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kFCCActionHandlerTapGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kFCCActionHandlerTapBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForTapGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized)
    {
        void(^action)(void) = objc_getAssociatedObject(self, &kFCCActionHandlerTapBlockKey);
        
        if (action)
        {
            action();
        }
    }
}

- (void)setLongPressActionWithBlock:(void (^)(void))block
{
    UILongPressGestureRecognizer *gesture = objc_getAssociatedObject(self, &kFCCActionHandlerLongPressGestureKey);
    
    if (!gesture)
    {
        gesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(__handleActionForLongPressGesture:)];
        [self addGestureRecognizer:gesture];
        objc_setAssociatedObject(self, &kFCCActionHandlerLongPressGestureKey, gesture, OBJC_ASSOCIATION_RETAIN);
    }
    
    objc_setAssociatedObject(self, &kFCCActionHandlerLongPressBlockKey, block, OBJC_ASSOCIATION_COPY);
}

- (void)__handleActionForLongPressGesture:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        void(^action)(void) = objc_getAssociatedObject(self, &kFCCActionHandlerLongPressBlockKey);
        
        if (action)
        {
            action();
        }
    }
}

@end
