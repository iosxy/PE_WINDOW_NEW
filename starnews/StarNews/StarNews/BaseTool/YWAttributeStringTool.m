//
//  YWAttributeStringTool.m
//  Yuwan
//
//  Created by 欢瑞世纪 on 2018/6/8.
//  Copyright © 2018年 lqs. All rights reserved.
//

#import "YWAttributeStringTool.h"

@implementation YWAttributeStringTool
+ (NSMutableAttributedString *)changeStringToAttributeString:(NSMutableAttributedString *)textString range:(NSRange)range color:(UIColor *)color
{

     [textString addAttribute:NSForegroundColorAttributeName value:color range:range];
    
    return textString;
}
+ (NSMutableAttributedString *)changeStringToCenterString:(NSMutableAttributedString *)textString
{
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    // 设置文字居中
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [paragraphStyle setLineSpacing:6];
    
    [textString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [textString length])];
    [textString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.0] range:NSMakeRange(0, [textString length])];
    return textString;
}
+ (NSMutableAttributedString *)addBottomLine:(NSMutableAttributedString *)textString
{
    
    NSRange strRange = {0,[textString length]};
    
    [textString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    
    return textString;
}
@end
