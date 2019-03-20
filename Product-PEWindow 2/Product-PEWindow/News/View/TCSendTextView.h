//
//  TCSendMessageView.h
//  GetOn
//
//  Created by LiuJian'e on 15/1/17.
//  Copyright (c) 2015年 Tonchema. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCTextView.h"

/** 发送文本 */
@interface TCSendTextView : UIView <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;

@property (weak, nonatomic) IBOutlet TCTextView *textView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;

@property (nonatomic,copy) void (^onSendText) (NSString* text);


- (void) setUpWithNibName:(NSString*)nibName;

- (void) sendText;
- (void) setUp;

//default no 是否此视图当前是可见的，手动控制
@property (nonatomic, assign, getter=isVisible) BOOL visible;
//default NO 是否在做动画,手动控制
@property (nonatomic, assign,getter=isAnimating ) BOOL animating;



@end
