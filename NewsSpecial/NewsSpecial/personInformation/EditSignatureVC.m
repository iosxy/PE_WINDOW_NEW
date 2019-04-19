//
//  EditSignatureVC.m
//  weiliao
//
//  Created by 游成虎 on 16/11/3.
//  Copyright © 2016年 游成虎. All rights reserved.
//

#import "EditSignatureVC.h"

#define SCREEN_SIZE [[UIScreen mainScreen] bounds].size
@interface EditSignatureVC ()<UITextViewDelegate>

@property (nonatomic,strong) UITextView * signView;//个性签名
@property (nonatomic,strong) UILabel * numberLabel;//签名字数
@property(nonatomic, weak) UILabel *Label;

@end

@implementation EditSignatureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个性签名";
    [self createUI];
    [self setUpNav];
    [self.signView becomeFirstResponder];
    
}
- (void)setUpNav
{
    UIBarButtonItem * rightBtn = [[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(rightBtnClicked)];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}
- (void)createUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 84, SCREEN_SIZE.width - 20, 150)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.text = self.signStr;
    textView.delegate = self;
    _signView = textView;
    textView.font = [UIFont systemFontOfSize:15];
    textView.editable = YES;
    textView.selectable = YES;
    self.numberLabel = [[UILabel alloc]initWithFrame:CGRectMake(SCREEN_SIZE.width - 60, textView.frame.size.height - 50, 50, 50)];
    self.numberLabel.text = @"0/30";
    [self.view addSubview:textView];
    [textView addSubview:self.numberLabel];
    
}
#pragma mark - 保存签名
- (void)rightBtnClicked
{
    NSLog(@"保存签名");
}

#pragma mark - textDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/30",textView.text.length];
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //隐藏键盘
    [_signView resignFirstResponder];
}
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    self.numberLabel.text = [NSString stringWithFormat:@"%lu/30",textView.text.length];
}



@end
