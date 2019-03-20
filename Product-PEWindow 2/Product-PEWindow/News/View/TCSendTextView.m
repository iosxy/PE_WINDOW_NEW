//
//  TCSendMessageView.m
//  GetOn
//
//  Created by LiuJian'e on 15/1/17.
//  Copyright (c) 2015年 Tonchema. All rights reserved.
//

#import "TCSendTextView.h"

@interface TCSendTextView()

@end

@implementation TCSendTextView


- (void) setUpWithNibName:(NSString*)nibName{
    UIView *subview = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil].lastObject;
    [self addSubview:subview];
    
    [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"H:|-0-[subview]-0-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(subview)]];
    [self addConstraints:[NSLayoutConstraint
                          constraintsWithVisualFormat:@"V:|-0-[subview]-0-|"
                          options:NSLayoutFormatDirectionLeadingToTrailing
                          metrics:nil
                          views:NSDictionaryOfVariableBindings(subview)]];
    
    [self.textView setAutoHeight:self.textViewHeight minHeight:36 maxHeight:100];
    self.textView.delegate = self;
}

- (void) setUp{
    [self setUpWithNibName:@"TCSendTextView"];
//    self.textView.layer.borderWidth = 0.25;
//    self.textView.layer.borderColor = RGB(0).CGColor;
    self.textView.layer.cornerRadius = 3;
    self.textView.layer.masksToBounds = YES;
    self.textView.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
}

- (IBAction)onSendBtn:(id)sender {
    [self sendText];
}

- (void) sendText{
    NSString *text = _textView.text;
    if( !text.length ){
        return;
    }
    if( _onSendText ){
        _onSendText(text);
    }
}
- (void)setUpAppearance {
    self.backgroundColor = [UIColor blackColor];    //self.textView.backgroundColor = [UIColor clearColor];
//    self.textView.alpha = 0.5;
    self.textView.layer.cornerRadius = 18;
    self.textView.backgroundColor = RGB(0x2F2F2F);
    self.textView.textColor = RGB(0xBFBFBF);
    
    [self.sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}

#pragma mark - textView

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text; {
    if ([text isEqualToString:@"\n"]) {
        if( textView.text.length ){
            [self sendText];
        }
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
//    [self setControl:_emojiView.sendBtn enable:textView.text.length];
}

-(void) setControl:(UIControl*)control enable:(BOOL)enable{
    control.enabled = enable?YES:NO;
}

@end
