//
//  YXYTabbarController.m
//  DiscountStore
//
//  Created by qianfeng on 16/4/15.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "YXYTabbarController.h"
#import "ClassViewController.h"
#import "CartViewController.h"
#import "MineViewController.h"
#import "FirstViewController.h"

@interface YXYTabbarController ()

@end

@implementation YXYTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTabbar];
}

- (void)setupTabbar
{
    FirstViewController * home = [[FirstViewController alloc]init];
    ClassViewController * class = [[ClassViewController alloc]init];
    CartViewController * cart = [[CartViewController alloc]init];
    MineViewController * mine = [[MineViewController alloc]init];
    NSMutableArray * array = [NSMutableArray arrayWithObjects:home,class,cart,mine, nil];
    //标题
    NSArray * titlesArr = @[@"首页", @"星闻 ", @"星程",@"我的"];
    //图片
    NSArray * normalImages = @[@"首页", @"爱豆星闻", @"行程",@"我的"];
    NSArray * selectImages = @[@"首页-1", @"爱豆星闻-1", @"行程-1",@"我的-1"];
    
    for (int i = 0; i < titlesArr.count; i++) {
        
        //得到每个视图控制器
        UIViewController * vc = array[i];
        //转化
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        //替换  视图控制器替换为导航栏控制器
        [array replaceObjectAtIndex:i withObject:nav];
        //标题
        vc.title = titlesArr[i];
        nav.navigationBar.tintColor = [UIColor whiteColor];
        nav.navigationBar.barTintColor = MainColor;
        
        //渲染模式
        UIImage * normalImage = [UIImage imageNamed:normalImages[i]];
        UIImage * selectedImage = [UIImage imageNamed:selectImages[i]];
        nav.tabBarItem.image = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    self.viewControllers = array;
    self.tabBar.tintColor = MainColor;
}


@end
