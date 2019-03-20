//
//  TCTextView.m
//  GetOn
//
//  Created by LiuJian'e on 15/1/30.
//  Copyright (c) 2015年 Tonchema. All rights reserved.
//

#import "TCTextView.h"

#define MAX_LIMIT_NUMS  140

@interface TCTextView(){
    
    BOOL _autoHeight;
    NSLayoutConstraint *_heightConstaint;
    CGFloat _minHeight;
    CGFloat _maxHeight;
    
//    UILabel *_placeholdLabel;
    
    __weak id<UITextViewDelegate> _wrapDelegate;
}

@end

@implementation TCTextView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if( self = [super initWithCoder:aDecoder] ){
        [self setUp];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer{
    if( self = [super initWithFrame:frame textContainer:textContainer] ){
        [self setUp];
    }
    return self;
}


- (void) setUp{
    [super setDelegate:self];
    self.placeholdLeftPadding = 10;
    self.tintColor = RGB(0x333333);
    
    
}

- (void) setFrame:(CGRect)frame{
    [super setFrame:frame];
}

- (UILabel *)placeholdLabel {
    if( !_placeholdLabel ){
        _placeholdLabel = [UILabel new];
        _placeholdLabel.font = [UIFont systemFontOfSize:15];
        _placeholdLabel.textColor = RGB(0xbebdbd);
        _placeholdLabel.textAlignment = NSTextAlignmentCenter;
//        _placeholdLabel.frame = CGRectMake(5, 0, SCREEN_WIDTH - 50, 36);
//        _placeholdLabel.centerY = self.centerY;
        [self addSubview:_placeholdLabel];
        [_placeholdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self).offset(15);
            make.height.equalTo(@10);
        }];
        
    }
    return _placeholdLabel;
}
- (void) setPlacehold:(NSString *)placehold{
    self.placeholdLabel.text = placehold;
//    [_placeholdLabel sizeToFit];
    _placeholdLabel.left = self.placeholdLeftPadding;
    self.placeholdLabel.hidden = self.text.length;
}

- (void) layoutSubviews{
    [super layoutSubviews];
    //if( !(_placeholdLabel.top) ){
     //   _placeholdLabel.centerY = self.height >= self.font.lineHeight*2?7+_placeholdLabel.height/2:self.height/2;
    //}
}

- (void) setText:(NSString *)text{
    [super setText:text];
    [self textViewDidChange:self];
}

- (NSString*) placehold{
    return self.placeholdLabel.text;
}

- (void) setDelegate:(id<UITextViewDelegate>)delegate{
    _wrapDelegate = delegate;
}

- (void) setAutoHeight:(NSLayoutConstraint*)heightConstaint minHeight:(CGFloat)minHeight maxHeight:(CGFloat)maxHeight{
    _autoHeight = YES;
    _heightConstaint = heightConstaint;
    _minHeight = minHeight;
    _maxHeight = maxHeight;
}

- (void) setContentSize:(CGSize)contentSize{
    [super setContentSize:contentSize];
    [self autoHeight];
}

- (void) autoHeight{
    if( _autoHeight ){
        CGFloat contentHeight = self.contentSize.height;
        if( contentHeight < _minHeight + _minHeight/2 ){
            contentHeight = _minHeight;
        }else if( contentHeight > _maxHeight){
            contentHeight = _maxHeight;
        }
        if( fabs(_heightConstaint.constant - contentHeight) > 0.1 ){
            self.height = contentHeight;
            if( _heightConstaint ){
                _heightConstaint.constant = contentHeight;
                [self setNeedsUpdateConstraints];
            }
        }
    }
}

- (void) setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    if( hidden ){
        _heightConstaint.constant = _minHeight;
    }else{
        [self autoHeight];
    }
}

#pragma mark - textView delegate wrap


#define TCTEXTVIEW_WRAP_DELEGATE(func)\
if( [_wrapDelegate respondsToSelector:@selector(func:)] ){\
    return [_wrapDelegate func:textView];\
}\

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    TCTEXTVIEW_WRAP_DELEGATE(textViewShouldBeginEditing)
//    _placeholdLabel.frame = CGRectMake(10, 0, _placeholdLabel.width,_placeholdLabel.height);
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    TCTEXTVIEW_WRAP_DELEGATE(textViewShouldEndEditing)
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    TCTEXTVIEW_WRAP_DELEGATE(textViewDidBeginEditing)
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    TCTEXTVIEW_WRAP_DELEGATE(textViewDidEndEditing)
//    _placeholdLabel.frame = CGRectMake(10, 0, _placeholdLabel.width, self.height);
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if( [_wrapDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)] ){
        return [_wrapDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    //如果无文本，显示placeHold
    self.placeholdLabel.hidden = textView.text.length;
    TCTEXTVIEW_WRAP_DELEGATE(textViewDidChange)
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    TCTEXTVIEW_WRAP_DELEGATE(textViewDidChangeSelection)
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    if( [_wrapDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)] ){
        return [_wrapDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    }
    return NO;
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    if( [_wrapDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)] ){
        return [_wrapDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return NO;
}

@end
