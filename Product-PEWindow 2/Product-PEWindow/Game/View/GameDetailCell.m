//
//  GameDetailCell.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/19.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "GameDetailCell.h"

@implementation GameDetailCell

- (void)awakeFromNib {
  
    self.sortNo.backgroundColor = YCOLOR_REDCOLOR;
    self.sortNo.layer.cornerRadius = self.sortNo.frame.size.height / 2;
    self.sortNo.clipsToBounds = YES;
    self.sortNo.backgroundColor = [UIColor lightGrayColor];
    UIView * view = [[UIView alloc]init];
    view.backgroundColor = [UIColor clearColor];
    self.backgroundView = view;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
   
    
}

@end
