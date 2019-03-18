//
//  YXYScrollView.m
//  Day13CustomCell
//
//  Created by qianfeng on 16/3/16.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "YXYScrollView.h"
#import "HomeModel.h"

@implementation YXYScrollView
{
    UIScrollView * _scrollView;
    UIPageControl * _pageControl;
    UILabel * _nameLabel;
    //图片信息
    NSMutableArray * _dataInfo;
    NSTimer * _timer;
    
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //创建子视图
        [self buildSubviews];
        //创建timer
        _timer = [NSTimer scheduledTimerWithTimeInterval:2.5 target:self selector:@selector(timerGo:) userInfo:nil repeats:YES];
        //创建好先暂停...填充完子视图再开启
        [_timer setFireDate:[NSDate distantFuture]];
        
    }
    return self;
}

- (void)dealloc
{
    if (_timer != nil) {
        [_timer invalidate];
    }
}

- (void)buildSubviews
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
    _scrollView.pagingEnabled = YES;
    //隐藏横向滚动条
    _scrollView.showsHorizontalScrollIndicator = NO;
    
    _scrollView.delegate = self;
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.bounds.size.width - 120, self.height - 25, 140, 25)];
    //选中小圆点的颜色
    _pageControl.currentPageIndicatorTintColor = [UIColor colorWithWhite:0.7 alpha:0.9];
    //未选中的
    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:0.1 alpha:0.8];
    
    [_pageControl addTarget:self action:@selector(pagging:) forControlEvents:UIControlEventTouchUpInside];
    
    _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.height - 25, self.bounds.size.width, 25)];
    _nameLabel.backgroundColor = [UIColor colorWithRed:207 / 255.0 green:178 / 255.0 blue:202 / 255.0 alpha:1];
    _nameLabel.textColor = [UIColor colorWithWhite:0.3 alpha:0.9];
    _nameLabel.font = [UIFont systemFontOfSize:12];
    
    [self addSubview:_scrollView];
   // [self addSubview:_nameLabel];
    [self addSubview:_pageControl];
    
}

//填充子视图
- (void)loadDataWithArray:(NSArray *)dataInfo
{
   
    
    [_dataInfo setArray:dataInfo];
    
   // [_dataInfo addObject:dataInfo.firstObject];
    
    //pageControl
    _pageControl.numberOfPages = dataInfo.count;
    _pageControl.currentPage = 0;
    //初始化标题内容
   // _nameLabel.text = [NSString stringWithFormat:@"   %@",[dataInfo[0] title]];
   
    
    //滚动视图1.创建2.添加子视图
    for (int i = 0; i < dataInfo.count + 1; i++) {
        
      //  _nameLabel.text = [dataInfo[i] title];
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i * self.bounds.size.width , 0, self.bounds.size.width, self.bounds.size.height)];
        if (i == dataInfo.count) {
            //最后一项的特殊处理
            [imageView sd_setImageWithURL:[NSURL URLWithString:[dataInfo[i - 1] iphoneimgnew]] placeholderImage:[UIImage imageNamed:@""]];
           
            //添加子视图
            [_scrollView addSubview:imageView];
            
            break;
        }
        
        NSURL * url = [NSURL URLWithString:[dataInfo[i] iphoneimgnew]];
        
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@""]];
        
        //添加子视图
        [_scrollView addSubview:imageView];
        
    }
    //设置包含内容的大小
    _scrollView.contentSize = CGSizeMake((dataInfo.count + 1) * self.bounds.size.width, self.bounds.size.height);
   
    //多线程,延迟执行某些代码
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         //开启定时器
        [_timer setFireDate:[NSDate distantPast]];

    });
  }
#pragma mark - timer
- (void)timerGo:(NSTimer *)timer
{
    //修改滚动视图的偏移量
    NSUInteger currentPage = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    [_scrollView setContentOffset:CGPointMake((currentPage + 1) * _scrollView.bounds.size.width, 0) animated:YES];
    
}


#pragma mark - pageControl

- (void)pagging:(UIPageControl *)pgc
{
    NSInteger currentPage = pgc.currentPage;
    [_scrollView setContentOffset:CGPointMake(currentPage * _scrollView.bounds.size.width, 0) animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //停止
    NSUInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    NSUInteger wholePages = scrollView.contentSize.width / scrollView.bounds.size.width;
    
    //最后一页
    if (currentPage == wholePages - 1) {
        [scrollView setContentOffset:CGPointZero animated:NO];
        currentPage = 0;
    }
    
    _pageControl.currentPage = currentPage;
//    if ([_dataInfo[currentPage] title] != nil) {
//        _nameLabel.text = [NSString stringWithFormat:@"   %@",[_dataInfo[currentPage] title]];
//    }
    
    
}


@end
