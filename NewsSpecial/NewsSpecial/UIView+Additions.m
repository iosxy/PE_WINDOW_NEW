//
//  UIView+Additions.m
//  iFramework
//
//  Created by JiangHaoyuan on 13-10-8.
//  Copyright (c) 2013年 JiangHaoyuan. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <objc/runtime.h>
#import "UIView+Additions.h"

static char UIVIEW_OBJECT_KEY;

static char UIVIEW_ASSIGN_OBJECT_KEY;

static char UIVIEW_BADGE_KEY;

static CGFloat kBarButtonMinWidth = 25;

static CGFloat kBarButtonMinHeight = 40;





//@implementation UINavigationController(Additions)
//
//- (void) pushViewControllerAllowSwipBack:(TCViewController *)viewController{
//    //empty
//}
//
//@end


@implementation UIBarButtonItem(Additions)

- (id) initWithImage:(UIImage*)image target:(id)target action:(SEL)action{
    if( self = [self init] ){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnW = image.size.width > kBarButtonMinWidth?image.size.width:kBarButtonMinWidth;
        CGFloat btnH = image.size.height > kBarButtonMinHeight?image.size.height:kBarButtonMinHeight;
        btn.frame = CGRectMake(0, 0, btnW, btnH );
        [btn setImage:image forState:UIControlStateNormal];
        [btn addTarget:target action:action];
        self.customView = btn;
    }
    return self;
}

- (id) initWithImage:(UIImage*)image hilightImage:(UIImage*)hilightImage target:(id)target action:(SEL)action{
    if( self = [self init] ){
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat btnW = image.size.width > kBarButtonMinWidth?image.size.width:kBarButtonMinWidth;
        CGFloat btnH = image.size.height > kBarButtonMinHeight?image.size.height:kBarButtonMinHeight;
        btn.frame = CGRectMake(0, 0, btnW, btnH );
        [btn setImage:image forState:UIControlStateNormal];
        [btn setImage:hilightImage forState:UIControlStateSelected];
        
        [btn addTarget:target action:action];
        self.customView = btn;
    }
    return self;
}


@end

@implementation UIScrollView(Additions)


- (void) killScroll{
    CGPoint offset = self.contentOffset;
    offset.x -= 1.0;
    offset.y -= 1.0;
    [self setContentOffset:offset animated:NO];
    offset.x += 1.0;
    offset.y += 1.0;
    [self setContentOffset:offset animated:NO];
}

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
/**
 * Additions.
 */

@implementation UIControl (Additions)

- (void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end



@implementation UIButton (Additions)

- (NSString*) title
{
    return [self titleForState:UIControlStateNormal];
}

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}


@end



@implementation UIView (Additions)

- (void) setBadge:(NSString*)badge height:(CGFloat)height{
    [self setBadge:badge height:height aligmentShift:CGSizeZero];
}

- (void) setBadge:(NSString*)badge height:(CGFloat)height aligmentShift:(CGSize)aligmentShift {
   
}

- (void)setObject:(NSObject *)object{
    if (object != nil) {
        objc_setAssociatedObject(self, &UIVIEW_OBJECT_KEY, object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (id)object{
    return objc_getAssociatedObject(self, &UIVIEW_OBJECT_KEY);
}

- (void)setAssignObject:(NSObject *)object{
    if (object != nil) {
        objc_setAssociatedObject(self, &UIVIEW_ASSIGN_OBJECT_KEY, object, OBJC_ASSOCIATION_ASSIGN);
    }
}

- (id )assignObject{
    return objc_getAssociatedObject(self, &UIVIEW_ASSIGN_OBJECT_KEY);
}


- (__kindof UIViewController *) firstAvailableUIViewController{
    return (UIViewController *)[self traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        return nextResponder;
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)left {
    return self.frame.origin.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLeft:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)top {
    return self.frame.origin.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerX {
    return self.center.x;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)centerY {
    return self.center.y;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)width {
    return self.frame.size.width;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (CGFloat)height {
    return self.bounds.size.height;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setHeight:(CGFloat)height {
    if( height < 0 ){
        height = 0;
    }
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}



@end
