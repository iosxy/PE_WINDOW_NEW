//
//  TalkCell.m
//  Product-PEWindow
//
//  Created by qianfeng on 16/4/22.
//  Copyright (c) 2016年 qianfeng. All rights reserved.
//

#import "TalkCell.h"

@implementation TalkCell

- (void)awakeFromNib {

    self.headimg.layer.cornerRadius = 12;
    self.headimg.clipsToBounds = YES;
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
