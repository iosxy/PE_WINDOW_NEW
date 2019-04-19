//
//  TCImageDownloadView.m
//  GetOn
//
//  Created by 王骏超 on 15/5/29.
//  Copyright (c) 2015年 Tonchema. All rights reserved.
//

#import "TCImageDownloadView.h"
#import "Masonry.h"

@implementation MBProgressHUD (Masonry)

+ (instancetype)showHUDWithConstrainAddedTo:(UIView *)view animated:(BOOL)animated{
    MBProgressHUD *HUD = [MBProgressHUD showHUDAddedTo:view animated:animated];
    [HUD mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(view);
    }];
    return HUD;
}

@end


@implementation TCImageDownloadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}
- (void)setup{
    [self setupSubViews];
    [self setupConstraints];
    [self setupDefaultAppearance];
}

- (void)setupSubViews{
    
}

- (void)setupConstraints{
    
}
- (void)setupDefaultAppearance{
    self.contentMode = UIViewContentModeScaleAspectFit;
    self.clipsToBounds = YES;
}

- (void)setHiddenHUDImageUrl:(NSURL *)url{
    [self setHiddenHUDImageUrl:url placeholder:nil];
}

- (void)setHiddenHUDImageUrl:(NSURL *)url placeholder:(UIImage *)placeholder{
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
}

- (void)setImageUrl:(NSURL *)url{
    [self setImageUrl:url placeholder:nil];
}

- (void)setImageUrl:(NSURL *)url placeholder:(UIImage *)placeholder{
    
    MBProgressHUD *theHUD =  [MBProgressHUD showHUDAddedTo:self animated:YES];
    theHUD.removeFromSuperViewOnHide = YES;
    theHUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    [self sd_setImageWithURL:url placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        theHUD.progress = ((float)receivedSize) / expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [theHUD hide:YES];
    }];
}

- (void)setImageURL:(NSURL *)URL{
    [self setImageURL:URL placeholder:nil];
}
- (void)setImageURL:(NSURL *)URL placeholder:(UIImage *)placeholder{
    MBProgressHUD *theHUD =  [MBProgressHUD showHUDWithConstrainAddedTo:self animated:YES];
    theHUD.removeFromSuperViewOnHide = YES;
    theHUD.mode = MBProgressHUDModeAnnularDeterminate;
    
    [self sd_setImageWithURL:URL placeholderImage:placeholder options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        theHUD.progress = ((float)receivedSize) / expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [theHUD hide:YES];
    }];

}



@end
