//
//  TCImageDownloadView.h
//  GetOn
//
//  Created by 王骏超 on 15/5/29.
//  Copyright (c) 2015年 Tonchema. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIImageView+WebCache.h"

@interface MBProgressHUD (Masonry)

+ (instancetype)showHUDWithConstrainAddedTo:(UIView *)view animated:(BOOL)animated;
@end


@interface TCImageDownloadView : UIImageView

/**
 @param url 图片URL
 */
- (void)setImageUrl:(NSURL *)url;


/**
 @param url 
 @param placeholder 占位图片
 */
- (void)setImageUrl:(NSURL *)url placeholder:(UIImage *)placeholder;

/**
 *  加载图片时会有提示框，提示框和该视图使用masonry加了约束
 *
 *  @param URL url
 */
- (void)setImageURL:(NSURL *)URL;
- (void)setImageURL:(NSURL *)URL placeholder:(UIImage *)placeholder;

// 无加载进度
- (void)setHiddenHUDImageUrl:(NSURL *)url;
- (void)setHiddenHUDImageUrl:(NSURL *)url placeholder:(UIImage *)placeholder;
@end
