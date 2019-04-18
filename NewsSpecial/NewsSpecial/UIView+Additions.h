//
//  UIView+Additions.h
//  iFramework
//
//  Created by JiangHaoyuan on 13-10-8.
//  Copyright (c) 2013年 JiangHaoyuan. All rights reserved.
//



#import <UIKit/UIKit.h>

//@interface UINavigationController(Additions)
//
//- (void) pushViewControllerAllowSwipBack:(TCViewController *)viewController;
//
//@end


@interface UIBarButtonItem(Additions)

- (id) initWithImage:(UIImage*)image target:(id)target action:(SEL)action;

- (id) initWithImage:(UIImage*)image hilightImage:(UIImage*)hilightImage target:(id)target action:(SEL)action;

@end



@interface UIControl(Additions)

- (void)addTarget:(id)target action:(SEL)action;

@end


@interface UIButton(Additions)


@property (nonatomic) NSString *title;

@end

@interface UIScrollView(Additions)


- (void) killScroll;

@end




@interface UIView(Additions)

- (void) setBadge:(NSString*)badge height:(CGFloat)height;

- (void) setBadge:(NSString*)badge height:(CGFloat)height aligmentShift:(CGSize)aligmentShif;

@property (nonatomic, strong) id object;

@property (nonatomic, assign) id assignObject;

- (__kindof UIViewController *) firstAvailableUIViewController;

/**
 * Shortcut for frame.origin.x.
 *
 * Sets frame.origin.x = left
 */
@property (nonatomic) CGFloat left;

/**
 * Shortcut for frame.origin.y
 *
 * Sets frame.origin.y = top
 */
@property (nonatomic) CGFloat top;

/**
 * Shortcut for frame.origin.x + frame.size.width
 *
 * Sets frame.origin.x = right - frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 * Shortcut for frame.origin.y + frame.size.height
 *
 * Sets frame.origin.y = bottom - frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 * Shortcut for frame.size.width
 *
 * Sets frame.size.width = width
 */
@property (nonatomic) CGFloat width;

/**
 * Shortcut for frame.size.height
 *
 * Sets frame.size.height = height
 */
@property (nonatomic) CGFloat height;

/**
 * Shortcut for center.x
 *
 * Sets center.x = centerX
 */
@property (nonatomic) CGFloat centerX;

/**
 * Shortcut for center.y
 *
 * Sets center.y = centerY
 */
@property (nonatomic) CGFloat centerY;


@end
