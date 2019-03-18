//
//  FootSenceTableViewCell.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/23.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "FootSenceTableViewCell.h"

@implementation FootSenceTableViewCell

- (void)awakeFromNib {
    self.backView.backgroundColor = [UIColor grayColor];
    self.backView.alpha = 0.7;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
