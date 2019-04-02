//
//  ADScrollView.h
//  Day13-CustomCell
//
//  Created by Naibin on 16/3/16.
//  Copyright © 2016年 Naibin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADScrollView : UIView <UIScrollViewDelegate>

@property (strong, nonatomic) UIPageControl *pageControl;

- (void)loadDataWithArray:(NSArray *)dataInfo;

@end
