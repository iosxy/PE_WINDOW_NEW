//
//  GameSenceCell.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/22.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "GameSenceCell.h"

@implementation GameSenceCell

- (void)awakeFromNib {
    
    self.backVIew.backgroundColor = [UIColor lightGrayColor];
    self.backVIew.alpha = 0.5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
