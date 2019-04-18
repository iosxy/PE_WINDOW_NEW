//
//  TCHorizontalScrollview.m
//  GetOn
//
//  Created by 王骏超 on 15/5/29.
//  Copyright (c) 2015年 Tonchema. All rights reserved.
//

#import "TCHorizontalScrollview.h"

@implementation TCHorizontalScrollview


+ (instancetype)initFromBundle{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(TCHorizontalScrollview.class) owner:nil options:nil];
    TCHorizontalScrollview *instance = nib[0];
    return instance;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setup];
        [self setupWithFrame:frame];
    }
    return self;
}

- (void)setupWithFrame:(CGRect)frame{
    [self.scrollView setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    self.pageControl.center = CGPointMake(frame.size.width / 2, frame.size.height - 20);
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self setupWithFrame:frame];
}

- (void)setBounds:(CGRect)bounds{
    [super setBounds:bounds];
}

- (void)setup{
    //UIScrollView
    UIScrollView *scrollView = [[UIScrollView alloc]init];
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.pagingEnabled = YES;    
    [self addSubview:scrollView];
    
    _scrollView = scrollView;
    
    //PageControl
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    [self addSubview:pageControl];
    pageControl.pageIndicatorTintColor = RGB(0xffffff); //设置未激活的指示点颜色
    pageControl.currentPageIndicatorTintColor =RGB(0x64d3d8);

    _pageControl = pageControl;
    
    
}


@end
