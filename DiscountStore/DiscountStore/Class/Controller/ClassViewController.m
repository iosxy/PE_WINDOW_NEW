//
//  ClassViewController.m
//  DiscountStore
//
//  Created by qianfeng on 16/4/15.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "ClassViewController.h"
#import "SortViewController.h"
#import "SenceViewController.h"

@interface ClassViewController () <UIScrollViewDelegate>

/** 分类 */
@property (nonatomic,strong) SortViewController * sort;
/** 场景 */
@property (nonatomic,strong) SenceViewController * sence;

/** 头部视图 */
@property (nonatomic,strong) UIView * headerView;
/** 底部滑块 */
@property (nonatomic,strong) UIView * indicatorView;
/** 滚动视图 */
@property (nonatomic,strong) UIScrollView * scrollView;
/** 按钮标题 */
@property (nonatomic,strong) NSArray * titles;
/** 当前选中项 */
@property (nonatomic,weak) UIButton * currentButton;

/** 内存缓存 */
@property (nonatomic,strong) NSMutableDictionary * viewControllers;



@end

@implementation ClassViewController

- (void)viewDidLoad {
    
    self.viewControllers = [[NSMutableDictionary alloc]init];
    
    [super viewDidLoad];
    self.navigationItem.title = @"";
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _titles = @[@"分类",@"场景"];
    
    [self createScrollView];
    [self createUI];
   // self addChildViewController:<#(nonnull UIViewController *)#>
    
}

- (void)createUI
{
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    _headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, 100, 40)];
    
    for (int i = 0; i < _titles.count; i++) {
        UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake( i * 50, 0, 50, 40)];
        
        [button setTitle:_titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:SELECTED_COLOR forState:UIControlStateSelected];
        
        if (i == 0) {
            button.selected = YES;
            self.currentButton = button;
            [self addSubViewsForIndex:i];
        }
        button.tag = 5678 + i;
        
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchDown];
        
               [_headerView addSubview:button];
        
    }
    
    
    _indicatorView = [[UIView alloc]initWithFrame:CGRectMake( 0 , 37, 50, 3)];
    _indicatorView.backgroundColor = SELECTED_COLOR;
    
    
    [_headerView addSubview:_indicatorView];

    
     self.navigationItem.titleView = _headerView;
    
}

- (void)buttonClicked:(UIButton *)button
{
    //1.切换选中按钮
    self.currentButton.selected = NO;
    button.selected = YES;
    self.currentButton = button;
    //2.指示视图改变位置
    [UIView animateWithDuration:0.25 animations:^{
        self.indicatorView.frame = CGRectMake((button.tag - 5678) * 50, self.indicatorView.frame.origin.y, 50, self.indicatorView.frame.size.height);
    }];
    //3.滚动视图的偏移量
    [self.scrollView setContentOffset:CGPointMake((button.tag - 5678) * self.scrollView.bounds.size.width, 0) animated:YES];
    //4.填充子视图
    [self addSubViewsForIndex:button.tag- 5678];
}

#pragma mark - 滚动视图相关
- (void)createScrollView {
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, self.view.height)];
    self.scrollView.contentSize = CGSizeMake(self.titles.count * self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
    
    self.scrollView.pagingEnabled = YES;
    
    self.scrollView.delegate = self;
    
    [self.view addSubview:self.scrollView];
}

- (void)addSubViewsForIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                _sort = [[SortViewController alloc]init];
                _sort.view.frame = CGRectMake(index * self.scrollView.bounds.size.width, 0, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
                [self.view addSubview:_sort.view];
                [self addChildViewController:_sort];
                [self.scrollView addSubview:_sort.view];
               // [self.viewControllers setObject:_sort forKey:@(index).stringValue];
           });
            break;
        }
        case 1:
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                _sence = [[SenceViewController alloc]init];
                _sence.view.frame = CGRectMake(index * self.scrollView.bounds.size.width, 64, self.scrollView.bounds.size.width, self.scrollView.bounds.size.height);
                [self.view addSubview:_sence.view];
                [self addChildViewController:_sence];
                [self.scrollView addSubview:_sence.view];
               // [self.viewControllers setObject:_sence forKey:@(index).stringValue];
            });
            break;
        }
            
        default:
        
          break;
        
    }
    
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger currentPage = scrollView.contentOffset.x / scrollView.bounds.size.width;
    
    UIButton * button = [self.navigationItem.titleView viewWithTag:currentPage + 5678];
   
    [self buttonClicked:button];
    
}



@end
