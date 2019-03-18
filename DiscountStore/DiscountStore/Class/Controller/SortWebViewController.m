//
//  SortWebViewController.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/23.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "SortWebViewController.h"

@interface SortWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SortWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.title = self.text;
    
    [self createWeb];
    
    
}

- (void)createWeb
{
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
    [self.webView loadRequest:request];
}



@end
