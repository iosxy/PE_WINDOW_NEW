//
//  TCTextView.h
//  GetOn
//
//  Created by LiuJian'e on 15/1/30.
//  Copyright (c) 2015年 Tonchema. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCTextView : UITextView<UITextViewDelegate>

- (void) setAutoHeight:(NSLayoutConstraint*)heightConstaint minHeight:(CGFloat)minHeight maxHeight:(CGFloat)maxHeight;

@property (nonatomic) NSString* placehold;

@property (nonatomic) CGFloat placeholdLeftPadding;

@property (nonatomic) UILabel * placeholdLabel;

@end
