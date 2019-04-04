//
//  ADScrollView.m
//  Day13-CustomCell
//
//  Created by Naibin on 16/3/16.
//  Copyright © 2016年 Naibin. All rights reserved.
//

#import "ADScrollView.h"

@implementation ADScrollView {
    UIScrollView * _scrollView;
    UILabel * _titleLabel;
    // 图片信息
    NSArray * _dataInfo;
    // NSTimer
    NSTimer * _timer;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 创建子视图
        [self buildSubviews];
        // 创建timer
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timerGo:) userInfo:nil repeats:YES];
        [_timer setFireDate:[NSDate distantFuture]];
    }
    return self;
}

- (void)dealloc {
    if (_timer) {
        [_timer invalidate];
    }
}

- (void)buildSubviews {
    // 滚动视图
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.delegate = self;
    
    // 标题
//    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - 30, self.bounds.size.width, 30)];
//    _titleLabel.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.6];
//    _titleLabel.textColor = [UIColor colorWithWhite:0.8 alpha:0.9];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(self.bounds.size.width - 100, self.bounds.size.height - 30, 100, 30)];
    // 选中小圆点的颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.7 alpha:0.9];
    // 未选中的
    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    // 绑定方法
    [_pageControl addTarget:self action:@selector(pagging:) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_scrollView];
//    [self addSubview:_titleLabel];
    [self addSubview:_pageControl];
}

// 填充子视图
- (void)loadDataWithArray:(NSArray *)dataInfo {
    
    _dataInfo = dataInfo;
    
    // 初始化标题内容
//    _titleLabel.text = [NSString stringWithFormat:@"    %@", dataInfo[0]];
    // pageControl
    _pageControl.numberOfPages = dataInfo.count;
    _pageControl.currentPage = 0;
    // 滚动视图
    // 添加子视图
    for (int i = 0; i < dataInfo.count + 1; i++) {
        UIImageView * imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i * self.bounds.size.width, 0, self.bounds.size.width, self.bounds.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        if (i == dataInfo.count) {
            // 最后一项的特殊处理
            NSString * imagePath = [[NSBundle mainBundle] pathForResource:dataInfo[0] ofType:nil];
            // 设置图片
            imageView.image = [UIImage imageWithContentsOfFile:imagePath];
            
            [_scrollView addSubview:imageView];
            
            break;
        }
        
        NSString * imagePath = [[NSBundle mainBundle] pathForResource:dataInfo[i] ofType:nil];
        // 设置图片
        UIImage * image = [UIImage imageWithContentsOfFile:imagePath];
        imageView.image = image;
        
        [_scrollView addSubview:imageView];
    }
    // 设置包含内容大小
    _scrollView.contentSize = CGSizeMake((dataInfo.count + 1) * self.bounds.size.width, self.bounds.size.height);
    
    // 多线程，延迟执行某些代码
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 开启定时器
        [_timer setFireDate:[NSDate distantPast]];
    });
    
}

#pragma mark - 定时器方法
- (void)timerGo:(NSTimer *)timer {
    NSInteger currentPage = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    // 修改滚动视图的偏移量
    [_scrollView setContentOffset:CGPointMake((currentPage + 1) * _scrollView.bounds.size.width, 0) animated:YES];
}

#pragma mark - PageControl方法
- (void)pagging:(UIPageControl *)pgc {
    NSInteger currentPage = pgc.currentPage;
    [_scrollView setContentOffset:CGPointMake(currentPage * _scrollView.bounds.size.width, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    // 停止
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSInteger wholePages = scrollView.contentSize.width / scrollView.bounds.size.width;
    
    // 最后一页判断
    if (currentPage == wholePages - 1) {
        [scrollView setContentOffset:CGPointZero animated:NO];
        currentPage = 0;
    }
    _pageControl.currentPage = currentPage;
    
    // 修改文本内容
//    _titleLabel.text = [NSString stringWithFormat:@"    %@", _dataInfo[currentPage]];
}

/*
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // 停止
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSInteger wholePages = scrollView.contentSize.width / scrollView.bounds.size.width;
    
    // 最后一页判断
    if (currentPage == wholePages - 1) {
        [scrollView setContentOffset:CGPointZero animated:NO];
        currentPage = 0;
    }
    
    _pageControl.currentPage = currentPage;
    // 修改文本内容
    _titleLabel.text = [NSString stringWithFormat:@"    %@", _dataInfo[currentPage]];
}
 */


@end









