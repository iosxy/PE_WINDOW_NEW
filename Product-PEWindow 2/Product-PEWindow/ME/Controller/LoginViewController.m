//
//  LoginViewController.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/26.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisteViewController.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationBar.tintColor =[UIColor blackColor];
    self.login.layer.cornerRadius = 5;
    self.login.clipsToBounds = YES;
    self.registe.layer.cornerRadius = 5;
    self.registe.clipsToBounds = YES;
}
- (BOOL)hidesBottomBarWhenPushed {
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    NSUserDefaults * user = [NSUserDefaults standardUserDefaults];
    if ([[user objectForKey:_phoneTf.text] isEqualToString:_mimaTf.text]) {
        [SVProgressHUD showSuccessWithStatus:@"登陆成功"];
        [user setObject:@"isLogin" forKey:@"isLogin"];
        [self.navigationController popViewControllerAnimated:YES];
    }else
    {
        [SVProgressHUD showErrorWithStatus:@"登陆失败"];
        [user setObject:@"noLogin" forKey:@"isLogin"];
    }
}
- (IBAction)registe:(id)sender {
    RegisteViewController * vc = [[RegisteViewController alloc]init];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}
@end
