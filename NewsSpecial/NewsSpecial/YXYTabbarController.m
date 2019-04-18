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
    NSArray * titlesArr = @[@"首页", @"分类", @"购物车",@"我的"];
    //图片
    NSArray * normalImages = @[@"tab_home~iphone", @"tab_search~iphone", @"tab_store~iphone",@"tab_me~iphone"];
    NSArray * selectImages = @[@"tab_home_h~iphone", @"tab_search_h~iphone", @"tab_store_h~iphone",@"tab_me_h~iphone"];
    
    for (int i = 0; i < titlesArr.count; i++) {
        
        //得到每个视图控制器
        UIViewController * vc = array[i];
        //转化
        UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:vc];
        //替换  视图控制器替换为导航栏控制器
        [array replaceObjectAtIndex:i withObject:nav];
        //标题
        vc.title = titlesArr[i];
        
        //渲染模式
        UIImage * normalImage = [UIImage imageNamed:normalImages[i]];
        UIImage * selectedImage = [UIImage imageNamed:selectImages[i]];
        nav.tabBarItem.image = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        nav.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
    }
    self.viewControllers = array;
}


@end
