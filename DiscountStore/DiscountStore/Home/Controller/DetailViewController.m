//
//  DetailViewController.m
//  LOLInfo
//
//  Created by 游成虎 on 16/4/11.
//  Copyright © 2016年 游成虎. All rights reserved.
//

#import "DetailViewController.h"
//#import "UMSocial.h"

//<UMSocialUIDelegate>
@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation DetailViewController
//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    //可加载多次
//    //先加载DidLoad
//    self.navigationController.navigationBarHidden = NO;
//    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
//    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createWebView];
    [self buidlShare];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void)buidlShare
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 60, 44);
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"share_normal"] forState:UIControlStateNormal];
    UIBarButtonItem * right = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = right;

}
- (void)buttonClicked:(UIButton *)button{
    //shareToSnsNames 分享渠道
    //更改分享的链接 标题 类型等
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.link;
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://www.baidu.com";
//    //标题
//       [UMSocialData defaultData].extConfig.wechatSessionData.title = @"我喜欢下雨天";
//    //内容
//    //分享内容
//    [UMSocialData defaultData].extConfig.wxMessageType =UMSocialWXMessageTypeImage;
//
//    //更改QQ的分享链接
//    [UMSocialData defaultData].extConfig.qqData.url = @"http://www.taobao.com";
//    //qq空间分享 文字与图片缺一不可 不然会出现错误代码 10001
//    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"5629925367e58e55140015c0" shareText:@"看什么看" shareImage:[UIImage imageNamed:@"dog.png"] shareToSnsNames:@[UMShareToSina,UMShareToRenren,UMShareToTencent,UMShareToWechatSession,UMShareToWechatFavorite,UMShareToWechatTimeline,UMShareToQQ,UMShareToQzone] delegate:self];
}

- (void)createWebView
{
    NSURLRequest * request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.link]];
    [self.webView loadRequest:request];
    
}
@end







