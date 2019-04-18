//
//  UIView+MBProgressHUD.h
//  GetOn
//
//  Created by DUCHENGWEN on 2017/4/27.
//  Copyright © 2017年 Tonchema. All rights reserved.
//


#import <UIKit/UIKit.h>

#define kDefaultShowTime 1
#define kLoginShowTime 11
#define kLogintwoTime 2
#define kLogintenTime 6

#define kPromptThreeTime 3

//#define kNetWorkLoadingMessage @"加载中..."
#define kNetWorkLoadingMessage @""
#define kNetWorkError          @"网络连接失败,请稍后再试"


@interface UIView (MBProgressHUD)
//显示
- (MBProgressHUD *)showLoadingMeg:(NSString *)meg;
- (MBProgressHUD *)gifShowLoadingMeg:(NSString *)meg;
//消失
- (void)hideLoading;
//设置几秒后消失
- (void)showLoadingMeg:(NSString *)meg time:(NSUInteger)time;
//2秒后消失
- (void)delayHideLoading;

@end
