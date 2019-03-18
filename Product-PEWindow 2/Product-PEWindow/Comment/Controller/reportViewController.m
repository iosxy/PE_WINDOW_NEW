//
//  reportViewController.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/26.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "reportViewController.h"
#import "DetailVC.h"
@interface reportViewController ()

@end

@implementation reportViewController{
    UITextView * _view;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请输入举报内容";
    
   _view = [[UITextView alloc]initWithFrame:CGRectMake(20, 100, [[UIScreen mainScreen]bounds].size.width - 40, 160)];
    _view.backgroundColor =[UIColor grayColor];
   //_view.text = @"请输入举报内容";
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:_view];
    
    [self setUI];
}
- (void)setUI{
    UIButton * button = [[UIButton alloc]initWithFrame:CGRectMake(20, 270, 100, 30)];
    [button setTitle:@"举报" forState:UIControlStateNormal];
    button.layer.cornerRadius = 5;
    button.clipsToBounds = YES;
    button.backgroundColor = YCOLOR_BROWNCOLOR;
    [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    UIButton * button2 = [[UIButton alloc]initWithFrame:CGRectMake([[UIScreen mainScreen]bounds].size.width - 20 - 100, 270, 100, 30)];
    [button2 setTitle:@"返回" forState:UIControlStateNormal];
    button2.layer.cornerRadius = 5;
    button2.clipsToBounds = YES;
    button2.backgroundColor = YCOLOR_BROWNCOLOR;
    [button2 setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 101;
    button2.tag = 102;
    [self.view addSubview:button];
    [self.view addSubview:button2];
}
- (void)buttonClicked:(UIButton *)button{
    if (button.tag == 101) {
        
        if (_view.text.length != 0) {
            [SVProgressHUD showSuccessWithStatus:@"举报成功!"];
            [_view resignFirstResponder];
        }else
        {
            [SVProgressHUD showErrorWithStatus:@"请输入举报内容"];
        }
        
        
    }else
    {
               [_view resignFirstResponder];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
}
 -(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_view resignFirstResponder];
}

@end
