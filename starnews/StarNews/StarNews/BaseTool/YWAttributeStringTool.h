//
//  YWAttributeStringTool.h
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/6/8.
//  Copyright © 2018年 lqs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface YWAttributeStringTool : NSObject

+ (NSMutableAttributedString *)changeStringToAttributeString:(NSMutableAttributedString *)textString range:(NSRange)range color:(UIColor *)color;
+ (NSMutableAttributedString *)changeStringToCenterString:(NSMutableAttributedString *)textString;

+ (NSMutableAttributedString *)addBottomLine:(NSMutableAttributedString *)textString;


@end
