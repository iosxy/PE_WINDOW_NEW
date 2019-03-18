//
//  HuancunViewController.m
//  DiscountStore
//
//  Created by qianfeng on 16/5/9.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "HuancunViewController.h"

@interface HuancunViewController ()

@end

@implementation HuancunViewController
{
    UILabel * _tv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self createUI];
    
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}
- (void)createUI
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = CGRectMake(100, 100, 100, 44);
    [button setTitle:@"清空缓存" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    _tv = [[UILabel alloc]initWithFrame:CGRectMake(125, 200, 100, 44)];
    NSString * str = [NSString stringWithFormat:@"%0.2fM",[self folderSizeAtPath:[NSString stringWithFormat:@"%@/Library/Caches/default",NSHomeDirectory()]]];
    _tv.text = str;
    [self.view addSubview:_tv];
    
    
}

- (void)buttonClicked:(UIButton *)button
{
    
  [self clearCacheFromPath:[NSString stringWithFormat:@"%@/Library/Caches/default",NSHomeDirectory()]];
    NSString * str = [NSString stringWithFormat:@"%0.2fM",[self folderSizeAtPath:[NSString stringWithFormat:@"%@/Library/Caches/default",NSHomeDirectory()]]];
    _tv.text = str;
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath])
        return 0;
    //通过枚举遍历法遍历文件夹中的所有文件
    //创建枚举遍历器
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    //首先声明文件名称、文件大小
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        //得到当前遍历文件的路径
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        //调用封装好的获取单个文件大小的方法
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);//转换为多少M进行返回
}
#pragma mark 清除缓存大小 打印NSHomeDritiony前往Documents进行查看路径
- (void)clearCacheFromPath:(NSString*)path{
    //建立文件管理器
    NSFileManager * manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:path]) {
        //如果文件路径存在 获取其中所有文件
        NSArray * fileArr = [manager subpathsAtPath:path];//找到所有子文件的路径，存到数组中。
        //首先需要转化为完整路径
        //直接删除所有子文件
        for (int i = 0; i < fileArr.count; i++) {
            NSString * fileName = fileArr[i];
            //完整路径
            NSString * filePath = [path stringByAppendingPathComponent:fileName];
            
            [manager removeItemAtPath:filePath error:nil];
        }
    }
}




@end
