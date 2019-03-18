//
//  SettingViewController.m
//  DiscountStore
//
//  Created by 游成虎 on 16/4/27.
//  Copyright © 2016年 qianfeng. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()
@property (weak, nonatomic) IBOutlet UITextView *myTextView;

@end


@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"反馈";
    
}
- (IBAction)buttonClicked:(id)sender {
    
    [SVProgressHUD showSuccessWithStatus:@"发送成功"];
    
}


@end
