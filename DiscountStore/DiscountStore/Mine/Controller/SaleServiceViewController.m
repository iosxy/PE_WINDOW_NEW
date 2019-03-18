//
//  SaleServiceViewController.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/27.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "SaleServiceViewController.h"

@interface SaleServiceViewController ()

@end

@implementation SaleServiceViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"售后";
}



@end
