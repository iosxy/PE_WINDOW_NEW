//
//  YCHTabBarViewController.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/18.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "YCHTabBarViewController.h"
#import "NewsViewController.h"
#import "GameViewController.h"
#import "CommentViewController.h"
#import "MineViewController.h"
#import "GameBaseViewController.h"
@interface YCHTabBarViewController ()

@end

@implementation YCHTabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
- (instancetype)init
{
    if (self = [super init]) {
        [self setTabBar];
}return self;
}
- (void)setTabBar
{
    NSArray * controllers = @[@"NewsViewController",@"GameBaseViewController",@"CommentViewController",@"MineViewController"];
    NSArray * titleArr = @[@"新闻",@"比赛",@"论坛",@"我的"];
    NSArray * nomorlImage = @[@"xinwen",@"jiangbei",@"zuqiu",@"wode"];
    NSArray * selectImage = @[@"xinwen_pre",@"jiangbei_pre",@"zuqiu_pre",@"wode_pre"];
    NSMutableArray * ViewControllers = [[NSMutableArray alloc]init];
    
    for (int i = 0; i < titleArr.count; i++) {
        
        Class class =NSClassFromString(controllers[i]);
        UIViewController * controller = [[class alloc]init];
        controller.title = titleArr[i];
        UITabBarItem * item = [[UITabBarItem alloc]initWithTitle:titleArr[i] image:[[UIImage imageNamed:nomorlImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  selectedImage:[[UIImage imageNamed:selectImage[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
       
        [controller setTabBarItem:item];
        
        
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:controller];
        nav.navigationBar.tintColor = [UIColor whiteColor];
        nav.navigationBar.barTintColor = RGB(0xffc000);
          nav.navigationBar.translucent = YES;
      
        [ViewControllers addObject:nav];
    }
    self.tabBar.tintColor = RGB(0xffc000);
    
    self.viewControllers = ViewControllers;
    
    
}



@end
