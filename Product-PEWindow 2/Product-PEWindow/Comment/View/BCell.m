//
//  BCell.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/25.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "BCell.h"

@implementation BCell

- (void)awakeFromNib {
    self.descript.numberOfLines = 0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
