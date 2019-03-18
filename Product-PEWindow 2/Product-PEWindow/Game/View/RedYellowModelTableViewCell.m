//
//  RedYellowModelTableViewCell.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/20.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "RedYellowModelTableViewCell.h"

@implementation RedYellowModelTableViewCell

- (void)awakeFromNib {
    self.sort.backgroundColor = YCOLOR_REDCOLOR;
    self.sort.layer.cornerRadius = self.sort.frame.size.height / 2;
    self.sort.clipsToBounds = YES;
    self.sort.backgroundColor = [UIColor lightGrayColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
