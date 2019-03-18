//
//  YXYScrollPages.m
//  Day13ScrollPages
//
//  Created by qianfeng on 16/4/7.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "YXYScrollPages.h"
#define VIEW_SIZE self.bounds.size

@interface YXYScrollPages () <UIScrollViewDelegate>

/** 头部视图*/
@property (nonatomic,strong) UIView * headerView;
/** 底部滑块*/
@property (nonatomic,strong) UIView * indicatorView;
/** 滚动视图*/
@property (nonatomic,strong) UIScrollView * scrollView;
/** 按钮标题*/
@property (nonatomic,strong) NSArray * titles;

/** 当前选中项*/
@property (nonatomic,weak) UIButton * currentButton;
/** Call Back Block */
@property (nonatomic,copy) void (^callBack)(UIScrollView *, NSUInteger);


@end

@implementation YXYScrollPages

- (instancetype)initWithFrame:(CGRect)frame andTitles:(NSArray *)titles andCallBack:(void(^)(UIScrollView *scrollView, NSUInteger index))callBack
{
    if (self = [super initWithFrame:frame]) {
        self.titles = titles;
        self.callBack = callBack;
        //2.创建滚动视图
        [self createScrollView];
        //1.创建按钮
        [self addButtons];
        
        
        //3.调用callback
        self.callBack(self.scrollView, 0);
        
    }
    return self;
}

- (void)addButtons
{
    //添加按钮
    self.headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, VIEW_SIZE.width, 38)];
    for (int  i = 0; i < self.titles.count; i++) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(i * VIEW_SIZE.width / self.titles.count, 0, VIEW_SIZE.width / self.titles.count, self.headerView.bounds.size.height)];
        [button setTitle:self.titles[i] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:SELECTED_COLOR forState:UIControlStateSelected];
        if (i == 0) {
            button.selected = YES;
            self.currentButton = button;
        }
        
        button.tag = TAG_BEGIN + i;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        
        [self.headerView addSubview:button];
    }
    self.indicatorView = [[UIView alloc]initWithFrame:CGRectMake(0, self.headerView.bounds.size.height - 3, VIEW_SIZE.width / self.titles.count, 3)];
    self.indicatorView.backgroundColor = SELECTED_COLOR;
    [self.headerView addSubview:self.indicatorView];
    
    
    [self addSubview:self.headerView];
    
}

- (void)buttonClicked:(UIButton *)button
{
    //1.切换选中按钮
    self.currentButton.selected = NO;
    button.selected = YES;
    self.currentButton = button;
    //2.指示视图修改位置
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.frame = CGRectMake( button.frame.origin.x, self.indicatorView.frame.origin.y, self.indicatorView.frame.size.width, self.indicatorView.frame.size.height);
    }];
    //3.滚动视图的偏移量
    [self.scrollView setContentOffset:CGPointMake((button.tag - TAG_BEGIN) * self.scrollView.bounds.size.width, 0) animated:YES];
    //4.填充子视图
    self.callBack(self.scrollView, button.tag - TAG_BEGIN);
}

- (void)createScrollView
{
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0, VIEW_SIZE.width, VIEW_SIZE.height - self.headerView.bounds.size.height)];
    self.scrollView.contentSize = CGSizeMake(self.titles.count * self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    
    
    [self addSubview:self.scrollView];
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    //滚动结束()(修改button的选中项和UIview的位置)(可以直接看成button的点击事件)
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    UIButton * button = (id)[self viewWithTag:TAG_BEGIN + currentPage];
    [self buttonClicked:button];
    
}





@end
