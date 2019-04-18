//
//  TCHorizontalScrollview.h
//  GetOn
//
//  Created by 王骏超 on 15/5/29.
//  Copyright (c) 2015年 Tonchema. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCHorizontalScrollview : UIView

+ (instancetype)initFromBundle;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end
