//
//  UIView+MBProgressHUD.m
//  GetOn
//
//  Created by DUCHENGWEN on 2017/4/27.
//  Copyright © 2017年 Tonchema. All rights reserved.
//


#import "UIView+MBProgressHUD.h"
#import "YLImageView.h"
#import "YLGIFImage.h"


@implementation UIView (MBProgressHUD)

- (MBProgressHUD *)showLoadingMeg:(NSString *)meg
{
    MBProgressHUD *hudView = [MBProgressHUD HUDForView:self];
    if (!hudView) {
        hudView = [MBProgressHUD showHUDAddedTo:self animated:YES];
    }
    else
    {
        [hudView show:YES];
    }
    hudView.detailsLabelText = meg;
    return hudView;
}

- (MBProgressHUD *)gifShowLoadingMeg:(NSString *)meg{
    MBProgressHUD *hudView = [MBProgressHUD HUDForView:self];
    if (!hudView) {
        hudView = [MBProgressHUD showHUDAddedTo:self animated:YES];
    }
    else
    {
        [hudView show:YES];
    }
    if (!hudView.customView) {
        YLImageView* imageView = [[YLImageView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        imageView.image = [YLGIFImage imageNamed:@"页面等待加载动画.gif"];
        hudView.customView = imageView;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    
    hudView.labelText = meg;
    hudView.mode = MBProgressHUDModeCustomView;
    
    hudView.color =[UIColor clearColor];
//    hudView.color = [hudView.color colorWithAlphaComponent:0.1];
    
    hudView.labelColor = RGB(0x333333);
    hudView.labelFont = [UIFont systemFontOfSize:12];
    hudView.backgroundColor =[UIColor clearColor];
    hudView.backgroundColor=RGBACOLOR(255,255,255, 0.4);
    
    return hudView;
}


- (void)hideLoading
{
//    [[YBallLoadingManager shareInstance]endAnimation];
    [MBProgressHUD hideHUDForView:self animated:YES];
}

- (void)showLoadingMeg:(NSString *)meg time:(NSUInteger)time
{
    MBProgressHUD *hud = [self showLoadingMeg:meg];
    hud.mode = MBProgressHUDModeCustomView;
    if (time > 0) {
        [self performSelector:@selector(hideLoading) withObject:nil afterDelay:time];
    }
}
- (void)delayHideLoading
{
    [self performSelector:@selector(hideLoading) withObject:nil afterDelay:kDefaultShowTime];
}

@end

