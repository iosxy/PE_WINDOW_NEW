//
//  TCHorizontalScrollViewTool.m
//  GetOn
//
//  Created by Katherine on 2017/3/22.
//  Copyright © 2017年 Tonchema. All rights reserved.
//

#import "TCHorizontalScrollViewTool.h"
#import <Masonry/Masonry.h>
#import "Masonry.h"


@implementation TCHorizontalScrollViewTool

- (instancetype)initWithImageViewSize:(CGSize)size{
    if (self = [super init]) {
        self.imageViewSize = size;
    }
    return self;
}

- (instancetype)init{
    return [self initWithImageViewSize:CGSizeMake(SCREEN_WIDTH, 230)];
}

- (void)removeAllImagesM{
    [self.horizontalScrollView.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
}

- (void)removeAllImages{
    [self.horizontalScrollView.scrollView.subviews enumerateObjectsUsingBlock:^(UIView *view, NSUInteger idx, BOOL *stop) {
        [view removeFromSuperview];
    }];
    self.horizontalScrollView.scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)setImageUrls:(NSArray *)imageUrls{
    imageUrls = imageUrls;
    _imagUrls = imageUrls;
    CGSize size = self.horizontalScrollView.bounds.size;
    self.horizontalScrollView.pageControl.numberOfPages = imageUrls.count;
    self.horizontalScrollView.pageControl.currentPage = 0;
    [self.horizontalScrollView.scrollView setContentSize:CGSizeMake(size.width * imageUrls.count, 0)];
    
    [imageUrls enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            obj = [NSURL URLWithString:obj];
        }
        
        TCImageDownloadView *imageView = [[TCImageDownloadView alloc]init];
        
        CGRect frame = CGRectMake(idx * size.width, 0, size.width, size.height);
        [imageView setFrame:frame];
        [self.horizontalScrollView.scrollView addSubview:imageView];
        [imageView setHiddenHUDImageUrl:obj];
        
    }];
}

- (void)setImageURLs:(NSArray *)imageURLs{
    _imagUrls = imageURLs;
    self.horizontalScrollView.pageControl.numberOfPages = imageURLs.count;
    self.horizontalScrollView.pageControl.currentPage = 0;
    
    [self.horizontalScrollView.pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.horizontalScrollView);
        make.bottom.equalTo(self.horizontalScrollView).offset(0);
    }];
    
    [self.horizontalScrollView.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.horizontalScrollView);
    }];
    
    UIView *contentView = [[UIView alloc]init];
    
    [self.horizontalScrollView.scrollView addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.horizontalScrollView.scrollView);
        make.height.equalTo(self.horizontalScrollView.scrollView);
    }];
    
    __block UIImageView *imageViewTemp;
    [imageURLs enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[NSString class]]) {
            obj = [NSURL URLWithString:obj];
        }
        
        TCImageDownloadView *imageView = [[TCImageDownloadView alloc]init];
        
        [contentView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            if (!imageViewTemp) {
                make.left.equalTo(contentView);
            }else{
                make.left.equalTo(imageViewTemp.mas_right);
            }
            make.top.bottom.equalTo(contentView);
            if (idx == (imageURLs.count - 1)) {
                make.right.equalTo(contentView.mas_right);
            }
            make.size.mas_equalTo(self.imageViewSize);
        }];
        imageViewTemp = imageView;
        [imageView setImageURL:obj];
        
    }];
}

- (TCHorizontalScrollview *)horizontalScrollView{
    if (!_horizontalScrollView) {
        _horizontalScrollView = [[TCHorizontalScrollview alloc]init];        
        [_horizontalScrollView.scrollView setDelegate:self];
        _horizontalScrollView.pageControl.hidesForSinglePage = YES;
    }
    return _horizontalScrollView;
}


#pragma mark - UIScroll Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    [self.horizontalScrollView.pageControl setCurrentPage:currentPage];
    
}

@end
