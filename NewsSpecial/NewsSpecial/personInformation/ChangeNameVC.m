//
//  ChangeNameVC.m
//  weiliao
//
//  Created by 游成虎 on 16/11/3.
//  Copyright © 2016年 游成虎. All rights reserved.
//

#import "ChangeNameVC.h"

#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
@interface ChangeNameVC ()

/** textf */
@property (nonatomic,strong) UITextField * textF;

@end

@implementation ChangeNameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self setUpNav];
   // [_textF becomeFirstResponder];
}
- (void)setUpNav
{
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClicked)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
- (void)createUI
{
    UITextField * tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 90, SCREEN_SIZE.width, 44)];
    tf.layer.cornerRadius = 5.0;
    tf.layer.masksToBounds = YES;
    tf.layer.borderWidth = 1;
    tf.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    tf.font = [UIFont systemFontOfSize:14];
    tf.textAlignment = NSTextAlignmentLeft;
    tf.adjustsFontSizeToFitWidth = YES;
    UIImageView * leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    tf.leftView = leftView;
    // 左视图显示模式
    tf.rightViewMode =UITextFieldViewModeAlways;
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.clearsOnBeginEditing = YES;
    tf.text = self.name;
    _textF = tf;
    [self.view addSubview:tf];
}
#pragma mark - 保存昵称
- (void)rightBtnClicked
{
    NSLog(@"保存昵称");
}





@end
